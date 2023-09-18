import QtQuick
import PipeFlow as My

My.Text{
	id: root
	property int value
	property int step: 1
	property int min: 0
	property int max: 100
	text: value + "%"
	signal valueChangeRequest (real val)
	MouseArea {
		anchors.fill: parent
		onWheel: function (wheel) {
			let val = root.value
			if (wheel.angleDelta.y > 0) {
				val += root.step
			} else {
				val -= root.step
			}
			val = clamp(val, root.min, root.max)
			root.valueChangeRequest(val)
		}
	}
}
