package game;

import ash.tick.ITickProvider;
import ash.tick.FrameTickProvider;
import ash.core.Engine;

import game.systems.ActionSystem;
import game.systems.CameraSystem;
import game.systems.ControledSystem;
import game.systems.TargetsRenderingSystem;
import game.systems.VisibleSystem;
import game.systems.VisibleWithGaugeSystem;
import game.systems.VisibleControledSystem;
import game.systems.VisibleMovingSystem;
import game.systems.HealthSystem;
import game.systems.LinearMovementSystem;
import game.systems.PathMovementSystem;
import game.systems.MovementSystem;
import game.systems.ButtonSystem;
import game.systems.CollectSystem;
import game.systems.ManaSystem;
import game.map.WorldMap;


class Stage extends Engine {
	var worldMap(default,null):WorldMap;
	var entityLoader = new EntityLoader();
	var orderBoard:Order.Board;
	var tickProvider:ITickProvider;

	public function new(mapPath:String, pixelWidth:Int, pixelHeight:Int) {
		super();
		var mapXml = openfl.Assets.getText("assets/" + mapPath);
		var map = new tmx.TiledMap();
		map.loadFromXml(Xml.parse(mapXml));
		entityLoader.loadFromMap(this, map);
		var mapRenderer = new rendering.MapRenderer(map);
		openfl.Lib.current.addChild(mapRenderer);
		this.worldMap = new WorldMap(map);
		loadSystems(map, mapRenderer, pixelWidth, pixelHeight);
	}

	public function start() {
		tickProvider = new FrameTickProvider(openfl.Lib.current);
		tickProvider.add(update);
		tickProvider.start();
	}

	override function update(deltaTime:Float) {
		super.update(deltaTime);
		this.orderBoard.refresh();
	}

	function loadSystems(map:tmx.TiledMap, mapRenderer:rendering.MapRenderer, pixelWidth:Int, pixelHeight:Int) {
		var camera = new openfl.geom.Rectangle(0, 0, pixelWidth, pixelHeight);
		this.orderBoard = new Order.Board(camera, map.coordinateSystem);
		openfl.Lib.current.scrollRect = camera;
		var selectionWidth = map.effectiveTileWidth;
		var selectionHeight = map.effectiveTileHeight;
		var visibleSystem = new VisibleSystem(map.coordinateSystem, mapRenderer);
		this.worldMap.addTileObjectsListeners(visibleSystem);
		var controledSystem = new ControledSystem(this.worldMap, this.orderBoard);
		var potentialTargetsSystem = new TargetsRenderingSystem(map.coordinateSystem, selectionWidth, selectionHeight);
		controledSystem.targetListListeners.push(potentialTargetsSystem);

		this.addSystem(new CameraSystem(camera), 1);
		this.addSystem(potentialTargetsSystem, 1);
		this.addSystem(controledSystem, 1);
		this.addSystem(new MovementSystem(), 2);
		this.addSystem(new ActionSystem(this.worldMap), 2);
		this.addSystem(new HealthSystem(this.worldMap), 2);
		this.addSystem(new ManaSystem(), 2);
		this.addSystem(new ButtonSystem(this.worldMap), 2);
		this.addSystem(new CollectSystem(), 2);
		this.addSystem(new LinearMovementSystem(this.worldMap), 3);
		this.addSystem(new PathMovementSystem(this.worldMap), 3);
		this.addSystem(visibleSystem, 4);
		this.addSystem(new VisibleWithGaugeSystem(map.tileWidth), 5);
		this.addSystem(new VisibleMovingSystem(map.coordinateSystem, map.tileWidth, map.tileHeight), 5);
		this.addSystem(new VisibleControledSystem(this.orderBoard, map.coordinateSystem, selectionWidth, selectionHeight), 5);
	}
}
