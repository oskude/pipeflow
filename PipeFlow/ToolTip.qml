import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import PipeFlow as My

Row {
	id: root
	property string text
	property color color: Theme.colorLayer3
	spacing: 0
	Shape {
		id: shape
		//rotation: 90
		width: Math.round(txt.height/2)
		height: txt.height
		layer.enabled: true
		layer.samples: 8
		ShapePath {
			strokeWidth: 0
			strokeColor: "transparent"
			fillColor: root.color
			startX: 0
			startY: Math.round(shape.height/2)
			PathLine {
				x: shape.width
				y: 0
			}
			PathLine {
				x: shape.width
				y: shape.height
			}
			PathLine {
				x: 0
				y: Math.round(shape.height/2)
			}
		}
	}
	Rectangle {
		id: rect
		color: root.color
		width: txt.width
		height: txt.height
		My.Text {
			id: txt
			text: root.text
			color: Theme.colorLayer0
			leftPadding: Theme.padding
			rightPadding: leftPadding
		}
	}
}
