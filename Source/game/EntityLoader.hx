package game;

import ash.core.Engine;
import ash.core.Entity;

import game.components.Button;
import game.components.Controled;
import game.components.Visible;
import game.components.Health;
import game.components.LinearWalker;
import game.components.Movement;
import game.components.Position;
import game.components.Collectible;
import game.components.OwningComponent;

import game.mapmanagement.Vehicle;

import geometry.Coordinates;

class EntityLoader {
	static inline var RELATED_COMPONENT_SIGIL = "=";
	static inline var COMPONENT_RELATION_SEPARATOR = ":";
	var entityBuilders = new Map<String, Int->Coordinates->Entity>();

	public function new() {
		this.entityBuilders.set("Button", function (id:Int, coordinates:Coordinates):Entity {
			return new Entity()
			.add(new Position(coordinates.x, coordinates.y))
			.add(new Visible(id))
			.add(new Button(false));
		});
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

	public function loadFromMap(engine:Engine, map:tmx.TiledMap) {
		var objectsById = new Map<Int, Entity>();
		var relationsByObjectsId = new Map<Int, Map<String, Array<tmx.TileObject>>>();
		for (objectLayer in map.objectLayers) {
			for (object in objectLayer.objects) {
				var builderFunction = this.entityBuilders.get(object.type);
				if (builderFunction != null) {
					var entity = builderFunction(object.id, object.coords);
					engine.addEntity(entity);
					objectsById.set(object.id, entity);
				} else {
					object.active = false;
				}
				for (property in object.properties.keys()) {
					if (property.charAt(0) != RELATED_COMPONENT_SIGIL) {
						continue; // TODO : we will want to overload components presets
					}
					var ownerId = Std.parseInt(object.properties.get(property));
					if (ownerId == null) {
						continue; // TODO: maybe add a warning
					}
					var ownerRelations = relationsByObjectsId.get(ownerId);
					if (ownerRelations == null) ownerRelations = new Map();

					var ownedObjects = ownerRelations.get(property);
					if (ownedObjects == null) ownedObjects = [];

					ownedObjects.push(object);
					ownerRelations.set(property, ownedObjects);
					relationsByObjectsId.set(ownerId, ownerRelations);
				}
			}
		}
		for (ownerId in objectsById.keys()) {
			var owner = objectsById.get(ownerId);
			var ownedRelations = relationsByObjectsId.get(ownerId);
			if (owner == null || ownedRelations == null) {
				continue; // TODO: maybe add a warning if relations have no owner
			}
			for (relation in ownedRelations.keys()) {
				var componentRelation = relation.split(COMPONENT_RELATION_SEPARATOR);
				if (componentRelation.length != 2 || componentRelation[0].length == 0) {
					continue; // TODO: maybe add a warning
				}
				var componentName = componentRelation[0].substr(1);
				var componentClass = Type.resolveClass("game.components." + componentName);
				var component = owner.get(componentClass);
				if (!Std.is(component, OwningComponent)) {
					continue; // TODO: maybe add a warning
				}
				for (object in ownedRelations.get(relation)) {
					component.addRelatedObject(componentRelation[1], object);
				}
			}
		}
	}
}
