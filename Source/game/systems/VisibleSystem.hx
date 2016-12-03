package game.systems;


import openfl.display.Sprite;
import openfl.display.Tile;

import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.core.System;

import game.mapmanagement.TileObjectListener;
import game.components.Visible;
import game.components.Position;
import geometry.Coordinates;


class VisibleNode extends Node<VisibleNode> {
	public var visible:Visible;
	public var position:Position;
}

class VisibleSystem extends System implements TileObjectListener {
	var stage:Stage;
	var visibles:NodeList<VisibleNode>;
	var mapRenderer(default,null):rendering.MapRenderer;

	public function new(stage:Stage) {
		this.stage = stage;
		super();
	}

	public function tileObjectStatusChanged(tileObject:tmx.TileObject, active:Bool):Void {
		this.mapRenderer.getTileForObjectId(tileObject.id).visible = active;
	}

	override public function addToEngine(engine:Engine) {
		this.mapRenderer = new rendering.MapRenderer(this.stage.map);
		this.stage.background.addChild(this.mapRenderer);
		function prepareVisibles (node:VisibleNode) {
			var pixPosition = stage.map.coordinates.toPixel(node.position);
			node.visible.sprite.x = pixPosition.x;
			node.visible.sprite.y = pixPosition.y;
			stage.foreground.addChild(node.visible.sprite);
			node.visible.tile = this.mapRenderer.getTileForObjectId(node.visible.objectId);
		};
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
}
