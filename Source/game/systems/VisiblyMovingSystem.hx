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

	public function new(coordinates:ICoordinatesSystem) {
		this.coordinates = coordinates;
		super(VisiblyMovingNode, updateNode);
	}

	function updateNode(node:VisiblyMovingNode, deltaTime:Float) {
		if (!node.movement.alreadyMoved) {
			var pixPosition = this.coordinates.toPixel(node.position.x, node.position.y);
			var nextPixPosition = this.coordinates.toPixel(node.movement.nextX, node.movement.nextY);
			var movementDelta = node.movement.timeSinceLastMove / node.movement.period;

			pixPosition = Vector2D.interpolate(nextPixPosition.x, nextPixPosition.y, pixPosition.x, pixPosition.y, movementDelta);
			node.visible.tile.x = pixPosition.x;
			node.visible.tile.y = pixPosition.y;
			node.visible.sprite.x = pixPosition.x;
			node.visible.sprite.y = pixPosition.y;
		}
	}
}
