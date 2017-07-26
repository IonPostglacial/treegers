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


class Stage {
	var engine:Engine;
	var orderBoard:Order.Board;
	var tickProvider:ITickProvider;

	public function new(mapPath:String, pixelWidth:Int, pixelHeight:Int) {
		this.engine = new Engine();

		var map = new tmx.TiledMap();
		var mapXml = openfl.Assets.getText("assets/" + mapPath);
		map.loadFromXml(Xml.parse(mapXml));

		var entityLoader = new EntityLoader();
		entityLoader.loadFromMap(this.engine, map);

		// Load systems #uses[map, pixelWidth, pixelHeight]
		{
			var mapRenderer = new rendering.MapRenderer(map);
			var worldMap = new WorldMap(map);
			var camera = new openfl.geom.Rectangle(0, 0, pixelWidth, pixelHeight);
			var selectionWidth = map.effectiveTileWidth;
			var selectionHeight = map.effectiveTileHeight;

			this.orderBoard = new Order.Board(camera, map.coordinateSystem);

			openfl.Lib.current.addChild(mapRenderer);
			openfl.Lib.current.scrollRect = camera;

			var visibleSystem = new VisibleSystem(map.coordinateSystem, mapRenderer);
			worldMap.addTileObjectsListeners(visibleSystem);

			var controledSystem = new ControledSystem(worldMap, this.orderBoard);

			var potentialTargetsSystem = new TargetsRenderingSystem(map.coordinateSystem, selectionWidth, selectionHeight);
			controledSystem.targetListListeners.push(potentialTargetsSystem);

			this.engine.addSystem(new CameraSystem(camera), 1);
			this.engine.addSystem(potentialTargetsSystem, 1);
			this.engine.addSystem(controledSystem, 1);
			this.engine.addSystem(new MovementSystem(), 2);
			this.engine.addSystem(new ActionSystem(worldMap), 2);
			this.engine.addSystem(new HealthSystem(worldMap), 2);
			this.engine.addSystem(new ManaSystem(), 2);
			this.engine.addSystem(new ButtonSystem(worldMap), 2);
			this.engine.addSystem(new CollectSystem(), 2);
			this.engine.addSystem(new LinearMovementSystem(worldMap), 3);
			this.engine.addSystem(new PathMovementSystem(worldMap), 3);
			this.engine.addSystem(visibleSystem, 4);
			this.engine.addSystem(new VisibleWithGaugeSystem(map.tileWidth), 5);
			this.engine.addSystem(new VisibleMovingSystem(map.coordinateSystem, map.tileWidth, map.tileHeight), 5);
			this.engine.addSystem(new VisibleControledSystem(this.orderBoard, map.coordinateSystem, selectionWidth, selectionHeight), 5);
		}
	}

	public function start() {
		tickProvider = new FrameTickProvider(openfl.Lib.current);
		tickProvider.add(update);
		tickProvider.start();
	}

	function update(deltaTime:Float) {
		this.engine.update(deltaTime);
		this.orderBoard.refresh();
	}
}
