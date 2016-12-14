package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Health;
import game.components.Movement;
import game.components.Position;

import game.map.WorldMap;
import game.map.GroundType;
using game.map.GroundTypeProperties;


class HealthyNode extends Node<HealthyNode> {
	public var health:Health;
	public var movement:Movement;
	public var position:Position;
}

class HealthSystem extends ListIteratingSystem<HealthyNode> {
	var worldMap:WorldMap;
	var engine:Engine;

	public function new(worldMap:WorldMap) {
		this.worldMap = worldMap;
		super(HealthyNode, updateNode);
	}

	override public function addToEngine(engine:Engine) {
		this.engine = engine;
		super.addToEngine(engine);
	}

	function updateNode(node:HealthyNode, deltaTime:Float) {
		node.health.changedThisRound = false;
		switch (this.worldMap.at(node.position.x, node.position.y)) {
		case GroundType.Hurting(level):
			node.health.level -= level;
			node.health.changedThisRound = true;
		case GroundType.Hole:
			node.health.level = 0;
		case type if (!type.crossableWith(node.movement.vehicle)):
			node.health.level = 0;
		default: // pass
		}
		if (node.health.level <= 0) {
			engine.removeEntity(node.entity);
		}
	}
}
