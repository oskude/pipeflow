import os
import subprocess
from PySide6.QtCore import QObject, Slot
import logging

class PWLink(QObject):
	log = logging.getLogger("main")
	def pw_link(self, args):
		subprocess.run(["pw-link"] + args)
	@Slot(int, int)
	def crete_link(self, output_id, input_id):
		self.pw_link([str(output_id), str(input_id)])
		self.log.debug("ADDED link %d -> %d", input_id, output_id)
	@Slot(int)
	def remove_link_by_id(self, link_id):
		self.pw_link(["-d", str(link_id)])
		self.log.debug("REMOVED link %d", link_id)
