package game.systems;

import ash.core.Engine;
import ash.tools.ListIteratingSystem;

import game.nodes.MovingNode;


class MovementSystem extends ListIteratingSystem<MovingNode> {
	public function new() {
		super(MovingNode, updateNode);
	}

	function updateNode(node:MovingNode, deltaTime:Float) {
		if (!node.movement.alreadyMoved) {
			node.movement.timeSinceLastMove += deltaTime;
			if (node.movement.timeSinceLastMove >= node.movement.period) {
				node.position.x += node.movement.direction.dx();
				node.position.y += node.movement.direction.dy();
				node.movement.alreadyMoved = true;
				node.movement.timeSinceLastMove -= node.movement.period;
			}
		}
	}
}
