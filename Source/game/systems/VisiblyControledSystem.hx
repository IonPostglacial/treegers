package game.systems;

import openfl.display.Sprite;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Controled;
import game.components.Visible;
import game.components.Position;


class VisiblyControledNode extends Node<VisiblyControledNode> {
	public var controled:Controled;
	public var visible:Visible;
	public var position:Position;
}

class VisiblyControledSystem extends ListIteratingSystem<VisiblyControledNode> {
	var stage:Stage;

	public function new(stage:Stage) {
		this.stage = stage;
		super(VisiblyControledNode, updateNode);
	}

	inline function createSelectionSprite():Sprite {
		var selection = new Sprite();
		selection.name = "selection";
		selection.graphics.lineStyle(2, 0xFFFF00);
		selection.graphics.drawRect(0, 0, stage.map.effectiveTileWidth, stage.map.effectiveTileHeight);
		return selection;
	}

	override public function addToEngine(engine:Engine) {
		this.nodeAddedFunction = function (node) {
			node.visible.sprite.addChildAt(createSelectionSprite(), 0);
		};
		super.addToEngine(engine);
	}

	function updateNode(node:VisiblyControledNode, deltaTime:Float) {
		var selection = node.visible.sprite.getChildByName("selection");
		selection.visible = node.controled.selected;
	}
}
