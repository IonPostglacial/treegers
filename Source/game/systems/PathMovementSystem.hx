package game.systems;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Movement;
import game.components.PathWalker;
import game.components.Position;
import game.mapmanagement.GroundType;

using game.mapmanagement.GroundTypeProperties;


class PathWalkingNode extends Node<PathWalkingNode> {
	public var position:Position;
	public var pathWalker:PathWalker;
	public var movement:Movement;
}

class PathMovementSystem extends ListIteratingSystem<PathWalkingNode> {
	var stage:Stage;

	public function new(stage:Stage) {
		this.stage = stage;
		super(PathWalkingNode, updateNode);
	}

	function updateNode(node:PathWalkingNode, deltaTime:Float) {
		if (node.pathWalker.path.length > 0 && node.movement.timeSinceLastMove >= node.movement.period) {
			var nextPosition = node.pathWalker.path.pop();
			if (!stage.ground.at(nextPosition).crossableWith(node.movement.vehicle)) {
				node.pathWalker.path = [];
			} else {
				node.movement.oldPosition = node.position.copy();
				node.movement.timeSinceLastMove -= node.movement.period;
				node.position.x = nextPosition.x;
				node.position.y = nextPosition.y;
			}
		}
	}
}
