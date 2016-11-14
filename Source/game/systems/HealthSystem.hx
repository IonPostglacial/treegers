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
	var stage:Stage;
	var engine:Engine;

	public function new(stage:Stage) {
		this.stage = stage;
		super(HealthyNode, updateNode);
	}

	override public function addToEngine(engine:Engine) {
		this.engine = engine;
		super.addToEngine(engine);
	}

	function updateNode(node:HealthyNode, deltaTime:Float) {
		if (!stage.obstacles(node.movement.vehicle).isCrossable(node.position)) {
			node.health.level = 0;
		} else if (stage.obstacles(node.movement.vehicle).isHurting(stage.tileAt(node.position))) {
			node.health.level -= 1;
		}
		if (node.health.level <= 0) {
			engine.removeEntity(node.entity);
		}
	}
}
