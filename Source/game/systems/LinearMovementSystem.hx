package game.systems;

import ash.core.Engine;
import ash.tools.ListIteratingSystem;

import game.nodes.LinearWalkingNode;
import game.components.Position;


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
			if (Tile.Crossable.with(stage.tileAt(newPosition), node.movement.transportation)) {
				node.movement.oldPosition = node.position.copy();
				node.entity.add(newPosition);
			} else {
				engine.removeEntity(node.entity);
			}
		}
	}
}
