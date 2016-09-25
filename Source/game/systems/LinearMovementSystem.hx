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
			switch (stage.tileAt(node.position)) {
			case Tile.Type.Arrow(dx, dy):
				node.linearWalker.dx = dx;
				node.linearWalker.dy = dy;
			default:
				// Do Nothing
			}
			var newPosition = new Position(
				node.position.x + node.linearWalker.dx,
				node.position.y + node.linearWalker.dy
			);
			if (Tile.Crossable.with(stage.tileAt(newPosition), node.movement.mover)) {
				node.movement.oldPosition = node.position.copy();
				node.entity.add(newPosition);
			} else {
				engine.removeEntity(node.entity);
			}
		}
	}
}
