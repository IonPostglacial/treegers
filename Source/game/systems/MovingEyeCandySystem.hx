package game.systems;

import openfl.Lib;

import ash.core.Engine;
import ash.tools.ListIteratingSystem;

import drawing.Shape;
import game.nodes.MovingGraphicalNode;


class MovingEyeCandySystem extends ListIteratingSystem<MovingGraphicalNode> {
	var game:GameStage;

	public function new(game:GameStage) {
		this.game = game;
		super(MovingGraphicalNode, updateNode);
	}

	function updateNode(node:MovingGraphicalNode, deltaTime:Float) {
		if (node.movement.oldPosition == null || !node.position.equals(node.movement.oldPosition)) {
			var pixPosition = Shape.positionToPoint(node.position, Conf.HEX_RADIUS);
			node.eyeCandy.sprite.x = pixPosition.x;
			node.eyeCandy.sprite.y = pixPosition.y;
		}
	}
}
