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
	public var map:HexagonalMap<TileType>;
	public var hexagonRadius:Float = 32;

	var scene:Sprite;
	var engine = new Engine();
	var tickProvider:ITickProvider;
	var pathfinders:Array<graph.Pathfinder<Position>> = [];
	var tileChangeListener:Array<TileChangeListener> = [];

	public function new(scene:Sprite, width:Int, height:Int) {
		this.scene = scene;
		loadMap(width, height);
		loadSystems();
		loadEntities(scene, width, height);
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

	public function findPath(vehicle:Vehicle, start:Position, goal:Position):Array<Position> {
		return pathfinders[Type.enumIndex(vehicle)].find(start, goal);
	}

	public function start() {
		tickProvider = new FrameTickProvider(scene);
		tickProvider.add(engine.update);
		tickProvider.start();
	}

	function loadMap(width:Int, height:Int) {
		this.map = new HexagonalMap<TileType>(width, height, TileType.Ground);
		this.map.set(new Position(3, 2), TileType.Pikes);
		this.map.set(new Position(3, 3), TileType.Cliff);
		this.map.set(new Position(3, 4), TileType.Cliff);
		this.map.set(new Position(3, 5), TileType.Cliff);
		this.map.set(new Position(1, 0), TileType.ArrowA);
		this.map.set(new Position(11, 0), TileType.ArrowD);
		for (vehicle in Type.allEnums(Vehicle)) {
			var obstacles = new ObstacleGrid(this.map, vehicle);
			this.pathfinders.push(new graph.Pathfinder(obstacles));
		}
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

	function loadEntities(scene:Sprite, width:Float, height:Float):Void {
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
		.add(new Position(5, 0))
		.add(new Visible(buttonSprite))
		.add(new Button(false, [new Position(1, 1)], TileType.Ground, TileType.Water));

		var rollingBall = new Entity()
		.add(new Position(4, 0))
		.add(new Visible(ballSprite))
		.add(new Collectible([new Health(0, 100, 2)]))
		.add(new Movement(Vehicle.Foot, 1.5))
		.add(new LinearWalker(1, 0));

		engine.addEntity(grunt);
		engine.addEntity(button);
		engine.addEntity(rollingBall);
	}
}
