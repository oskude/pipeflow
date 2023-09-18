import QtQuick
import QtQuick.Layouts
import PipeFlow as My

Item {
	id: root
	property string label
	property int nodeId
	property string nodeState
	property string nodeType
	property string nodeApi
	property var chnVols: [0.25, 0.5]
	implicitWidth: layout.width
	implicitHeight: layout.height
	ColumnLayout {
		id: layout
		spacing: 1
		RowLayout {
			spacing: 0
			TheText {
				text: root.label
				toolTip: [
					"("+root.nodeId+") Node Label : " + root.label,
					"- Left press and drag to move Node"
				].join("\n")
				defaultColor: Theme.colorLayer3
			}
			TheText {
				property string a: root.nodeApi ? root.nodeApi[0].toUpperCase() : "?"
				text: a
				toolTip: [
					"(" + root.nodeId + ") Node API : " + root.nodeApi,
					"- Left press and drag to move Node"
				].join("\n")
				leftPadding: 0
			}
			TheText {
				text: root.nodeType[0].toUpperCase()
				toolTip: [
					"(" + root.nodeId + ") Node Type : " + root.nodeType,
					"- Left press and drag to move Node"
				].join("\n")
				leftPadding: 0
			}
			Item {
				width: stateDot.width + Theme.margin
				height: stateDot.height
				Rectangle {
					id: stateDot
					property string toolTip: [
						"(" + root.nodeId + ") Node State : " + root.nodeState,
						"- Left press and drag to move Node"
					].join("\n")
					property var stateColors: ({
						error: Theme.colorRedLow,
						creating: Theme.colorBlueLow,
						suspended: Theme.colorLayer2,
						idle: Theme.colorYellowLow,
						running: Theme.colorGreenLow
					})
					color: stateColors[root.nodeState]
					width: Theme.fontPixelSize
					height: width
					radius: height
					MouseArea {
						id: mouseArea
						width: parent.width
						height: parent.height
						hoverEnabled: true
						onContainsMouseChanged: {
							if (containsMouse) {
								//showToolTip(stateDot)
								setInfoText(stateDot.toolTip)
							}
						}
					}
				}
			}
		}
	}
	component TheText: My.Text {
		topPadding: Theme.padding
		bottomPadding: Theme.padding
		leftPadding: Theme.padding * 2
		rightPadding: Theme.padding * 2
		defaultColor: Theme.colorLayer2
	}
}
