package game.systems;

import openfl.display.Sprite;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Controled;
import game.components.Visible;
import game.components.Position;
import geometry.ICoordinatesSystem;


@:publicFields
class VisibleControledNode extends Node<VisibleControledNode> {
	var controled:Controled;
	var visible:Visible;
	var position:Position;
}

class VisibleControledSystem extends ListIteratingSystem<VisibleControledNode> {
	var orderBoard:Order.Board;
	var coordinates:ICoordinatesSystem;
	var selectionWidth:Int;
	var selectionHeight:Int;
	var hover:Sprite;

	public function new(orderBoard:Order.Board, coords:ICoordinatesSystem, selectionWidth:Int, selectionHeight:Int) {
		this.orderBoard = orderBoard;
		this.coordinates = coords;
		this.selectionWidth = selectionWidth;
		this.selectionHeight = selectionHeight;
		this.hover = new Sprite();
		this.hover.graphics.lineStyle(2, 0xFFFFFF);
		this.hover.graphics.drawRect(0, 0, selectionWidth, selectionHeight);
		openfl.Lib.current.addChild(this.hover);
		super(VisibleControledNode, updateNode);
	}

	inline function createSelectionSprite():Sprite {
		var selection = new Sprite();
		selection.name = "selection";
		selection.visible = false;
		selection.graphics.lineStyle(2, 0xff0000);
		selection.graphics.drawRect(0, 0, this.selectionWidth, this.selectionWidth);
		return selection;
	}

	override public function addToEngine(engine:Engine) {
		this.nodeAddedFunction = function (node) {
			node.visible.sprite.addChildAt(createSelectionSprite(), 0);
		};
		super.addToEngine(engine);
	}

	override function update(deltaTime:Float):Void {
		if (this.orderBoard.mouseMoved) {
			var mousePoint = this.coordinates.toPixel(this.orderBoard.mousePositionX, this.orderBoard.mousePositionY);
			this.hover.x = mousePoint.x;
			this.hover.y = mousePoint.y;
		}
		super.update(deltaTime);
	}

	function updateNode(node:VisibleControledNode, deltaTime:Float) {
		if (node.controled.selectedThisRound) {
			var selection = node.visible.sprite.getChildByName("selection");
			selection.visible = node.controled.selected;
		}
	}
}
