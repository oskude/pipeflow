import os
import json
import subprocess
from PySide6.QtCore import QObject, Slot

class PWCli(QObject):
	def set_param(self, args):
		subprocess.run(["pw-cli", "set-param"] + args, stdout=subprocess.DEVNULL)
	@Slot(int, float)
	def set_volume(self, object_id, vol):
		data = json.dumps({
			"volume": vol
		})
		self.set_param([str(object_id), "Props", data])
	@Slot(int, list)
	def set_channel_volumes(self, object_id, vols):
		data = json.dumps({
			"channelVolumes": vols
		})
		self.set_param([str(object_id), "Props", data])
