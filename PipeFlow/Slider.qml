import QtQuick
import PipeFlow as My

Rectangle {
	id: root
	property real value
	property real requestValue
	property int maxw: Math.round(width - thumb.width)
	property string infoText
	color: Theme.colorLayer0
	implicitWidth: valText.width
	implicitHeight: valText.height
	Rectangle {
		id: thumb
		x: Math.round(maxw * value)
		height: root.height
		width: Theme.fontPixelSize
		color: mouseArea.containsMouse ? Theme.colorPriLow : Theme.colorLayer2
	}
	My.Text {
		id: valText
		text: Math.round(root.value * 100) + "%"
		width: root.width
		horizontalAlignment: Text.AlignHCenter
		color: Theme.colorLayer1
	}
	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		onEntered: {
			setInfoText(root.infoText)
		}
		onPressed: function () {
			hideToolTip()
			timer.start()
		}
		onReleased: function () {
			timer.stop()
		}
		Timer {
			id: timer
			interval: 100 // we dont want to call pw-cli faster than this
			triggeredOnStart: true
			repeat: true
			onTriggered: root.requestValue = clamp(mouseArea.mouseX / root.width, 0, 1)
		}
	}
}
