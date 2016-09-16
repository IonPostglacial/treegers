package game.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;

import openfl.display.Sprite;
import openfl.Lib;

import drawing.Shape;
import game.components.Health;
import game.nodes.HealthyGraphicalNode;
import hex.Hexagon;


class EyeCandySystem extends System {
	var game:GameStage;
	var healthies:NodeList<HealthyGraphicalNode>;

	static var HEALTH_COLOR = 0x00FF00;
	static var GAUGE_LHEIGHT = 2;
	static var GAUGE_WIDTH = Conf.HEX_RADIUS;
	static var GAUGE_HEIGHT = 5;

	public function new(game:GameStage) {
		this.game = game;
		drawBackground();
		super();
	}

	override public function update(deltaTime:Float) {
		for (healthy in healthies) {
			updateHealthyNode(healthy, deltaTime);
		}
	}

	override public function addToEngine(engine:Engine) {
		healthies = engine.getNodeList(HealthyGraphicalNode);

		healthies.nodeAdded.add(function (node:HealthyGraphicalNode) {
			node.eyeCandy.sprite.addChild(createHealthSprite(node.health));
		});
		healthies.nodeRemoved.add(function (node:HealthyGraphicalNode) {
			node.eyeCandy.sprite.removeChild(node.eyeCandy.sprite.getChildByName("health"));
		});
	}

	static inline function createHealthSprite(health:Health):Sprite {
		var selection = new Sprite();
		selection.name = "health";
		selection.x -= Conf.HEX_RADIUS / 2;
		selection.y -= Conf.HEX_RADIUS;
		return selection;
	}

	function updateHealthyNode(node:HealthyGraphicalNode, deltaTime:Float) {
		var healthSprite = cast (node.eyeCandy.sprite.getChildByName("health"), Sprite);
		healthSprite.graphics.lineStyle(GAUGE_LHEIGHT, 0x000000);
		healthSprite.graphics.beginFill(0x000000);
		healthSprite.graphics.drawRect(0, 0, GAUGE_WIDTH, GAUGE_HEIGHT);
		healthSprite.graphics.beginFill(HEALTH_COLOR);
		healthSprite.graphics.drawRect(0, 0, GAUGE_WIDTH * (node.health.level / node.health.max), GAUGE_HEIGHT);
		healthSprite.graphics.endFill();
	}

	function drawBackground() {
		Lib.current.graphics.beginFill(0x000000);
		Lib.current.graphics.drawRect(0, 0, 800, 600);
		Lib.current.graphics.endFill();
		for (position in game.grid.positions) {
			var tilePoint = Shape.positionToPoint(position, game.grid.radius);
			var tileType = game.tileAt(position);
			Lib.current.graphics.beginFill(Tile.Color.of(tileType));
			Shape.hexagon(Lib.current.graphics, new Hexagon(tilePoint.x, tilePoint.y, game.grid.radius));
			Lib.current.graphics.endFill();
		}
		Lib.current.graphics.lineStyle(2, 0xffa200);
		Shape.hexagonGrid(Lib.current.graphics, game.grid);
	}
}
