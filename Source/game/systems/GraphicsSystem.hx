package game.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;

import openfl.display.Sprite;
import openfl.Lib;

import game.nodes.ControledGraphicalNode;
import game.nodes.MovingGraphicalNode;
import drawing.Shape;
import hex.Hexagon;

import openfl.events.MouseEvent;


class GraphicsSystem extends System {
	var game:GameStage;
	var movers:NodeList<MovingGraphicalNode>;
	var controledMovers:NodeList<ControledGraphicalNode>;

	public function new(game:GameStage) {
		this.game = game;
		drawBackground();
		super();
	}

	override public function update(deltaTime:Float) {
		for (node in movers) {
			updateMovingGraphicalNode(node, deltaTime);
		}
		for (node in controledMovers) {
			updateControledGraphicalNode(node, deltaTime);
		}
	}

	override public function addToEngine(engine:Engine) {
		controledMovers = engine.getNodeList(ControledGraphicalNode);
		movers = engine.getNodeList(MovingGraphicalNode);
		movers.nodeAdded.add(function (node:MovingGraphicalNode) {
			Lib.current.addChild(node.eyeCandy.sprite);
		});
		movers.nodeRemoved.add(function (node:MovingGraphicalNode) {
			Lib.current.removeChild(node.eyeCandy.sprite);
		});
	}

	static inline function createSelectionSprite():Sprite {
		var selection = new Sprite();
		selection.name = "selection";
		selection.graphics.lineStyle(2, 0xFFFF00);
		Shape.hexagon(selection.graphics, new Hexagon(0, 0, Conf.HEX_RADIUS));
		return selection;
	}

	function updateMovingGraphicalNode(node:MovingGraphicalNode, deltaTime:Float) {
		if (node.speed.oldPosition == null || !node.position.equals(node.speed.oldPosition)) {
			var pixPosition = Shape.positionToPoint(node.position, Conf.HEX_RADIUS);
			node.eyeCandy.sprite.x = pixPosition.x;
			node.eyeCandy.sprite.y = pixPosition.y;
		}
	}

	function updateControledGraphicalNode(node:ControledGraphicalNode, deltaTime:Float) {
		var selection = node.eyeCandy.sprite.getChildByName("selection");
		if (node.controled.selected) {
			if (selection == null) {
				node.eyeCandy.sprite.addChild(createSelectionSprite());
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
