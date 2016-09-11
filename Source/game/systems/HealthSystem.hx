package game.systems;

import ash.core.Engine;
import ash.tools.ListIteratingSystem;

import game.nodes.HealthNode;
import hex.Position;

class HealthSystem extends ListIteratingSystem<HealthNode> {
	var game:GameStage;
	var engine:Engine;

	public function new(game:GameStage) {
		this.game = game;
		super(HealthNode, updateNode);
	}

	override public function addToEngine(engine:Engine) {
		this.engine = engine;
		super.addToEngine(engine);
	}

	function updateNode(node:HealthNode, deltaTime:Float) {
		switch(game.tileAt(node.position)) {
		case Pikes:
			node.health.level -= 10;
		default:
		}
		if (node.health.level <= 0) {
			engine.removeEntity(node.entity);
		}
	}
}
