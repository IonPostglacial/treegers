package game.systems;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Movement;
import game.components.PathWalker;
import game.components.Position;

import game.map.WorldMap;
import game.map.GroundType;
using game.map.GroundTypeProperties;


class PathWalkingNode extends Node<PathWalkingNode> {
	public var position:Position;
	public var pathWalker:PathWalker;
	public var movement:Movement;
}

class PathMovementSystem extends ListIteratingSystem<PathWalkingNode> {
	var worldMap:WorldMap;

	public function new(worldMap:WorldMap) {
		this.worldMap = worldMap;
		super(PathWalkingNode, updateNode);
	}

	function updateNode(node:PathWalkingNode, deltaTime:Float) {
		if (node.pathWalker.path.length > 0 && node.movement.timeSinceLastMove >= node.movement.period) {
			var nextPosition = node.pathWalker.path.pop();
			if (!this.worldMap.at(nextPosition.x, nextPosition.y).crossableWith(node.movement.vehicle)) {
				node.pathWalker.path = [];
			} else {
				node.movement.oldX = node.position.x;
				node.movement.oldY = node.position.y;
				node.movement.timeSinceLastMove -= node.movement.period;
				node.position.x = nextPosition.x;
				node.position.y = nextPosition.y;
			}
		}
	}
}
