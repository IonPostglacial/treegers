package game.systems;

import ash.core.Engine;
import ash.tools.ListIteratingSystem;

import game.nodes.MovingNode;


class MovementSystem extends ListIteratingSystem<MovingNode> {
	public function new() {
		super(MovingNode, updateNode);
	}

	override public function addToEngine(engine:Engine) {
		this.nodeAddedFunction = function(node) {
			node.movement.nextX = node.position.x;
			node.movement.nextY = node.position.y;
		};
		super.addToEngine(engine);
	}

	function updateNode(node:MovingNode, deltaTime:Float) {
		if (!node.movement.alreadyMoved) {
			node.movement.timeSinceLastMove += deltaTime;
			if (node.movement.timeSinceLastMove >= node.movement.period) {
				node.position.x = node.movement.nextX;
				node.position.y = node.movement.nextY;
				node.movement.alreadyMoved = true;
				node.movement.timeSinceLastMove -= node.movement.period;
			}
		}
	}
}
