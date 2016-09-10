package game.systems;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import openfl.display.Sprite;
import openfl.Lib;

import game.Conf;
import game.nodes.MovingGraphicalNode;
import drawing.Shape;
import hex.Hexagon;
import hex.Position;

import openfl.events.MouseEvent;

class GraphicsSystem extends ListIteratingSystem<MovingGraphicalNode> {
	var game:GameStage;

	public function new(game:GameStage) {
		this.game = game;
		drawBackground();
		super(MovingGraphicalNode, updateMovingGraphicalNode, addMovingGraphicalNode, removeMovingGraphicalNode);
	}

	static function createSelectionSprite():Sprite {
		var selection = new Sprite();
		selection.name = "selection";
		selection.graphics.lineStyle(2, 0xFFFF00);
		Shape.hexagon(selection.graphics, new Hexagon(0, 0, Conf.HEX_RADIUS));
		return selection;
	}

	function updateMovingGraphicalNode(node:MovingGraphicalNode, deltaTime:Float) {
		if (node.controled.oldPosition == null || !node.position.equals(node.controled.oldPosition)) {
			var pixPosition = Shape.positionToPoint(node.position, Conf.HEX_RADIUS);
			node.eyeCandy.sprite.x = pixPosition.x;
			node.eyeCandy.sprite.y = pixPosition.y;
		}
		var selection = node.eyeCandy.sprite.getChildByName("selection");
		if (node.controled.selected) {
			if (selection == null) {
				node.eyeCandy.sprite.addChild(createSelectionSprite());
			}
		} else if (selection != null) {
			node.eyeCandy.sprite.removeChild(selection);
		}
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
