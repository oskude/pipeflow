import json
import logging

from PySide6.QtCore import QObject
from PySide6.QtCore import Property, Signal, QProcess, QAbstractListModel, QByteArray, Qt, QModelIndex

from .node import Node, NodeModel
from .port import Port, PortModel
from .link import Link, LinkModel
from .real import Real, RealModel

class PWMon (QObject):
	def __init__(self, nodeModel:NodeModel, linkModel:LinkModel, parent=None):
		self.log = logging.getLogger("main")
		self.p = QProcess()
		self.p.readyReadStandardOutput.connect(self.handleStdout)
		self.p.start("pw-dump", ["--no-colors", "--monitor"])
		self.nodeModel = nodeModel
		self.linkModel = linkModel
		self.action = None
		self.moarjson = ""
	def handleStdout (self):
		rawdata = self.p.readAllStandardOutput()
		stdout = bytes(rawdata).decode("utf8")
		if not stdout.endswith("\n]\n"):
			self.moarjson = self.moarjson + stdout
		else:
			lists = (self.moarjson + stdout).split("\n]\n")
			self.moarjson = ""
			for entry in lists:
				if entry.strip() == "":
					continue
				entry = entry + "]"
				data = json.loads(entry)
				for item in data:
					if not "info" in item:
						# TODO: do we want these?
						continue

					id = item["id"]

					# REMOVE
					# if item.info is null, its a removal https://gitlab.freedesktop.org/pipewire/pipewire/-/commit/47e1f38f03adea1e2d00c56b8915ba054e8b73b0
					if item["info"] is None:
						if self.linkModel.rem_link_by_id(id):
							self.log.debug("REMOVED link %d", id)
						elif self.nodeModel.rem_inport_by_id(id):
							self.log.debug("REMOVED inport %d", id)
						elif self.nodeModel.rem_outport_by_id(id):
							self.log.debug("REMOVED outport %d", id)
						elif self.nodeModel.rem_node_by_id(id):
							self.log.debug("REMOVED node %d", id)
						else:
							self.log.debug("TODO remove %d ?", id)
						continue

					info = item["info"]
					props = info["props"]

					# Node
					if item["type"] == "PipeWire:Interface:Node":
						name = props["node.name"]
						if "node.nick" in props:
							name = props["node.nick"]
						row, node = self.nodeModel.get_node_by_id(id)
						if node:
							if "state" in info["change-mask"]:
								self.nodeModel.set_data(id, info["state"], "node_state")
								self.log.debug("UPDATED state %d %s", id, info["state"])
							elif "params" in info ["change-mask"]:
								if "channelVolumes" in info["params"]["Props"][0]:
									for i, vol in enumerate(info["params"]["Props"][0]["channelVolumes"]):
										node.chnvols.set_data(i, vol, "val")
									self.log.debug("UPDATED params channelVolumes %d", id)
							else:
								self.log.debug("TODO update node %d %s", id, info["change-mask"])
						else:
							_api = "?"
							if "device.api" in props:
								_api = props["device.api"]
							if "client.api" in props:
								_api = props["client.api"]
							_type = "?"
							if "media.class" in props:
								_type = props["media.class"]
							if "media.type" in props:
								_type = props["media.type"]
							_chnVols = RealModel()
							if "Props" in info["params"]:
								if "channelVolumes" in info["params"]["Props"][0]:
									for real in info["params"]["Props"][0]["channelVolumes"]:
										_chnVols.add_real(Real(real))
							self.nodeModel.add_node(Node(name, id, _api, _type, info["state"], _chnVols, PortModel(), PortModel()))
							self.log.debug("ADDED node %d '%s'", id, name)

					# Port
					elif item["type"] == "PipeWire:Interface:Port":
						node_id = props["node.id"]
						port_name = props["port.name"]
						port_id = props["object.id"]
						if info["direction"] == "input":
							inport = self.nodeModel.get_inport_by_id(node_id, port_id)
							if inport:
								self.log.debug("TODO update node inport %d.%d", node_id, port_id)
							else:
								self.nodeModel.add_node_inport(node_id, Port(port_name, port_id))
						elif info["direction"] == "output":
							outport = self.nodeModel.get_outport_by_id(node_id, port_id)
							if outport:
								self.log.debug("TODO update node outport %d.%d", node_id, port_id)
							else:
								self.nodeModel.add_node_outport(node_id, Port(port_name, port_id))
								self.log.debug("ADDED outport %d.%d", node_id, port_id)
						else:
							self.log.debug("TODO can this happen?")

					# Link
					elif item["type"] == "PipeWire:Interface:Link":
						link = self.linkModel.get_link_by_id(id)
						if link:
							self.log.debug("TODO update link %d", id)
						else:
							self.linkModel.add_link(Link(
								id,
								info["output-node-id"],
								info["output-port-id"],
								info["input-node-id"],
								info["input-port-id"]
							))
							self.log.debug("ADDED link %d", id)

					# IGNORE: Factory, Module TODO: do we need these for anyhting?
					elif item["type"] == "PipeWire:Interface:Factory" or item["type"] == "PipeWire:Interface:Module":
						pass

					# TODO: should we show clients?
					elif item["type"] == "PipeWire:Interface:Client":
						self.log.debug("TODO add? %d %s '%s'", id, item["type"].split(":")[-1], props["application.name"])

					else:
						self.log.debug("TODO add? %d %s", id, item["type"].split(":")[-1])
