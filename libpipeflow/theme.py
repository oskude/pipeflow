from PySide6.QtCore import QObject, Property, Signal
from PySide6.QtGui import QColor
import configparser

class Theme(QObject):
	todo = Signal()

	def __init__(self, ini_file, parent=None):
		super().__init__(parent)
		config = configparser.ConfigParser()
		config.read(ini_file)
		self.theme = config["pipeflow"]

	@Property(int, notify=todo)
	def fontPixelSize(self):
		return int(self.theme["fontPixelSize"])

	@Property(int, notify=todo)
	def padding(self):
		return int(int(self.theme["fontPixelSize"]) / 4)

	@Property(int, notify=todo)
	def margin(self):
		return int(int(self.theme["fontPixelSize"]) / 2)

	@Property(str, notify=todo)
	def fontFamily(self):
		return str(self.theme["fontFamily"])

	@Property(float, notify=todo)
	def linkWidth(self):
		return float(self.theme["linkWidth"])

	@Property(list, notify=todo)
	def hideNodes(self):
		return list(self.theme["hideNodes"].split(","))

	@Property('QColor', notify=todo)
	def colorLayer0(self):
		return QColor(self.theme["colorLayer0"])

	@Property('QColor', notify=todo)
	def colorLayer1(self):
		return QColor(self.theme["colorLayer1"])

	@Property('QColor', notify=todo)
	def colorLayer2(self):
		return QColor(self.theme["colorLayer2"])

	@Property('QColor', notify=todo)
	def colorLayer3(self):
		return QColor(self.theme["colorLayer3"])

	@Property('QColor', notify=todo)
	def colorPriHi(self):
		return QColor(self.theme["colorPriHi"])

	@Property('QColor', notify=todo)
	def colorPriLow(self):
		return QColor(self.theme["colorPriLow"])

	@Property('QColor', notify=todo)
	def colorGreenHi(self):
		return QColor(self.theme["colorGreenHi"])

	@Property('QColor', notify=todo)
	def colorGreenLow(self):
		return QColor(self.theme["colorGreenLow"])

	@Property('QColor', notify=todo)
	def colorRedHi(self):
		return QColor(self.theme["colorRedHi"])

	@Property('QColor', notify=todo)
	def colorRedLow(self):
		return QColor(self.theme["colorRedLow"])

	@Property('QColor', notify=todo)
	def colorYellowHi(self):
		return QColor(self.theme["colorYellowHi"])

	@Property('QColor', notify=todo)
	def colorYellowLow(self):
		return QColor(self.theme["colorYellowLow"])

	@Property('QColor', notify=todo)
	def colorBlueHi(self):
		return QColor(self.theme["colorBlueHi"])

	@Property('QColor', notify=todo)
	def colorBlueLow(self):
		return QColor(self.theme["colorBlueLow"])

	#@colorLayer0.setter
	#def colorLayer0(self, n):
	#	self._colorLayer0 = n
	#	self.colorLayer0_changed.emit()
