package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.ActionedNode;
import hex.Position;

class ActionSystem extends ListIteratingSystem<ActionedNode> {
	private var stage:GameStage;

	public function new(stage:GameStage) {
		this.stage = stage;
		super(ActionedNode, updateNode);
	}

	function updateNode(node:ActionedNode, deltaTime:Float) {
		var oldPosition = new Position(node.position.x, node.position.y);
		if (node.controled.currentAction == null) {
			return;
		}
		node.speed.timeSinceLastMove += deltaTime;
		node.controled.currentAction.execute(stage, node, deltaTime);
		if (node.controled.currentAction.done) {
			node.controled.actions.pop();
			node.controled.oldPosition = oldPosition;
			node.speed.timeSinceLastMove = 0;
		}
	}
}
