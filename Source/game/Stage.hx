package game;

import openfl.display.Sprite;

import ash.tick.ITickProvider;
import ash.tick.FrameTickProvider;
import ash.core.Engine;
import ash.core.Entity;
import ash.core.System;

import game.components.Position;

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
	public var obstacleGrids(default,null):Array<ObstacleGrid>;
	public var background:Sprite;
	public var foreground:Sprite;

	var engine = new Engine();
	var tickProvider:ITickProvider;
	var tileObjectsListeners:Array<TileObjectListener> = [];

	public function new(mapPath:String) {
		this.background = new Sprite();
		this.foreground = new Sprite();
		openfl.Lib.current.addChild(this.background);
		openfl.Lib.current.addChild(this.foreground);
		loadMap(mapPath);
		loadSystems();
		loadEntities();
	}

	public function tileAt(position:Coordinates):TileType {
		return map.bgTiles.get(position);
	}

	public inline function tileCrossableFor(coords:Coordinates, vehicle:Vehicle):Bool {
		return this.obstacleGrids[Type.enumIndex(vehicle)].isCrossable(coords);
	}

	public inline function addTileObjectsListeners(listener:TileObjectListener) {
		tileObjectsListeners.push(listener);
	}

	public function setTileObjectStatus(tileObject:tmx.TileObject, active:Bool) {
		tileObject.active = active;
		for (listener in tileObjectsListeners) {
			listener.tileObjectStatusChanged(tileObject, active);
		}
	}

	public function start() {
		tickProvider = new FrameTickProvider(openfl.Lib.current);
		tickProvider.add(engine.update);
		tickProvider.start();
	}

	function loadMap(name:String) {
		var mapXml = openfl.Assets.getText("assets/" + name);
		this.map = new tmx.TiledMap();
		this.map.loadFromXml(Xml.parse(mapXml));
		var obstacleGrids = [];
		for (vehicle in Type.allEnums(Vehicle)) {
			var obstacles = new ObstacleGrid(this.map, vehicle);
			this.addTileObjectsListeners(obstacles);
			obstacleGrids.push(obstacles);
		}
		this.obstacleGrids = obstacleGrids;
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
		addSystem(new VisiblyControledSystem(this), 4);
	}

	inline function addSystem(system:System, priority:Int) {
		if (Std.is(system, TileObjectListener)) {
			this.tileObjectsListeners.push(cast system);
		}
		this.engine.addSystem(system, priority);
	}

	function loadEntities() {
		var switchesMap = new Map<String, tmx.TileObject>();
		var switchedMap = new Map<String, Array<tmx.TileObject>>();
		for (objectLayer in map.objectLayers) {
			for (object in objectLayer.objects) {
				switch (object.gid) {
				case TileType.Button:
					var switchId = object.properties.get("switch");
					switchesMap.set(switchId, object);
				case TileType.RollingBall:
					engine.addEntity(Entities.rollingBallAt(object.id, object.coords));
				case TileType.Grunt:
					engine.addEntity(Entities.gruntAt(object.id, object.coords));
				default:
					this.setTileObjectStatus(object, false);
					var switchId = object.properties.get("switched");
					if (switchId != null) {
						var switchedObjects = switchedMap.get(switchId);
						if (switchedObjects == null) switchedObjects = [];
						switchedObjects.push(object);
						switchedMap.set(switchId, switchedObjects);
					}
				}
			}
		}

		for (switchId in switchesMap.keys()) {
			var switchObject = switchesMap.get(switchId);
			var switchedObjects = switchedMap.get(switchId);
			var switchedTileId1 = TileType.None;
			var switchedTileId2 = switchedTileId1;
			if (switchedObjects == null) {
				switchedObjects = [];
			} else if (switchedObjects.length > 0) {
				switchedTileId1 = map.bgTiles.get(switchedObjects[0].coords);
				switchedTileId2 = switchedObjects[0].gid;
			}
			engine.addEntity(Entities.buttonAt(switchObject.id, switchObject.coords, switchedObjects, switchedTileId1, switchedTileId2));
		}
	}
}
