package game.systems;

import ash.core.Engine;
import ash.tools.ListIteratingSystem;

import game.nodes.LinearWalkingNode;
import hex.Position;


class LinearMovementSystem extends ListIteratingSystem<LinearWalkingNode> {
	var stage:GameStage;
	var engine:Engine;

	public function new(stage:GameStage) {
		this.stage = stage;
		super(LinearWalkingNode, updateNode);
	}

	override public function addToEngine(engine:Engine) {
		this.engine = engine;
		super.addToEngine(engine);
	}

	function updateNode(node:LinearWalkingNode, deltaTime:Float) {
		if (node.pace.ready) {
			var newPosition = new Position(
				node.position.x + node.linearWalker.dx,
				node.position.y + node.linearWalker.dy
			);
			if (Tile.Crossable.with(stage.tileAt(newPosition), node.pace.transportation)) {
				node.pace.oldPosition = node.position.copy();
				node.entity.add(newPosition);
			} else {
				engine.removeEntity(node.entity);
			}

		}
	}
}
