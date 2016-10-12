package game.systems;

import openfl.geom.Point;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import drawing.Shape;

import game.components.Visible;
import game.components.Movement;
import game.components.Position;


class VisiblyMovingNode extends Node<VisiblyMovingNode> {
	public var movement:Movement;
	public var visible:Visible;
	public var position:Position;
}

class VisiblyMovingSystem extends ListIteratingSystem<VisiblyMovingNode> {
	var stage:Stage;

	public function new(stage:Stage) {
		this.stage = stage;
		super(VisiblyMovingNode, updateNode);
	}

	function updateNode(node:VisiblyMovingNode, deltaTime:Float) {
		if (node.movement.oldPosition == null || !node.position.equals(node.movement.oldPosition)) {
			var pixPosition = stage.coordinates.toPixel(node.position);
			if(node.movement.oldPosition == null) {
				node.visible.sprite.x = pixPosition.x;
				node.visible.sprite.y = pixPosition.y;
			} else {
				var oldPixPosition = stage.coordinates.toPixel(node.movement.oldPosition);
				var newPixPosition = Point.interpolate(pixPosition, oldPixPosition, node.movement.delta);
				node.visible.sprite.x = newPixPosition.x;
				node.visible.sprite.y = newPixPosition.y;
			}
			if (node.visible.tile != null) {
				TileManager.moveTile(node.visible.tile, node.visible.sprite.x, node.visible.sprite.y);
			}
		}
	}
}
