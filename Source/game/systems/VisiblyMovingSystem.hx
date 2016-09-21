package game.systems;

import openfl.Lib;

import ash.core.Engine;
import ash.tools.ListIteratingSystem;

import drawing.Shape;
import game.nodes.VisiblyMovingNode;


class VisiblyMovingSystem extends ListIteratingSystem<VisiblyMovingNode> {
	var game:GameStage;

	public function new(game:GameStage) {
		this.game = game;
		super(VisiblyMovingNode, updateNode);
	}

	function updateNode(node:VisiblyMovingNode, deltaTime:Float) {
		if (node.movement.oldPosition == null || !node.position.equals(node.movement.oldPosition)) {
			var pixPosition = Shape.positionToPoint(node.position, Conf.HEX_RADIUS);
			node.visible.sprite.x = pixPosition.x;
			node.visible.sprite.y = pixPosition.y;
		}
	}
}
