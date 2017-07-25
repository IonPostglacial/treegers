package game.systems;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Movement;
import game.components.PathWalker;
import game.components.Position;
import grid.Direction;

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

	public function nextDirection(node:PathWalkingNode, deltaTime:Float):Direction {
		if (node.pathWalker.path.length == 0) {
			return Direction.None;
		}
		var nextPosition = node.pathWalker.path[node.pathWalker.path.length - 1];

		if (node.position.x == nextPosition.x && node.position.y == nextPosition.y) {
			node.pathWalker.path.pop();
			if (node.pathWalker.path.length > 0) {
				nextPosition = node.pathWalker.path[node.pathWalker.path.length - 1];
			}
		}

		if (!this.worldMap.at(nextPosition.x, nextPosition.y).crossableWith(node.movement.vehicle)) {
			node.pathWalker.path.splice(0, node.pathWalker.path.length);
			return Direction.None;
		} else {
			node.movement.alreadyMoved = false;
			return Direction.fromVect(nextPosition.x - node.position.x, nextPosition.y - node.position.y);
		}
	}

	function updateNode(node:PathWalkingNode, deltaTime:Float) {
		if (node.movement.alreadyMoved) {
			node.movement.direction = this.nextDirection(node, deltaTime);
		}
	}
}
