package game.systems;


import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.Lib;

import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.core.System;

import game.components.Health;
import game.components.Visible;
import game.components.Health;
import game.components.Position;
import game.pixelutils.Shape;
import game.geometry.Hexagon;


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
	var tiles(default, null):TileManager;
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
		tiles.setTileTypeAt(position, newType);
	}

	override public function addToEngine(engine:Engine) {
		super.addToEngine(engine);

		this.tiles = new TileManager(stage);
		visibles = engine.getNodeList(VisibleNode);
		healthies = engine.getNodeList(VisiblyHealthyNode);
		visibles.nodeAdded.add(function (node:VisibleNode) {
			var pixPosition = stage.coords.positionToPoint(node.position);
			node.visible.sprite.x = pixPosition.x;
			node.visible.sprite.y = pixPosition.y;
			Lib.current.addChild(node.visible.sprite);
			node.visible.tile = tiles.createTileAt(node.visible.tileType, pixPosition.x, pixPosition.y);
		});
		visibles.nodeRemoved.add(function (node:VisibleNode) {
			Lib.current.removeChild(node.visible.sprite);
			if (node.visible.tile != null) {
				tiles.removeTile(node.visible.tile);
			}
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
		var healthSprite = new Sprite();
		healthSprite.graphics.lineStyle(GAUGE_LHEIGHT, 0x000000);
		healthSprite.graphics.beginFill(HEALTH_COLOR);
		healthSprite.graphics.drawRect(0, 0, stage.hexagonRadius, GAUGE_HEIGHT);
		healthSprite.name = "health";
		healthSprite.x -= stage.hexagonRadius / 2;
		healthSprite.y -= stage.hexagonRadius + GAUGE_HEIGHT;
		return healthSprite;
	}

	function updateHealthyNode(node:VisiblyHealthyNode, deltaTime:Float) {
		var healthSprite = cast (node.visible.sprite.getChildByName("health"), Sprite);
		healthSprite.width = stage.hexagonRadius * (node.health.level / node.health.max);
		healthSprite.graphics.endFill();
	}

	function drawBackground() {
		Lib.current.graphics.beginFill(0x000000);
		Lib.current.graphics.lineStyle(0, 0x000000);
		Lib.current.graphics.drawRect(0, 0, 800, 600);
		Lib.current.graphics.endFill();
	}
}
