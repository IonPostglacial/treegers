package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Visible;
import game.components.Movement;
import game.components.Position;
import geometry.ICoordinatesSystem;
import geometry.Vector2D;


class VisiblyMovingNode extends Node<VisiblyMovingNode> {
	public var movement:Movement;
	public var visible:Visible;
	public var position:Position;
}

class VisiblyMovingSystem extends ListIteratingSystem<VisiblyMovingNode> {
	var coordinates:ICoordinatesSystem;
	var tileWidth:Int;
	var tileHeight:Int;

	public function new(coordinates:ICoordinatesSystem, tileWidth:Int, tileHeight:Int) {
		this.coordinates = coordinates;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		super(VisiblyMovingNode, updateNode);
	}

	function updateNode(node:VisiblyMovingNode, deltaTime:Float) {
		var pixPosition = this.coordinates.toPixel(node.position.x, node.position.y);
		if (!node.movement.alreadyMoved) {
			var movementDelta = deltaTime / node.movement.period;
			node.visible.tile.x += node.movement.direction.dx() * tileWidth * movementDelta;
			node.visible.tile.y += node.movement.direction.dy() * tileHeight * movementDelta;
		} else {
			node.visible.tile.x = pixPosition.x;
			node.visible.tile.y = pixPosition.y;
		}
		node.visible.sprite.x = node.visible.tile.x;
		node.visible.sprite.y = node.visible.tile.y;
	}
}
