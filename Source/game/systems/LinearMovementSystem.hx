package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.LinearMovingNode;
import hex.Position;

class LinearMovementSystem extends ListIteratingSystem<LinearMovingNode> {
	var game:GameStage;

	public function new(game:GameStage) {
		this.game = game;
		super(LinearMovingNode, updateNode);
	}

	function updateNode(node:LinearMovingNode, deltaTime:Float) {
		node.speed.timeSinceLastMove += deltaTime;
		if (node.speed.timeSinceLastMove >= node.speed.period) {
			var newPosition = new Position(
				node.position.x + node.linearMover.dx,
				node.position.y + node.linearMover.dy
			);
			node.speed.timeSinceLastMove -= node.speed.period;
			node.speed.oldPosition.assign(node.position);
			node.position.assign(newPosition);
		}
	}
}
