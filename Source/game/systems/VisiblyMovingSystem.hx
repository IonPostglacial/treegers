package game.systems;

import openfl.Lib;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.drawing.Shape;

import game.components.Visible;
import game.components.Movement;
import game.components.Position;


class VisiblyMovingNode extends Node<VisiblyMovingNode> {
	public var movement:Movement;
	public var visible:Visible;
	public var position:Position;
}

class VisiblyMovingSystem extends ListIteratingSystem<VisiblyMovingNode> {
	var game:Stage;

	public function new(game:Stage) {
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
