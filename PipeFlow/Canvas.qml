import QtQuick
import PipeFlow as My

Item {
	id: canvas
	clip: true
	MouseArea {
		id: canvasMouse
		anchors.fill: parent
		hoverEnabled: true
		onEntered: setInfoText("")
	}
	Flow {
		id: nodeItems
		anchors.fill: parent
		anchors.margins: 30
		spacing: 30
		Repeater {
			model: NodeModel
			delegate: My.Node {
				visible: !Theme.hideNodes.includes(node_label)
				label: node_label
				nodeId: node_id
				nodeState: node_state
				nodeType: node_type
				nodeApi: node_api
				chnVols: chnvols
				inPorts: inports
				outPorts: outports
			}
		}
	}
	Item {
		id: linkItems
		anchors.fill: parent
		layer.enabled: true
		layer.samples: 8
		Repeater {
			model: LinkModel
			delegate: My.Link {
				anchors.fill: parent
				index: index
				linkId: link_id
				inPort: findNodePortById(input_node_id, input_port_id)
				outPort: findNodePortById(output_node_id, output_port_id)
			}
		}
	}
	ToolTip {
		id: toolTip
		visible: false
	}
	enum ItemSide {
		Top,
		Right,
		Bottom,
		Left
	}
	function findSideWithMostSpace (x, y, w, h) {
		let l = x
		let ret = My.Canvas.ItemSide.Top
		if (canvas.width - x - w > l) {
			l = canvas.width - x - w
			ret = My.Canvas.ItemSide.Right
		}
		if (canvas.height - y - h > l) {
			l = canvas.height - y - h
			ret = My.Canvas.ItemSide.Bottom
		}
		if (canvas.width - y > l) {
			l = y
			ret = My.Canvas.ItemSide.Left
		}
		return ret
	}
	function showToolTip(item) {
		// TODO: position where most space
		let pos = item.parent.mapToGlobal(item.x, item.y)
		let side = findSideWithMostSpace(pos.x, pos.y, item.width, item.height)
		//console.log("HMMM", item.toolTip, side)
		toolTip.text = item.toolTip
		toolTip.x = pos.x + item.width
		toolTip.y = pos.y + Math.round((item.height/2) - (toolTip.height/2))
		toolTip.visible = true
	}
	function hideToolTip(){
		toolTip.visible = false
	}
	function findNodePortById(nodeId, portId) {
		for (let node of nodeItems.children) {
			if (node instanceof My.Node) {
				if (node.nodeId === nodeId) {
					if (node.findPortById) {
						return node.findPortById(portId)
					}
				}
			}
		}
		return null
	}
	function findLinkIdsByPortId(portId) {
		let ret = []
		for (let link of linkItems.children) {
			if (link instanceof My.Link) {
				if (link.outPort && link.outPort.portId === portId) {
					ret.push(link.linkId)
				}
				if (link.inPort && link.inPort.portId === portId) {
					ret.push(link.linkId)
				}
			}
		}
		return ret
	}
	function findLinkId(linkDir, portId1, portId2) {
		for (let link of linkItems.children) {
			if (link instanceof My.Link) {
				if (linkDir === 0) {
					if (link.outPort && link.outPort.portId === portId1
					&& link.inPort && link.inPort.portId === portId2) {
						return link.linkId
					}
				} else {
					if (link.outPort && link.outPort.portId === portId2
					&& link.inPort && link.inPort.portId === portId1) {
						return link.linkId
					}
				}
			}
		}
		return null
	}
	property var linkBuffer: [[],[]]
	function linkAllTheThings (portDir, portId) {
		if (linkBuffer[portDir].includes(portId)) {
			linkBuffer[portDir] = linkBuffer[portDir].filter(x => x !== portId)
			linkBufferChanged()
		} else {
			if (linkBuffer[1-portDir].length > 0) {
				let pid = linkBuffer[1-portDir][0]
				let linkId = findLinkId(portDir, portId, pid)
				if (linkId) {
					PwLink.remove_link_by_id(linkId)
				} else {
					if (portDir === 0) {
						PwLink.crete_link(portId, pid)
					} else {
						PwLink.crete_link(pid, portId)
					}
				}
				linkBuffer[1-portDir].shift()
				linkBufferChanged()
			} else {
				linkBuffer[portDir].push(portId)
				linkBufferChanged()
			}
		}
	}
	function clamp(num, min, max) {
		return Math.min(Math.max(num, min), max);
	}
}
