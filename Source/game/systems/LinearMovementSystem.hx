package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.LinearWalkingNode;
import hex.Position;

class LinearMovementSystem extends ListIteratingSystem<LinearWalkingNode> {
	var game:GameStage;

	public function new(game:GameStage) {
		this.game = game;
		super(LinearWalkingNode, updateNode);
	}

	function updateNode(node:LinearWalkingNode, deltaTime:Float) {
		if (node.pace.ready) {
			var newPosition = new Position(
				node.position.x + node.linearWalker.dx,
				node.position.y + node.linearWalker.dy
			);
			node.pace.oldPosition = node.position.copy();
			node.entity.add(newPosition);
		}
	}
}
