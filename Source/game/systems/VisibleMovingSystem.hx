package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Visible;
import game.components.Movement;
import game.components.Position;
import grid.ICoordinatesSystem;
import grid.Vector2D;


@:publicFields
class VisibleMovingNode extends Node<VisibleMovingNode> {
	var movement:Movement;
	var visible:Visible;
	var position:Position;
}

class VisibleMovingSystem extends ListIteratingSystem<VisibleMovingNode> {
	var coordinates:ICoordinatesSystem;
	var tileWidth:Int;
	var tileHeight:Int;

	public function new(coordinates:ICoordinatesSystem, tileWidth:Int, tileHeight:Int) {
		this.coordinates = coordinates;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		super(VisibleMovingNode, updateNode);
	}

	function updateNode(node:VisibleMovingNode, deltaTime:Float) {
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
