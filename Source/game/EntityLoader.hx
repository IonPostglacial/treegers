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
import game.components.IOwningComponent;

import game.mapmanagement.Vehicle;

import geometry.Coordinates;

class EntityLoader {
	static inline var RELATED_COMPONENT_SIGIL = "=";
	static inline var ADD_COMPONENT_SIGIL = "+";
	static inline var COMPONENT_RELATION_SEPARATOR = ":";
	var entityBuilders = new Map<String, Entity->Int->Coordinates->Void>();

	public function new() {
		this.entityBuilders.set("Button", function (entity:Entity, id:Int, coordinates:Coordinates):Void {
			entity.add(new Button());
		});
		this.entityBuilders.set("Grunt", function (entity:Entity, id:Int, coordinates:Coordinates):Void {
			var health = new Health();
			entity.add(health)
			.add(new Movement())
			.add(new Controled());
		});
		this.entityBuilders.set("RollingBall", function (entity:Entity, id:Int, coordinates:Coordinates):Void {
			var health = new Health();
			health.level = 0;
			var collectible = new Collectible();
			collectible.components = [health];
			entity.add(collectible)
			.add(new Movement())
			.add(new LinearWalker());
		});
	}

	function addObjectRelation(relationsByObjectsId:Map<Int, Map<String, Array<tmx.TileObject>>>, propertyName:String, owned:tmx.TileObject) {
		var ownerId = Std.parseInt(owned.properties.get(propertyName));
		if (ownerId == null) {
			return; // TODO: maybe add a warning
		}
		var ownerRelations = relationsByObjectsId.get(ownerId);
		if (ownerRelations == null) ownerRelations = new Map();

		var ownedObjects = ownerRelations.get(propertyName);
		if (ownedObjects == null) ownedObjects = [];

		ownedObjects.push(owned);
		ownerRelations.set(propertyName, ownedObjects);
		relationsByObjectsId.set(ownerId, ownerRelations);
	}

	public function loadFromMap(engine:Engine, map:tmx.TiledMap) {
		var objectsById = new Map<Int, Entity>();
		var relationsByObjectsId = new Map<Int, Map<String, Array<tmx.TileObject>>>();
		for (objectLayer in map.objectLayers) {
			for (object in objectLayer.objects) {
				var builderFunction = this.entityBuilders.get(object.type);
				var entity:Null<Entity> = null;
				if (builderFunction != null) {
					entity = new Entity()
						.add(new Position(object.coords.x, object.coords.y))
						.add(new Visible(object.id));
					builderFunction(entity, object.id, object.coords);
					engine.addEntity(entity);
					objectsById.set(object.id, entity);
				} else {
					object.active = false;
				}
				for (property in object.properties.keys()) {
					switch(property.charAt(0)) {
					case RELATED_COMPONENT_SIGIL:
						addObjectRelation(relationsByObjectsId, property, object);
					case ADD_COMPONENT_SIGIL:
						// override components preset
						if (entity == null) {
							continue; // TODO: add a warning
						}
						var componentName = property.substr(1);
						var componentClass = Type.resolveClass("game.components." + componentName);
						var component = entity.get(componentClass);
						if (component == null) {
							// create empty component
							component = Type.createInstance(componentClass, []);
							entity.add(component);
						}
						var propsArray = object.properties.get(property).split(",");
						var componentProperties = new Map<String,String>();
						for (propVal in propsArray) {
							var propValArray = propVal.split(":");
							if (propValArray.length != 2) {
								continue; // TODO: add a warning
							}
							componentProperties.set(propValArray[0], propValArray[1]);
						}
						tmx.ObjectExt.fromMap(componentProperties, componentClass, component);
					default:
						// pass
					}
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
				if (!Std.is(component, IOwningComponent)) {
					continue; // TODO: maybe add a warning
				}
				for (object in ownedRelations.get(relation)) {
					component.addRelatedObject(componentRelation[1], object);
				}
			}
		}
	}
}
