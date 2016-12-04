package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.MovingNode;

class MovementSystem extends ListIteratingSystem<MovingNode> {
	var game:Stage;

	public function new(game:Stage) {
		this.game = game;
		super(MovingNode, updateNode);
	}

	function updateNode(node:MovingNode, deltaTime:Float) {
		if (node.movement.timeSinceLastMove < node.movement.period) {
			node.movement.timeSinceLastMove += deltaTime;
		}
	}
}
