import QtQuick
import QtQuick.Shapes
import PipeFlow as My

Shape {
	id: root
	property int index
	property int linkId
	property real fooX: inPort && outPort ? Math.abs(inPort.linkX - outPort.linkX) / 2 : 10
	property real fooY: inPort && outPort ? Math.abs(inPort.linkY - outPort.linkY) / 2 : 10
	property real foo: Math.min(fooX, fooY)
	property real curve: foo < 40 ? foo : 40
	property Item outPort
	property Item inPort
	opacity: 0.5
	ShapePath {
		id: shapePath
		fillColor: "transparent"
		strokeColor: Theme.colorLayer3
		strokeWidth: Theme.linkWidth
		capStyle: ShapePath.RoundCap
		startX: outPort ? outPort.linkX : 0
		startY: outPort ? outPort.linkY : 0
		PathCubic {
			x: inPort ? inPort.linkX : 0
			y: inPort ? inPort.linkY : 0
			control1X: shapePath.startX + 0 + root.curve + (index * 10)
			control1Y: shapePath.startY
			control2X: x - 0 - (root.curve + (index * 10))
			control2Y: y
		}
	}
}
