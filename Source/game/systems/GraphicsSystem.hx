package game.systems;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import openfl.display.Sprite;
import openfl.Lib;

import game.Conf;
import game.nodes.MovingGraphicalNode;
import drawing.Shape;
import hex.Position;

import openfl.events.MouseEvent;

class GraphicsSystem extends ListIteratingSystem<MovingGraphicalNode> {
	var game:GameStage;

	public function new(game:GameStage, grid:hex.Grid) {
		this.game = game;
		drawBackground();
		super(MovingGraphicalNode, updateMovingGraphicalNode, addMovingGraphicalNode, removeMovingGraphicalNode);
	}

	function updateMovingGraphicalNode(node:MovingGraphicalNode, deltaTime:Float) {
		if (node.controled.oldPosition != null && node.position.equals(node.controled.oldPosition)) {
			return;
		}
		var pixPosition = Shape.positionToPoint(node.position, Conf.HEX_RADIUS);
		node.eyeCandy.sprite.x = pixPosition.x;
		node.eyeCandy.sprite.y = pixPosition.y;
	}

	function addMovingGraphicalNode(node:MovingGraphicalNode) {
		Lib.current.addChild(node.eyeCandy.sprite);
	}

	function removeMovingGraphicalNode(node:MovingGraphicalNode) {
		Lib.current.removeChild(node.eyeCandy.sprite);
	}

	function drawBackground() {
		Lib.current.graphics.beginFill(0xbd7207);
		Lib.current.graphics.drawRect(0, 0, 800, 600);
		Lib.current.graphics.endFill();
		Lib.current.graphics.lineStyle(2, 0xffa200);
		drawing.Shape.hexagonGrid(Lib.current.graphics, game.grid);
	}
}
