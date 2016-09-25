package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.PathWalkingNode;

class PathMovementSystem extends ListIteratingSystem<PathWalkingNode> {
	var stage:Stage;

	public function new(stage:Stage) {
		this.stage = stage;
		super(PathWalkingNode, updateNode);
	}

	function updateNode(node:PathWalkingNode, deltaTime:Float) {
		if (node.pathWalker.path.length > 0 && node.movement.ready) {
			var nextPosition = node.pathWalker.path.pop();
			if (Tile.Crossable.with(stage.tileAt(nextPosition), node.movement.transportation)) {
				node.movement.oldPosition = node.position.copy();
				node.entity.add(nextPosition);
			} else {
				node.pathWalker.path = [];
			}
		}
	}
}
