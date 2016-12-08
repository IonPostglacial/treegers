package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Visible;
import game.components.Movement;
import game.components.Position;
import geometry.ICoordinatesSystem;


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
		if (node.movement.oldPosition == null || !node.position.equals(node.movement.oldPosition)) {
			var pixPosition = this.coordinates.toPixel(node.position);
			if(node.movement.oldPosition != null) {
				var oldPixPosition = this.coordinates.toPixel(node.movement.oldPosition);
				var movementDelta = node.movement.timeSinceLastMove / node.movement.period;
				pixPosition = pixPosition.interpolate(oldPixPosition, movementDelta);
			}
			node.visible.sprite.x = pixPosition.x;
			node.visible.sprite.y = pixPosition.y;
			node.visible.tile.x = pixPosition.x;
			node.visible.tile.y = pixPosition.y;
		}
	}
}
