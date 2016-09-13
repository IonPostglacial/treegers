package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.PathWalkingNode;

class PathMovementSystem extends ListIteratingSystem<PathWalkingNode> {
	var game:GameStage;

	public function new(game:GameStage) {
		this.game = game;
		super(PathWalkingNode, updateNode);
	}

	function updateNode(node:PathWalkingNode, deltaTime:Float) {
		if (node.pathWalker.path.length > 0 && node.pace.ready) {
			node.pace.oldPosition = node.position.copy();
			node.entity.add(node.pathWalker.path.pop());
		}
	}
}
