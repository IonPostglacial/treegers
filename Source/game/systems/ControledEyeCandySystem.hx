package game.systems;

import openfl.display.Sprite;
import ash.tools.ListIteratingSystem;

import drawing.Shape;
import game.nodes.ControledGraphicalNode;
import hex.Hexagon;


class ControledEyeCandySystem extends ListIteratingSystem<ControledGraphicalNode> {
	var game:GameStage;

	public function new(game:GameStage) {
		this.game = game;
		super(ControledGraphicalNode, updateNode);
	}

	inline function createSelectionSprite():Sprite {
		var selection = new Sprite();
		selection.name = "selection";
		selection.graphics.lineStyle(2, 0xFFFF00);
		Shape.hexagon(selection.graphics, new Hexagon(0, 0, Conf.HEX_RADIUS));
		return selection;
	}

	function updateNode(node:ControledGraphicalNode, deltaTime:Float) {
		var selection = node.eyeCandy.sprite.getChildByName("selection");
		if (node.controled.selected) {
			if (selection == null) {
				node.eyeCandy.sprite.addChildAt(createSelectionSprite(), 0);
			}
		} else if (selection != null) {
			node.eyeCandy.sprite.removeChild(selection);
		}
	}
}
