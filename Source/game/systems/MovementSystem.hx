package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.MovingNode;

class MovementSystem extends ListIteratingSystem<MovingNode> {
	public function new() {
		super(MovingNode, updateNode);
	}

	function updateNode(node:MovingNode, deltaTime:Float) {
		if (node.movement.timeSinceLastMove < node.movement.period) {
			node.movement.timeSinceLastMove += deltaTime;
		}
	}
}
