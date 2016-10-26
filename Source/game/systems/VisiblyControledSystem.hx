package game.systems;

import openfl.display.Sprite;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import geometry.Hexagon;

import game.components.Controled;
import game.components.Visible;
import game.components.Position;

using rendering.ExtraShape;


class VisiblyControledNode extends Node<VisiblyControledNode> {
	public var controled:Controled;
	public var visible:Visible;
	public var position:Position;
}

class VisibleControledSystem extends ListIteratingSystem<VisiblyControledNode> {
	var stage:Stage;

	public function new(stage:Stage) {
		this.stage = stage;
		super(VisiblyControledNode, updateNode);
	}

	inline function createSelectionSprite():Sprite {
		var selection = new Sprite();
		selection.name = "selection";
		selection.graphics.lineStyle(2, 0xFFFF00);
		if (stage.map.orientation == tmx.Orientation.Hexagonal) {
			selection.graphics.drawRect(0, 0, stage.map.tileWidth, stage.map.tileHeight * 0.75);
		} else {
			selection.graphics.drawRect(0, 0, stage.map.tileWidth, stage.map.tileHeight);
		}
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
