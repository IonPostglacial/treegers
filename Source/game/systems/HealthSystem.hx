package game.systems;

import ash.core.Engine;
import ash.tools.ListIteratingSystem;

import game.nodes.HealthyNode;
import game.components.Position;

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
		default:
		}
		if (node.health.level <= 0) {
			engine.removeEntity(node.entity);
		}
	}
}
