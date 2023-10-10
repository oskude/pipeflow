import QtQuick
import PipeFlow as My

Rectangle {
	id: root
	property string label
	property int portId
	property int align: Text.AlignLeft
	property int portDir // 0 = output, 1 = input
	property Item node: Item{}
	                    // lol, node.x is only here so that we get triggered ;P TODO? better way?
	property int linkX: (node.x - node.x) + (node.y - node.y) + mapToItem(canvas, portDir === 0 ? width : x, 0).x
	property int linkY: (node.x - node.x) + (node.y - node.y) + mapToItem(canvas, 0, Math.round(height/2)).y
	implicitWidth: text.contentWidth
	implicitHeight: text.height
	color: linkBuffer[portDir].includes(portId) ? Theme.colorPriLow : Theme.colorLayer2
	My.Text {
		id: text
		text: root.label
		toolTip: [
			"("+root.portId+") Port Label : " + root.label,
			"- Left click to de-/select or de-/link",
			"- Right click to remove connected Link(s)"
		].join("\n")
		width: root.width // TODO: this cause polis loop
		defaultColor: Theme.colorLayer1
		padding: 0
		leftPadding: Theme.padding
		rightPadding: leftPadding
		horizontalAlignment: root.align
		elide: Text.ElideLeft
	}
	MouseArea {
		anchors.fill: parent // TODO: this also cause polish loop?
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		onClicked: function (mouse) {
			if (mouse.button == Qt.LeftButton) {
				linkAllTheThings(root.portDir, root.portId)
			} else if (mouse.button == Qt.RightButton) {
				let linkIds = findLinkIdsByPortId(root.portId)
				for (let linkId of linkIds) {
					PwLink.remove_link_by_id(linkId)
				}
			}
		}
	}
}
