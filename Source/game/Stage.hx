package game;

import openfl.display.Sprite;

import ash.tick.ITickProvider;
import ash.tick.FrameTickProvider;
import ash.core.Engine;
import ash.core.Entity;
import ash.core.System;

import game.components.Button;
import game.components.Controled;
import game.components.Visible;
import game.components.Health;
import game.components.LinearWalker;
import game.components.Movement;
import game.components.Position;
import game.components.Collectible;

import geometry.Coordinates;

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


class Stage {
	public var map(default,null):tmx.TiledMap;
	public var mapRenderer(default,null):rendering.MapRenderer;
	public var hexagonRadius(default,null):Float = 32;
	public var background:Sprite;
	public var foreground:Sprite;

	var engine = new Engine();
	var tickProvider:ITickProvider;
	var tileChangeListener:Array<TileChangeListener> = [];

	public function new(width:Int, height:Int) {
		this.background = new Sprite();
		this.foreground = new Sprite();
		openfl.Lib.current.addChild(this.background);
		openfl.Lib.current.addChild(this.foreground);
		loadMap("simple-stage.tmx", width, height);
		loadSystems();
		loadEntities(width, height);
	}

	public function tileAt(position:Coordinates):TileType {
		return map.bgTiles.get(position);
	}

	public function setTileAt(position:Coordinates, value:TileType) {
		var oldTileType = map.bgTiles.get(position);
		map.bgTiles.set(position, value);
		for (listener in tileChangeListener) {
			listener.tileChanged(position, oldTileType, value);
		}
	}

	public function start() {
		tickProvider = new FrameTickProvider(openfl.Lib.current);
		tickProvider.add(engine.update);
		tickProvider.start();
	}

	function loadMap(name:String, width:Int, height:Int) {
		var mapXml = openfl.Assets.getText("assets/" + name);
		this.map = new tmx.TiledMap();
		this.map.loadFromXml(Xml.parse(mapXml));
		this.mapRenderer = new rendering.MapRenderer(this.map);
		this.background.addChild(this.mapRenderer);
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

	function loadEntities(width:Float, height:Float) {
		var button = new Entity()
		.add(new Position(0, 10))
		.add(new Visible(TileType.Button))
		.add(new Button(false, [new Position(0, 4), new Position(0, 5), new Position(0, 6)], TileType.Water, TileType.Ground));

		var rollingBall = new Entity()
		.add(new Position(2, 7))
		.add(new Visible(TileType.RollinBall))
		.add(new Collectible([new Health(0, 100, 2)]))
		.add(new Movement(Vehicle.Foot, 1.5))
		.add(new LinearWalker(-1, 0));

		var grunt = new Entity()
		.add(new Position(0, 1))
		.add(new Health(100, 100, 2))
		.add(new Visible(TileType.Grunt))
		.add(new Movement(Vehicle.Foot, 0.5))
		.add(new Controled());

		engine.addEntity(button);
		engine.addEntity(rollingBall);
		engine.addEntity(grunt);
	}
}
