package game;

import ash.core.Engine;
import ash.core.Entity;

import game.components.Position;
import game.components.Button;
import game.components.Controled;
import game.components.Visible;
import game.components.Health;
import game.components.LinearWalker;
import game.components.Movement;
import game.components.Position;
import game.components.Collectible;

import geometry.Coordinates;

class EntityLoader {
	public static function gruntAt(id:Int, coordinates:Coordinates):Entity {
		return new Entity()
		.add(new Position(coordinates.x, coordinates.y))
		.add(new Health(100, 100, 2))
		.add(new Visible(id))
		.add(new Movement(Vehicle.Foot, 0.5))
		.add(new Controled());
	}

	public static function buttonAt(id:Int, coordinates:Coordinates, switched:Array<tmx.TileObject>):Entity {
		return new Entity()
		.add(new Position(coordinates.x, coordinates.y))
		.add(new Visible(id))
		.add(new Button(false, switched));
	}

	public static function rollingBallAt(id:Int, coordinates:Coordinates):Entity {
		return new Entity()
		.add(new Position(coordinates.x, coordinates.y))
		.add(new Visible(id))
		.add(new Collectible([new Health(0, 100, 2)]))
		.add(new Movement(Vehicle.Foot, 0.5))
		.add(new LinearWalker(1, 0));
	}

	public static function loadFromMap(engine:Engine, map:tmx.TiledMap) {
		var switchesMap = new Map<String, tmx.TileObject>();
		var switchedMap = new Map<String, Array<tmx.TileObject>>();
		for (objectLayer in map.objectLayers) {
			for (object in objectLayer.objects) {
				var terrains = map.tilesets[0].terrains.get(object.gid);
				var terrain = Terrain.Grass;
				if (terrains != null) {
					terrain = Terrain.createByIndex(terrains[0]);
				}
				switch (terrain) {
				case Terrain.Button:
					var switchId = object.properties.get("switch@");
					switchesMap.set(switchId, object);
				case Terrain.RollingBall:
					engine.addEntity(rollingBallAt(object.id, object.coords));
				case Terrain.Grunt:
					engine.addEntity(gruntAt(object.id, object.coords));
				default:
					object.active = false;
					var switchId = object.properties.get("switch$");
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
			if (switchedObjects == null) {
				switchedObjects = [];
			}
			engine.addEntity(buttonAt(switchObject.id, switchObject.coords, switchedObjects));
		}
	}
}
