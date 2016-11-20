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

import game.mapmanagement.Vehicle;

import geometry.Coordinates;

class EntityLoader {
	var entityBuilders = new Map<String, Int->Coordinates->Entity>();

	public function new() {
		this.entityBuilders.set("Grunt", function (id:Int, coordinates:Coordinates):Entity {
			return new Entity()
			.add(new Position(coordinates.x, coordinates.y))
			.add(new Health(100, 100, 2))
			.add(new Visible(id))
			.add(new Movement(Vehicle.Foot, 0.5))
			.add(new Controled());
		});
		this.entityBuilders.set("RollingBall", function (id:Int, coordinates:Coordinates):Entity {
			return new Entity()
			.add(new Position(coordinates.x, coordinates.y))
			.add(new Visible(id))
			.add(new Collectible([new Health(0, 100, 2)]))
			.add(new Movement(Vehicle.Foot, 0.5))
			.add(new LinearWalker(1, 0));
		});
	}

	function makeButton(id:Int, coordinates:Coordinates, switched:Array<tmx.TileObject>):Entity {
		return new Entity()
		.add(new Position(coordinates.x, coordinates.y))
		.add(new Visible(id))
		.add(new Button(false, switched));
	}

	public function loadFromMap(engine:Engine, map:tmx.TiledMap) {
		var switchesMap = new Map<String, tmx.TileObject>();
		var switchedMap = new Map<String, Array<tmx.TileObject>>();
		for (objectLayer in map.objectLayers) {
			for (object in objectLayer.objects) {
				if (object.type == "Button") {
					var switchId = object.properties.get("switch@");
					switchesMap.set(switchId, object);
				} else if (object.type == "") {
					object.active = false;
					var switchId = object.properties.get("switch$");
					if (switchId != null) {
						var switchedObjects = switchedMap.get(switchId);
						if (switchedObjects == null) switchedObjects = [];
						switchedObjects.push(object);
						switchedMap.set(switchId, switchedObjects);
					}
				} else {
					var builderFunction = this.entityBuilders.get(object.type);
					if (builderFunction != null) {
						engine.addEntity(builderFunction(object.id, object.coords));
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
			engine.addEntity(makeButton(switchObject.id, switchObject.coords, switchedObjects));
		}
	}
}
