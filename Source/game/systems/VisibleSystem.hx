package game.systems;


import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.Tile;

import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.core.System;

import game.components.Health;
import game.components.Visible;
import game.components.Health;
import game.components.Position;
import geometry.Coordinates;
import geometry.Hexagon;


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

	public function tileChanged(position:Coordinates, oldType:TileType, newType:TileType) {
		stage.tileRenderer.setTileTypeAt(position, newType);
	}

	override public function addToEngine(engine:Engine) {
		super.addToEngine(engine);
		visibles = engine.getNodeList(VisibleNode);
		healthies = engine.getNodeList(VisiblyHealthyNode);
		visibles.nodeAdded.add(function (node:VisibleNode) {
			var pixPosition = stage.coordinates.toPixel(node.position);
			node.visible.sprite.x = pixPosition.x;
			node.visible.sprite.y = pixPosition.y;
			stage.foreground.addChild(node.visible.sprite);
			node.visible.tile = stage.tileRenderer.createTileAt(node.visible.tileType, pixPosition.x, pixPosition.y);
		});
		visibles.nodeRemoved.add(function (node:VisibleNode) {
			stage.foreground.removeChild(node.visible.sprite);
			if (node.visible.tile != null) {
				stage.tileRenderer.removeTile(node.visible.tile);
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
		stage.background.graphics.beginFill(0x000000);
		stage.background.graphics.lineStyle(0, 0x000000);
		stage.background.graphics.drawRect(0, 0, stage.background.width, stage.background.height);
		stage.background.graphics.endFill();
	}
}
