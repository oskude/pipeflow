import typing

from dataclasses import dataclass, fields
from PySide6.QtCore import Property, Signal, QProcess, QAbstractListModel, QByteArray, Qt, QModelIndex

@dataclass
class Link:
	link_id: int
	output_node_id: int
	output_port_id: int
	input_node_id: int
	input_port_id: int

class LinkModel (QAbstractListModel):
	def __init__(self, parent=None):
		super().__init__(parent=parent)
		self._link_list = []

	def data(self, index: QModelIndex, role: int = Qt.DisplayRole) -> typing.Any:
		if 0 <= index.row() < self.rowCount():
			link = self._link_list[index.row()]
			name = self.roleNames().get(role)
			if name:
				return getattr(link, name.decode())

	def roleNames(self) -> dict[int, QByteArray]:
		d = {}
		for i, field in enumerate(fields(Link)):
			d[Qt.DisplayRole + i] = field.name.encode()
		return d

	def rowCount(self, index: QModelIndex = QModelIndex()) -> int:
		return len(self._link_list)

	def add_link(self, link: Link) -> None:
		self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
		self._link_list.append(link)
		self.endInsertRows()

	def rem_link_by_id(self, link_id:int) -> bool:
		for row, link in enumerate(self._link_list):
			if link.link_id == link_id:
				self.beginRemoveRows(QModelIndex(), row, row)
				self._link_list = self._link_list[:row] + self._link_list[row + 1 :]
				self.endRemoveRows()
				return True
		return False

	def get_link_by_id(self, link_id:int) -> Link:
		for link in self._link_list:
			if link.link_id == link_id:
				return link
		return None
