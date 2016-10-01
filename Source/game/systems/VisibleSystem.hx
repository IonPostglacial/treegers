package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.core.System;

import openfl.display.Sprite;
import openfl.Lib;

import game.drawing.Shape;
import game.components.Health;
import game.geometry.Hexagon;

import game.components.Visible;
import game.components.Health;
import game.components.Position;


class VisibleNode extends Node<VisibleNode> {
	public var visible:Visible;
	public var position:Position;
}

class VisiblyHealthyNode extends Node<VisiblyHealthyNode> {
	public var health:Health;
	public var position:Position;
	public var visible:Visible;
}

class VisibleSystem extends System implements TileChangeListener {
	var stage:Stage;
	var visibles:NodeList<VisibleNode>;
	var healthies:NodeList<VisiblyHealthyNode>;

	static var HEALTH_COLOR = 0x00FF00;
	static var GAUGE_LHEIGHT = 2;
	static var GAUGE_HEIGHT = 5;

	public function new(stage:Stage) {
		this.stage = stage;
		super();
	}

	override public function update(deltaTime:Float) {
		for (healthy in healthies) {
			updateHealthyNode(healthy, deltaTime);
		}
	}

	public function tileChanged(position:Position, oldType:TileType, newType:TileType) {
		var tilePoint = Shape.positionToPoint(position, stage.hexagonRadius);
		Lib.current.graphics.beginFill(newType.color());
		Shape.hexagon(Lib.current.graphics, new Hexagon(tilePoint.x, tilePoint.y, stage.hexagonRadius));
		Lib.current.graphics.endFill();
	}

	override public function addToEngine(engine:Engine) {
		super.addToEngine(engine);

		visibles = engine.getNodeList(VisibleNode);
		healthies = engine.getNodeList(VisiblyHealthyNode);

		visibles.nodeAdded.add(function (node:VisibleNode) {
			var pixPosition = Shape.positionToPoint(node.position, stage.hexagonRadius);
			node.visible.sprite.x = pixPosition.x;
			node.visible.sprite.y = pixPosition.y;
			Lib.current.addChild(node.visible.sprite);
		});
		visibles.nodeRemoved.add(function (node:VisibleNode) {
			Lib.current.removeChild(node.visible.sprite);
		});

		healthies.nodeAdded.add(function (node:VisiblyHealthyNode) {
			node.visible.sprite.addChild(createHealthSprite(node.health));
		});
		healthies.nodeRemoved.add(function (node:VisiblyHealthyNode) {
			node.visible.sprite.removeChild(node.visible.sprite.getChildByName("health"));
		});
		drawBackground();
	}

	inline function createHealthSprite(health:Health):Sprite {
		var selection = new Sprite();
		selection.name = "health";
		selection.x -= stage.hexagonRadius / 2;
		selection.y -= stage.hexagonRadius;
		return selection;
	}

	function updateHealthyNode(node:VisiblyHealthyNode, deltaTime:Float) {
		var healthSprite = cast (node.visible.sprite.getChildByName("health"), Sprite);
		healthSprite.graphics.lineStyle(GAUGE_LHEIGHT, 0x000000);
		healthSprite.graphics.beginFill(0x000000);
		healthSprite.graphics.drawRect(0, 0, stage.hexagonRadius, GAUGE_HEIGHT);
		healthSprite.graphics.beginFill(HEALTH_COLOR);
		healthSprite.graphics.drawRect(0, 0, stage.hexagonRadius * (node.health.level / node.health.max), GAUGE_HEIGHT);
		healthSprite.graphics.endFill();
	}

	function drawBackground() {
		Lib.current.graphics.beginFill(0x000000);
		Lib.current.graphics.lineStyle(0, 0x000000);
		Lib.current.graphics.drawRect(0, 0, 800, 600);
		Lib.current.graphics.endFill();
		for (position in stage.map.keys()) {
			var tilePoint = Shape.positionToPoint(position, stage.hexagonRadius);
			var tileType = stage.tileAt(position);
			Lib.current.graphics.beginFill(tileType.color());
			Shape.hexagon(Lib.current.graphics, new Hexagon(tilePoint.x, tilePoint.y, stage.hexagonRadius));
			Lib.current.graphics.endFill();
		}
		Lib.current.graphics.lineStyle(2, 0xffa200);
		Shape.hexagonGrid(Lib.current.graphics, stage.map, stage.hexagonRadius);
		Lib.current.graphics.endFill();
	}
}
