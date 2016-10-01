package game;


import openfl.display.Sprite;

import ash.tick.ITickProvider;
import ash.tick.FrameTickProvider;
import ash.core.Engine;
import ash.core.Entity;
import ash.core.System;

import game.systems.ActionSystem;
import game.systems.ControledSystem;
import game.systems.VisibleSystem;
import game.systems.VisiblyControledSystem;
import game.systems.VisiblyMovingSystem;
import game.systems.HealthSystem;
import game.systems.LinearMovementSystem;
import game.systems.PathMovementSystem;
import game.systems.MovementSystem;
import game.systems.ButtonSystem;
import game.systems.CollectSystem;

import game.drawing.Shape;
import game.geometry.Hexagon;
import game.geometry.HexagonalMap;

import game.components.Button;
import game.components.Controled;
import game.components.Visible;
import game.components.Health;
import game.components.LinearWalker;
import game.components.Movement;
import game.components.Position;
import game.components.Collectible;


class Stage {
	public var map(default, null):HexagonalMap<TileType>;
	public var hexagonRadius(default, null):Float = 32;

	var engine = new Engine();
	var tickProvider:ITickProvider;
	var tileChangeListener:Array<TileChangeListener> = [];

	public function new(width:Int, height:Int) {
		loadMap(width, height);
		loadSystems();
		loadEntities(width, height);
	}

	public function tileAt(position:Position) {
		return map.get(position);
	}

	public function setTileAt(position:Position, value:TileType) {
		var oldTileType = map.get(position);
		map.set(position, value);
		for (listener in tileChangeListener) {
			listener.tileChanged(position, oldTileType, value);
		}
	}

	public function start() {
		tickProvider = new FrameTickProvider(openfl.Lib.current);
		tickProvider.add(engine.update);
		tickProvider.start();
	}

	function loadMap(width:Int, height:Int) {
		this.map = new HexagonalMap<TileType>(width, height, TileType.Ground);
		this.map.set(new Position(3, 2), TileType.Pikes);
		this.map.set(new Position(3, 3), TileType.Cliff);
		this.map.set(new Position(3, 4), TileType.Cliff);
		this.map.set(new Position(3, 5), TileType.Cliff);
		this.map.set(new Position(1, 0), TileType.ArrowB);
		this.map.set(new Position(11, 0), TileType.ArrowD);
		this.map.set(new Position(1, 10), TileType.ArrowF);
	}

	function loadSystems() {
		addSystem(new ControledSystem(this), 1);
		addSystem(new ActionSystem(this), 2);
		addSystem(new HealthSystem(this), 2);
		addSystem(new LinearMovementSystem(this), 2);
		addSystem(new PathMovementSystem(this), 2);
		addSystem(new MovementSystem(this), 2);
		addSystem(new ButtonSystem(this), 2);
		addSystem(new CollectSystem(this), 2);
		addSystem(new VisibleSystem(this), 3);
		addSystem(new VisiblyMovingSystem(this), 4);
		addSystem(new VisibleControledSystem(this), 4);
	}

	function addSystem(system:System, priority:Int) {
		if (Std.is(system, TileChangeListener)) {
			tileChangeListener.push(cast system);
		}
		engine.addSystem(system, priority);
	}

	function loadEntities(width:Float, height:Float):Void {
		var gruntSprite = new Sprite();
		gruntSprite.graphics.beginFill(0xBB5555);
		Shape.hexagon(gruntSprite.graphics, new Hexagon(0, 0, hexagonRadius));

		var buttonSprite = new Sprite();
		buttonSprite.graphics.beginFill(0x0066BB);
		Shape.hexagon(buttonSprite.graphics, new Hexagon(0, 0, hexagonRadius));

		var ballSprite = new Sprite();
		ballSprite.graphics.beginFill(0x777777);
		Shape.hexagon(ballSprite.graphics, new Hexagon(0, 0, hexagonRadius));

		var grunt = new Entity()
		.add(new Position(0, 0))
		.add(new Health(100, 100, 2))
		.add(new Visible(gruntSprite))
		.add(new Movement(Vehicle.Foot, 0.5))
		.add(new Controled());

		var button = new Entity()
		.add(new Position(6, 0))
		.add(new Visible(buttonSprite))
		.add(new Button(false, [new Position(2, 1)], TileType.Ground, TileType.Water));

		var rollingBall = new Entity()
		.add(new Position(10, 0))
		.add(new Visible(ballSprite))
		.add(new Collectible([new Health(0, 100, 2)]))
		.add(new Movement(Vehicle.Foot, 1.5))
		.add(new LinearWalker(-1, 0));

		engine.addEntity(grunt);
		engine.addEntity(button);
		engine.addEntity(rollingBall);
	}
}
