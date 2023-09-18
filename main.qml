import QtQuick
import QtQuick.Layouts
import PipeFlow as My

Window {
	id: root
	title: "pipeflow"
	width: 320
	height: 320
	visible: true
	color: Theme.colorLayer0
	My.Canvas {
		anchors.fill: parent
	}
	Rectangle {
		color: Theme.colorLayer1
		visible: infoText.text.length > 0
		width: parent.width
		height: infoText.height
		anchors.bottom: parent.bottom
		border.width: 1
		border.color: Theme.colorLayer0
		My.Text {
			id: infoText
			width: parent.width
			text: "Hello World!"
			color: Theme.colorLayer2
			padding: Theme.padding
			leftPadding: padding * 2
			rightPadding: padding * 2
			wrapMode: Text.WrapAnywhere
		}
	}
	function setInfoText (txt) {
		infoText.text = txt
	}
}
