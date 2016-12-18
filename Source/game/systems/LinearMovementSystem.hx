package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Movement;
import game.components.LinearWalker;
import game.components.Position;

import game.map.WorldMap;
import game.map.GroundType;
using game.map.GroundTypeProperties;


class LinearWalkingNode extends Node<LinearWalkingNode> {
	public var position:Position;
	public var linearWalker:LinearWalker;
	public var movement:Movement;
}

class LinearMovementSystem extends ListIteratingSystem<LinearWalkingNode> {
	var worldMap:WorldMap;
	var engine:Engine;

	public function new(worldMap:WorldMap) {
		this.worldMap = worldMap;
		super(LinearWalkingNode, updateNode);
	}

	override public function addToEngine(engine:Engine) {
		this.engine = engine;
		super.addToEngine(engine);
	}

	function updateNode(node:LinearWalkingNode, deltaTime:Float) {
		if (node.movement.alreadyMoved) {
			switch (this.worldMap.at(node.position.x, node.position.y)) {
			case GroundType.Arrow(dx, dy):
				node.linearWalker.dx = dx;
				node.linearWalker.dy = dy;
			case type if (!type.crossableWith(node.movement.vehicle)):
				engine.removeEntity(node.entity);
				return;
			default: // pass
			}
			node.movement.alreadyMoved = false;
			node.movement.nextX += node.linearWalker.dx;
			node.movement.nextY += node.linearWalker.dy;
		}
	}
}
