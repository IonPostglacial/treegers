package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

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
			var pixPosition = stage.map.coordinates.toPixel(node.position);
			if(node.movement.oldPosition != null) {
				var oldPixPosition = stage.map.coordinates.toPixel(node.movement.oldPosition);
				pixPosition = pixPosition.interpolate(oldPixPosition, node.movement.delta);
			}
			node.visible.sprite.x = pixPosition.x;
			node.visible.sprite.y = pixPosition.y;
			node.visible.tile.x = pixPosition.x;
			node.visible.tile.y = pixPosition.y;
		}
	}
}
