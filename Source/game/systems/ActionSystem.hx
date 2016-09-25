package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.ActionedNode;
import game.components.Position;


class ActionSystem extends ListIteratingSystem<ActionedNode> {
	private var stage:Stage;

	public function new(stage:Stage) {
		this.stage = stage;
		super(ActionedNode, updateNode);
	}

	function updateNode(node:ActionedNode, deltaTime:Float) {
		if (node.controled.currentAction == null) {
			return;
		}
		var oldPosition = new Position(node.position.x, node.position.y);
		node.controled.currentAction.execute(stage, node, deltaTime);
		if (node.controled.currentAction.done) {
			node.controled.actions.pop();
			node.movement.oldPosition = oldPosition;
		}
	}
}
