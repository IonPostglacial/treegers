package game;

import ash.tick.ITickProvider;
import ash.tick.FrameTickProvider;
import ash.core.Engine;

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
import game.map.WorldMap;


class Stage {
	var map(default,null):tmx.TiledMap;
	var mapRenderer(default,null):rendering.MapRenderer;
	var worldMap(default,null):WorldMap;

	var engine = new Engine();
	var entityLoader = new EntityLoader();
	var tickProvider:ITickProvider;

	public function new(mapPath:String, width:Int, height:Int) {
		var mapXml = openfl.Assets.getText("assets/" + mapPath);
		this.map = new tmx.TiledMap();
		this.map.loadFromXml(Xml.parse(mapXml));
		this.worldMap = new WorldMap(this.map);
		entityLoader.loadFromMap(this.engine, this.map);
		this.mapRenderer = new rendering.MapRenderer(this.map);
		openfl.Lib.current.addChild(this.mapRenderer);
		loadSystems(width, height);
	}

	public function start() {
		tickProvider = new FrameTickProvider(openfl.Lib.current);
		tickProvider.add(engine.update);
		tickProvider.start();
	}

	function loadSystems(width:Int, height:Int) {
		var selectionWidth = this.map.effectiveTileWidth;
		var selectionHeight = this.map.effectiveTileHeight;
		var visibleSystem = new VisibleSystem(this.map.coordinates, this.mapRenderer);
		this.worldMap.addTileObjectsListeners(visibleSystem);

		this.engine.addSystem(new ControledSystem(this.worldMap, this.map.coordinates, width, height, selectionWidth, selectionHeight), 1);
		this.engine.addSystem(new ActionSystem(), 2);
		this.engine.addSystem(new HealthSystem(this.worldMap), 2);
		this.engine.addSystem(new ManaSystem(), 2);
		this.engine.addSystem(new LinearMovementSystem(this.worldMap), 2);
		this.engine.addSystem(new PathMovementSystem(this.worldMap), 2);
		this.engine.addSystem(new ButtonSystem(this.worldMap), 2);
		this.engine.addSystem(new CollectSystem(), 2);
		this.engine.addSystem(new MovementSystem(), 3);
		this.engine.addSystem(visibleSystem, 4);
		this.engine.addSystem(new VisibleWithGaugeSystem(this.map.tileWidth), 5);
		this.engine.addSystem(new VisiblyMovingSystem(this.map.coordinates), 5);
		this.engine.addSystem(new VisiblyControledSystem(selectionWidth, selectionHeight), 5);
	}
}
