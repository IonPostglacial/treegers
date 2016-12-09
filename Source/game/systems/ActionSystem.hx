package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.ActionedNode;
import game.components.Position;
import game.map.WorldMap;


class ActionSystem extends ListIteratingSystem<ActionedNode> {
	var worldMap:WorldMap;

	public function new(worldMap:WorldMap) {
		this.worldMap = worldMap;
		super(ActionedNode, updateNode);
	}

	function updateNode(node:ActionedNode, deltaTime:Float) {
		var currentAction = node.controled.actions[node.controled.actions.length - 1];
		if (currentAction == null) {
			return;
		}
		var oldPosition = new Position(node.position.x, node.position.y);
		currentAction.execute(this.worldMap, node, deltaTime);
		if (currentAction.done) {
			node.controled.actions.pop();
		}
	}
}
