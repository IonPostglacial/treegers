package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.PacedNode;

class PaceSystem extends ListIteratingSystem<PacedNode> {
	var game:GameStage;

	public function new(game:GameStage) {
		this.game = game;
		super(PacedNode, updateNode);
	}

	function updateNode(node:PacedNode, deltaTime:Float) {
		node.pace.make(deltaTime);
	}
}
