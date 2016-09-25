package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Health;
import game.components.Movement;
import game.components.Position;


class HealthyNode extends Node<HealthyNode> {
	public var health:Health;
	public var movement:Movement;
	public var position:Position;
}

class HealthSystem extends ListIteratingSystem<HealthyNode> {
	var game:Stage;
	var engine:Engine;

	public function new(game:Stage) {
		this.game = game;
		super(HealthyNode, updateNode);
	}

	override public function addToEngine(engine:Engine) {
		this.engine = engine;
		super.addToEngine(engine);
	}

	function updateNode(node:HealthyNode, deltaTime:Float) {
		switch(game.tileAt(node.position)) {
		case Pikes:
			node.health.level -= 1;
		case type:
			if (!Tile.Crossable.with(type, node.movement.transportation)) {
				node.health.level = 0;
			}
		}
		if (node.health.level <= 0) {
			engine.removeEntity(node.entity);
		}
	}
}
