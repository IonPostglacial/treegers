package game;

import haxe.ds.HashMap;

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
import game.geometry.HexagonalGrid;
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
	public var grid:HexagonalGrid;

	var scene:Sprite;
	var engine = new Engine();
	var tickProvider:ITickProvider;
	var tiles:HexagonalMap<Tile.Type>;
	var obstacles:ObstacleGrid;
	var tileChangeListener:Array<TileChangeListener> = [];

	public function new(scene:Sprite, width:Int, height:Int) {
		this.scene = scene;
		this.grid = new HexagonalGrid(width, height, 32);
		this.tiles = new HexagonalMap<Tile.Type>(width, height, Tile.Type.Ground);
		this.tiles.set(3, 2, Tile.Type.Pikes);
		this.tiles.set(3, 3, Tile.Type.Cliff);
		this.tiles.set(3, 4, Tile.Type.Cliff);
		this.tiles.set(3, 5, Tile.Type.Cliff);
		this.tiles.set(1, 0, Tile.Type.Arrow(1, 0));
		this.tiles.set(11, 0, Tile.Type.Arrow(-1, 0));
		this.obstacles = new ObstacleGrid(this.grid, this.tiles, Tile.Vehicle.Foot);
		prepare(scene, width, height);
	}

	public function tileAt(position:Position) {
		return tiles.get(position.x, position.y);
	}

	public function setTileAt(position:Position, value:Tile.Type) {
		var oldTileType = tiles.get(position.x, position.y);
		tiles.set(position.x, position.y, value);
		for (listener in tileChangeListener) {
			listener.tileChanged(position, oldTileType, value);
		}
	}

	public function obstaclesFor(vehicle:Tile.Vehicle):graph.Path.Findable<Position> {
		obstacles.vehicle = vehicle;
		return obstacles;
	}

	public function start() {
		tickProvider = new FrameTickProvider(scene);
		tickProvider.add(engine.update);
		tickProvider.start();
	}

	function addSystem(system:System, priority:Int) {
		if (Std.is(system, TileChangeListener)) {
			tileChangeListener.push(cast system);
		}
		engine.addSystem(system, priority);
	}

	function prepare(scene:Sprite, width:Float, height:Float):Void {
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

		var gruntSprite = new Sprite();
		gruntSprite.graphics.beginFill(0xBB5555);
		Shape.hexagon(gruntSprite.graphics, new Hexagon(0, 0, grid.radius));

		var buttonSprite = new Sprite();
		buttonSprite.graphics.beginFill(0x0066BB);
		Shape.hexagon(buttonSprite.graphics, new Hexagon(0, 0, grid.radius));

		var ballSprite = new Sprite();
		ballSprite.graphics.beginFill(0x777777);
		Shape.hexagon(ballSprite.graphics, new Hexagon(0, 0, grid.radius));

		var grunt = new Entity()
		.add(new Position(0, 0))
		.add(new Health(100, 100, 2))
		.add(new Visible(gruntSprite))
		.add(new Movement(Tile.Vehicle.Foot, 0.5))
		.add(new Controled());

		var button = new Entity()
		.add(new Position(5, 0))
		.add(new Visible(buttonSprite))
		.add(new Button(false, [new Position(1, 1)], Tile.Type.Ground, Tile.Type.Water));

		var rollingBall = new Entity()
		.add(new Position(4, 0))
		.add(new Visible(ballSprite))
		.add(new Collectible([new Health(0, 100, 2)]))
		.add(new Movement(Tile.Vehicle.Foot, 1.5))
		.add(new LinearWalker(1, 0));

		engine.addEntity(grunt);
		engine.addEntity(button);
		engine.addEntity(rollingBall);
	}
}
