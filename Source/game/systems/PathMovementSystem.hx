package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.PathWalkingNode;

class PathMovementSystem extends ListIteratingSystem<PathWalkingNode> {
	var stage:GameStage;

	public function new(stage:GameStage) {
		this.stage = stage;
		super(PathWalkingNode, updateNode);
	}

	function updateNode(node:PathWalkingNode, deltaTime:Float) {
		if (node.pathWalker.path.length > 0 && node.pace.ready) {
			var nextPosition = node.pathWalker.path.pop();
			if (Tile.Crossable.with(stage.tileAt(nextPosition), node.pace.transportation)) {
				node.pace.oldPosition = node.position.copy();
				node.entity.add(nextPosition);
			} else {
				node.pathWalker.path = [];
			}
		}
	}
}
