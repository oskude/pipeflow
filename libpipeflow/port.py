import typing

from dataclasses import dataclass, fields
from PySide6.QtCore import Property, Signal, QProcess, QAbstractListModel, QByteArray, Qt, QModelIndex

@dataclass
class Port:
	port_label: str
	port_id: int

class PortModel(QAbstractListModel):
	def __init__(self, parent=None):
		super().__init__(parent=parent)
		self._port_list = []

	def data(self, index: QModelIndex, role: int = Qt.DisplayRole) -> typing.Any:
		if 0 <= index.row() < self.rowCount():
			node = self._port_list[index.row()]
			name = self.roleNames().get(role)
			if name:
				return getattr(node, name.decode())

	def roleNames(self) -> dict[int, QByteArray]:
		d = {}
		for i, field in enumerate(fields(Port)):
			d[Qt.DisplayRole + i] = field.name.encode()
		return d

	def rowCount(self, index: QModelIndex = QModelIndex()) -> int:
		return len(self._port_list)

	def add_port(self, port: Port) -> None:
		self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
		self._port_list.append(port)
		self.endInsertRows()

	def rem_port_by_id(self, id:int) -> bool:
		for row, port in enumerate(self._port_list):
			if port.port_id == id:
				self.beginRemoveRows(QModelIndex(), row, row)
				self._port_list = self._port_list[:row] + self._port_list[row + 1 :]
				self.endRemoveRows()
				return True
		return False

	def get_port_by_id(self, id:int) -> Port:
		for row, port in enumerate(self._port_list):
			if port.port_id == id:
				return port
		return None
