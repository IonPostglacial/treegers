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

	static inline function tween(x1:Float, x2:Float, delta:Float) {
		return (1 - delta) * x1 + delta * x2;
	}

	function updateNode(node:VisiblyMovingNode, deltaTime:Float) {
		if (node.movement.oldPosition == null || !node.position.equals(node.movement.oldPosition)) {
			var pixPosition = Shape.positionToPoint(node.position, game.grid.radius);
			if(node.movement.oldPosition == null) {
				node.visible.sprite.x = pixPosition.x;
				node.visible.sprite.y = pixPosition.y;
			} else {
				var oldPixPosition = Shape.positionToPoint(node.movement.oldPosition, game.grid.radius);
				node.visible.sprite.x = tween(oldPixPosition.x, pixPosition.x, node.movement.delta);
				node.visible.sprite.y = tween(oldPixPosition.y, pixPosition.y, node.movement.delta);
			}
		}
	}
}
