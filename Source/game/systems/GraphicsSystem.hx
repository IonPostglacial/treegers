package game.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;

import openfl.display.Sprite;
import openfl.Lib;

import game.components.Health;
import game.nodes.ControledGraphicalNode;
import game.nodes.HealthyGraphicalNode;
import game.nodes.MovingGraphicalNode;
import drawing.Shape;
import hex.Hexagon;

import openfl.events.MouseEvent;


class GraphicsSystem extends System {
	var game:GameStage;
	var movers:NodeList<MovingGraphicalNode>;
	var healthies:NodeList<HealthyGraphicalNode>;
	var controledMovers:NodeList<ControledGraphicalNode>;

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
		for (mover in movers) {
			updateMovingGraphicalNode(mover, deltaTime);
		}
		for (controled in controledMovers) {
			updateControledGraphicalNode(controled, deltaTime);
		}
		for (healthy in healthies) {
			updateHealthyNode(healthy, deltaTime);
		}
	}

	override public function addToEngine(engine:Engine) {
		controledMovers = engine.getNodeList(ControledGraphicalNode);
		movers = engine.getNodeList(MovingGraphicalNode);
		healthies = engine.getNodeList(HealthyGraphicalNode);

		movers.nodeAdded.add(function (node:MovingGraphicalNode) {
			Lib.current.addChild(node.eyeCandy.sprite);
		});
		movers.nodeRemoved.add(function (node:MovingGraphicalNode) {
			Lib.current.removeChild(node.eyeCandy.sprite);
		});
		healthies.nodeAdded.add(function (node:HealthyGraphicalNode) {
			node.eyeCandy.sprite.addChild(createHealthSprite(node.health));
		});
		healthies.nodeRemoved.add(function (node:HealthyGraphicalNode) {
			node.eyeCandy.sprite.removeChild(node.eyeCandy.sprite.getChildByName("health"));
		});
	}

	static inline function createSelectionSprite():Sprite {
		var selection = new Sprite();
		selection.name = "selection";
		selection.graphics.lineStyle(2, 0xFFFF00);
		Shape.hexagon(selection.graphics, new Hexagon(0, 0, Conf.HEX_RADIUS));
		return selection;
	}

	static inline function createHealthSprite(health:Health):Sprite {
		var selection = new Sprite();
		selection.name = "health";
		selection.x -= Conf.HEX_RADIUS / 2;
		selection.y -= Conf.HEX_RADIUS;
		return selection;
	}

	function updateMovingGraphicalNode(node:MovingGraphicalNode, deltaTime:Float) {
		if (node.speed.oldPosition == null || !node.position.equals(node.speed.oldPosition)) {
			var pixPosition = Shape.positionToPoint(node.position, Conf.HEX_RADIUS);
			node.eyeCandy.sprite.x = pixPosition.x;
			node.eyeCandy.sprite.y = pixPosition.y;
		}
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

	function updateControledGraphicalNode(node:ControledGraphicalNode, deltaTime:Float) {
		var selection = node.eyeCandy.sprite.getChildByName("selection");
		if (node.controled.selected) {
			if (selection == null) {
				node.eyeCandy.sprite.addChildAt(createSelectionSprite(), 0);
			}
		} else if (selection != null) {
			node.eyeCandy.sprite.removeChild(selection);
		}
	}

	function drawBackground() {
		Lib.current.graphics.beginFill(0xbd7207);
		Lib.current.graphics.drawRect(0, 0, 800, 600);
		Lib.current.graphics.endFill();
		Lib.current.graphics.lineStyle(2, 0xffa200);
		drawing.Shape.hexagonGrid(Lib.current.graphics, game.grid);
	}
}
