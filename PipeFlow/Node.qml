import QtQuick
import QtQuick.Layouts
import PipeFlow as My

Rectangle {
	id: root
	property string label
	property int nodeId
	property string nodeState
	property string nodeType
	property string nodeApi
	property var chnVols: []
	property var inPorts
	property var outPorts
	color: Theme.colorLayer1
	width: childrenRect.width
	height: childrenRect.height
	radius: Theme.margin

	function findPortById (portId) {
		for (let port of inPortLayout.children) {
			if (port && port instanceof My.Port && port.portId === portId) return port
		}
		for (let port of outPortLayout.children) {
			if (port && port instanceof My.Port && port.portId === portId) return port
		}
	}

	ColumnLayout {
		spacing: 1
		My.NodeHeader {
			Layout.fillWidth: true
			label: root.label
			nodeId: root.nodeId
			nodeState: root.nodeState
			nodeType: root.nodeType
			nodeApi: root.nodeApi
			chnVols: root.chnVols
			MouseArea {
				width: parent.width
				height: parent.height
				drag.target: root
				drag.smoothed: false
				drag.threshold: 0
				onPressed: hideToolTip()
			}
		}
		Repeater {
			model: root.chnVols
			My.Slider {
				Layout.fillWidth: true
				Layout.leftMargin: Theme.margin
				Layout.rightMargin: Theme.margin
				value: val
				infoText: [
					"("+root.nodeId+") Node channelVolumes " + index + " : " + modelData,
					"- Left click to set volume at cursor"
				].join("\n")
				onRequestValueChanged: {
					PwCli.set_channel_volumes(root.nodeId, [requestValue, requestValue])
				}
			}
		}
		Item {
			visible: root.chnVols.rowCount() > 0 // TODO: should we implement count attribute in python?
			width: 10
			height: Theme.margin
		}
		RowLayout {
			width: parent.width
			spacing: Theme.margin
			ColumnLayout {
				id: inPortLayout
				Layout.fillWidth: true
				spacing: 1
				Repeater {
					model: root.inPorts
					My.Port {
						Layout.fillWidth: true
						label: port_label
						portId: port_id
						align: Text.AlignHCenter
						node: root
						portDir: 1
					}
				}
			}

			ColumnLayout {
				id: outPortLayout
				Layout.fillWidth: true
				spacing: 1
				Repeater {
					model: root.outPorts
					My.Port {
						Layout.fillWidth: true
						label: port_label
						portId: port_id
						align: Text.AlignHCenter
						node: root
						portDir: 0
					}
				}
			}
		}
		// spacer for rounded corners
		Item {
			height: root.radius
			width: 1
		}
	}
}
