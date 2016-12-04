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
		var currentAction = node.controled.actions[node.controled.actions.length - 1];
		if (currentAction == null) {
			return;
		}
		var oldPosition = new Position(node.position.x, node.position.y);
		currentAction.execute(stage, node, deltaTime);
		if (currentAction.done) {
			node.controled.actions.pop();
		}
	}
}
