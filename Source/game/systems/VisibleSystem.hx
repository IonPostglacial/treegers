package game.systems;


import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.Tile;

import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.core.System;

import game.mapmanagement.TileObjectListener;
import game.components.Health;
import game.components.Visible;
import game.components.Health;
import game.components.Position;
import geometry.Coordinates;


class VisibleNode extends Node<VisibleNode> {
	public var visible:Visible;
	public var position:Position;
}

class VisiblyHealthyNode extends Node<VisiblyHealthyNode> {
	public var health:Health;
	public var position:Position;
	public var visible:Visible;
}

class VisibleSystem extends System implements TileObjectListener {
	var stage:Stage;
	var visibles:NodeList<VisibleNode>;
	var healthies:NodeList<VisiblyHealthyNode>;
	var mapRenderer(default,null):rendering.MapRenderer;

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

	public function tileObjectStatusChanged(tileObject:tmx.TileObject, active:Bool):Void {
		this.mapRenderer.getTileForObjectId(tileObject.id).visible = active;
	}

	override public function addToEngine(engine:Engine) {
		this.mapRenderer = new rendering.MapRenderer(this.stage.map);
		this.stage.background.addChild(this.mapRenderer);
		function prepareHealthy (node:VisiblyHealthyNode) {
			node.visible.sprite.addChild(createHealthSprite(node.health));
		};
		function prepareVisibles (node:VisibleNode) {
			var pixPosition = stage.map.coordinates.toPixel(node.position);
			node.visible.sprite.x = pixPosition.x;
			node.visible.sprite.y = pixPosition.y;
			stage.foreground.addChild(node.visible.sprite);
			node.visible.tile = this.mapRenderer.getTileForObjectId(node.visible.objectId);
		};
		healthies = engine.getNodeList(VisiblyHealthyNode);
		for (node in healthies) {
			prepareHealthy(node);
		}
		healthies.nodeAdded.add(prepareHealthy);
		healthies.nodeRemoved.add(function (node:VisiblyHealthyNode) {
			node.visible.sprite.removeChild(node.visible.sprite.getChildByName("health"));
		});
		visibles = engine.getNodeList(VisibleNode);
		for (node in visibles) {
			prepareVisibles(node);
		}
		visibles.nodeAdded.add(prepareVisibles);
		visibles.nodeRemoved.add(function (node:VisibleNode) {
			stage.foreground.removeChild(node.visible.sprite);
			if (node.visible.tile != null) {
				this.mapRenderer.removeTile(node.visible.tile);
			}
		});
		super.addToEngine(engine);
	}

	inline function createHealthSprite(health:Health):Sprite {
		var healthSprite = new Sprite();
		healthSprite.graphics.lineStyle(GAUGE_LHEIGHT, 0x000000);
		healthSprite.graphics.beginFill(HEALTH_COLOR);
		healthSprite.graphics.drawRect(0, 0, stage.map.tileWidth, GAUGE_HEIGHT);
		healthSprite.graphics.endFill();
		healthSprite.scrollRect = new openfl.geom.Rectangle(0, 0, stage.map.tileWidth, GAUGE_HEIGHT);
		healthSprite.name = "health";

		healthSprite.y -= 2 * GAUGE_HEIGHT;
		return healthSprite;
	}

	function updateHealthyNode(node:VisiblyHealthyNode, deltaTime:Float) {
		var healthSprite = node.visible.sprite.getChildByName("health");
		if (healthSprite != null) {
			var newWidth = Math.floor(stage.map.tileWidth * (node.health.level / node.health.max));
			if (healthSprite.width != newWidth) {
				healthSprite.width = newWidth;
			}
		}
	}
}
