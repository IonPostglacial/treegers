package game;

import openfl.display.Sprite;

import ash.tick.ITickProvider;
import ash.tick.FrameTickProvider;
import ash.core.Engine;
import ash.core.System;

import game.systems.ActionSystem;
import game.systems.ControledSystem;
import game.systems.VisibleSystem;
import game.systems.VisibleWithGaugeSystem;
import game.systems.VisiblyControledSystem;
import game.systems.VisiblyMovingSystem;
import game.systems.HealthSystem;
import game.systems.LinearMovementSystem;
import game.systems.PathMovementSystem;
import game.systems.MovementSystem;
import game.systems.ButtonSystem;
import game.systems.CollectSystem;
import game.systems.ManaSystem;
import game.mapmanagement.GroundManager;
import game.mapmanagement.TileObjectListener;


class Stage {
	public var map(default,null):tmx.TiledMap;
	public var ground(default,null):GroundManager;
	public var background:Sprite;
	public var foreground:Sprite;
	public var camera(default,null):openfl.geom.Rectangle;

	var engine = new Engine();
	var entityLoader = new EntityLoader();
	var tickProvider:ITickProvider;

	public function new(mapPath:String, width:Int, height:Int) {
		this.background = new Sprite();
		this.foreground = new Sprite();
		openfl.Lib.current.scrollRect = new openfl.geom.Rectangle(0, 0, width, height);
		openfl.Lib.current.addChild(this.background);
		openfl.Lib.current.addChild(this.foreground);
		this.camera = openfl.Lib.current.scrollRect;
		var mapXml = openfl.Assets.getText("assets/" + mapPath);
		this.map = new tmx.TiledMap();
		this.map.loadFromXml(Xml.parse(mapXml));
		this.ground = new GroundManager(this.map);
		entityLoader.loadFromMap(this.engine, this.map);
		loadSystems();
	}

	public function start() {
		tickProvider = new FrameTickProvider(openfl.Lib.current);
		tickProvider.add(engine.update);
		tickProvider.start();
	}

	function loadSystems() {
		addSystem(new ControledSystem(this), 1);
		addSystem(new ActionSystem(this), 2);
		addSystem(new HealthSystem(this), 2);
		addSystem(new ManaSystem(this), 2);
		addSystem(new LinearMovementSystem(this), 2);
		addSystem(new PathMovementSystem(this), 2);
		addSystem(new MovementSystem(this), 2);
		addSystem(new ButtonSystem(this), 2);
		addSystem(new CollectSystem(this), 2);
		addSystem(new VisibleSystem(this), 3);
		addSystem(new VisibleWithGaugeSystem(this), 4);
		addSystem(new VisiblyMovingSystem(this), 4);
		addSystem(new VisiblyControledSystem(this), 4);
	}

	inline function addSystem(system:System, priority:Int) {
		if (Std.is(system, TileObjectListener)) {
			this.ground.addTileObjectsListeners(cast system);
		}
		this.engine.addSystem(system, priority);
	}
}
