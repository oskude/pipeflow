import typing

from dataclasses import dataclass, fields
from PySide6.QtCore import Property, Signal, QProcess, QAbstractListModel, QByteArray, Qt, QModelIndex

from .port import Port, PortModel
from .real import Real, RealModel

@dataclass
class Node:
	node_label: str
	node_id: int
	node_api: str
	node_type: str
	node_state: str
	chnvols: RealModel
	inports: PortModel
	outports: PortModel

class NodeModel (QAbstractListModel):
	def __init__(self, parent=None):
		super().__init__(parent=parent)
		self._node_list = []

	def data(self, index: QModelIndex, role: int = Qt.DisplayRole) -> typing.Any:
		if 0 <= index.row() < self.rowCount():
			node = self._node_list[index.row()]
			name = self.roleNames().get(role)
			if name:
				return getattr(node, name.decode())

	def set_data(self, node_id, value, role):
		row, node = self.get_node_by_id(node_id)
		if node:
			setattr(node, role, value)
			idx = self.index(row, 0)
			self.dataChanged.emit(idx, idx, [role])
			return True
		return False

	def roleNames(self) -> dict[int, QByteArray]:
		d = {}
		for i, field in enumerate(fields(Node)):
			d[Qt.DisplayRole + i] = field.name.encode()
		return d

	def rowCount(self, index: QModelIndex = QModelIndex()) -> int:
		return len(self._node_list)

	def add_node(self, node: Node) -> None:
		self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
		self._node_list.append(node)
		self.endInsertRows()

	def add_node_inport(self, node_id:int, port:Port):
		for row, node in enumerate(self._node_list):
			if node.node_id == node_id:
				node.inports.add_port(port)

	def add_node_outport(self, node_id:int, port:Port):
		for row, node in enumerate(self._node_list):
			if node.node_id == node_id:
				node.outports.add_port(port)

	def rem_node_by_id(self, id:int) -> bool:
		for row, node in enumerate(self._node_list):
			if node.node_id == id:
				self.beginRemoveRows(QModelIndex(), row, row)
				self._node_list = self._node_list[:row] + self._node_list[row + 1 :]
				self.endRemoveRows()
				return True
		return False

	def get_node_by_id(self, id:int) -> (int, Node):
		for row, node in enumerate(self._node_list):
			if node.node_id == id:
				return row, node
		return None, None

	def get_inport_by_id(self, node_id:int, port_id:int) -> Port:
		for node in self._node_list:
			if node.node_id == node_id:
				return node.inports.get_port_by_id(port_id)
		return None

	def get_outport_by_id(self, node_id:int, port_id:int) -> Port:
		for node in self._node_list:
			if node.node_id == node_id:
				return node.outports.get_port_by_id(port_id)
		return None

	def rem_inport_by_id(self, port_id:int) -> bool:
		for node in self._node_list:
			if node.inports.rem_port_by_id(port_id):
				return True
		return False

	def rem_outport_by_id(self, port_id:int) -> bool:
		for node in self._node_list:
			if node.outports.rem_port_by_id(port_id):
				return True
		return False
