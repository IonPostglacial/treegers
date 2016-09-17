package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.MovingNode;

class MovementSystem extends ListIteratingSystem<MovingNode> {
	var game:GameStage;

	public function new(game:GameStage) {
		this.game = game;
		super(MovingNode, updateNode);
	}

	function updateNode(node:MovingNode, deltaTime:Float) {
		node.movement.make(deltaTime);
	}
}
