package game.systems;

import openfl.display.Sprite;
import ash.tools.ListIteratingSystem;

import drawing.Shape;
import game.nodes.VisiblyControledNode;
import hex.Hexagon;


class VisibleControledSystem extends ListIteratingSystem<VisiblyControledNode> {
	var game:GameStage;

	public function new(game:GameStage) {
		this.game = game;
		super(VisiblyControledNode, updateNode);
	}

	inline function createSelectionSprite():Sprite {
		var selection = new Sprite();
		selection.name = "selection";
		selection.graphics.lineStyle(2, 0xFFFF00);
		Shape.hexagon(selection.graphics, new Hexagon(0, 0, Conf.HEX_RADIUS));
		return selection;
	}

	function updateNode(node:VisiblyControledNode, deltaTime:Float) {
		var selection = node.visible.sprite.getChildByName("selection");
		if (node.controled.selected) {
			if (selection == null) {
				node.visible.sprite.addChildAt(createSelectionSprite(), 0);
			}
		} else if (selection != null) {
			node.visible.sprite.removeChild(selection);
		}
	}
}
