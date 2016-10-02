package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Movement;
import game.components.LinearWalker;
import game.components.Position;



class LinearWalkingNode extends Node<LinearWalkingNode> {
	public var position:Position;
	public var linearWalker:LinearWalker;
	public var movement:Movement;
}

class LinearMovementSystem extends ListIteratingSystem<LinearWalkingNode> {
	var stage:Stage;
	var engine:Engine;

	public function new(stage:Stage) {
		this.stage = stage;
		super(LinearWalkingNode, updateNode);
	}

	override public function addToEngine(engine:Engine) {
		this.engine = engine;
		super.addToEngine(engine);
	}

	function updateNode(node:LinearWalkingNode, deltaTime:Float) {
		if (node.movement.ready) {
			var tileType = stage.tileAt(node.position);
			if (tileType.isArrow()) {
				node.linearWalker.dx = tileType.dx();
				node.linearWalker.dy = tileType.dy();
			}
			node.movement.oldPosition = node.position.copy();
			node.position.x += node.linearWalker.dx;
			node.position.y += node.linearWalker.dy;
			if (!stage.tileAt(node.position).crossableWith(node.movement.vehicle)) {
				engine.removeEntity(node.entity);
			}
		}
	}
}
