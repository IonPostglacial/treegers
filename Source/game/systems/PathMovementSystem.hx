package game.systems;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Movement;
import game.components.PathWalker;
import game.components.Position;


class PathWalkingNode extends Node<PathWalkingNode> {
	public var position:Position;
	public var pathWalker:PathWalker;
	public var movement:Movement;
}

class PathMovementSystem extends ListIteratingSystem<PathWalkingNode> {
	var stage:Stage;

	public function new(stage:Stage) {
		this.stage = stage;
		super(PathWalkingNode, updateNode);
	}

	function updateNode(node:PathWalkingNode, deltaTime:Float) {
		if (node.pathWalker.path.length > 0 && node.movement.ready) {
			var nextPosition = node.pathWalker.path.pop();
			if (Tile.Crossable.with(stage.tileAt(nextPosition), node.movement.vehicle)) {
				node.movement.oldPosition = node.position.copy();
				node.entity.add(nextPosition);
			} else {
				node.pathWalker.path = [];
			}
		}
	}
}
