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

	override public function addToEngine(engine:Engine) {
		super.addToEngine(engine);

		nodeList.nodeAdded.add(function (node:MovingGraphicalNode) {
			Lib.current.addChild(node.eyeCandy.sprite);
		});
		nodeList.nodeRemoved.add(function (node:MovingGraphicalNode) {
			Lib.current.removeChild(node.eyeCandy.sprite);
		});
	}

	function updateNode(node:MovingGraphicalNode, deltaTime:Float) {
		if (node.pace.oldPosition == null || !node.position.equals(node.pace.oldPosition)) {
			var pixPosition = Shape.positionToPoint(node.position, Conf.HEX_RADIUS);
			node.eyeCandy.sprite.x = pixPosition.x;
			node.eyeCandy.sprite.y = pixPosition.y;
		}
	}
}
