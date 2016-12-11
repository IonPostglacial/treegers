package game.map;

import geometry.Coordinates;
import geometry.HexagonalMap;
import geometry.Map2D;
import geometry.OrthogonalMap;

using Lambda;


class WorldMap {
	var map:tmx.TiledMap;
	var ground:Map2D<GroundType>;
	var targetObjects:Iterable<TargetObject>;

	public var grids(default,null):Array<WorldGrid> = [];
	var tileObjectsListeners:Array<ITargetObjectListener> = [];

	public function new(map:tmx.TiledMap) {
		this.map = map;
		var targetObjects = [];
		for (layer in this.map.objectLayers) {
			for (object in layer.objects) {
				var tileTerrains = this.map.tilesets[0].terrains.get(object.gid);
				targetObjects.push(new TargetObject(object, GroundTypeProperties.fromTerrains(tileTerrains)));
			}
		}
		this.targetObjects = targetObjects;
		this.ground = if (map.orientation == tmx.Orientation.Hexagonal) {
			new HexagonalMap(map.width, map.height);
		} else {
			new OrthogonalMap(map.width, map.height);
		}
		for (coords in map.bg.tiles.keys()) {
			var tileType = map.bg.tiles.get(coords);
			var groundType = tileTypeToGroundType(tileType);
			this.ground.set(coords, groundType);
		}
		for (objectLayer in map.objectLayers) {
			for (tileObject in objectLayer.objects) {
				var tileType:Int = tileObject.gid;
				if (tileObject.active) {
					this.ground.set(tileObject.coords, tileTypeToGroundType(tileType));
				}
			}
		}
		for (vehicle in Type.allEnums(Vehicle)) {
			this.grids.push(new WorldGrid(this.ground, this.map.grid, vehicle));
		}
	}

	public function allTargetsWithType(type:GroundType):Iterable<TargetObject> {
		return targetObjects.filter(function(object) return object.groundType == type);
	}

	public function at(p:Coordinates):GroundType {
		return this.ground.get(p);
	}

	function tileTypeToGroundType(tileType:Int):GroundType {
		var tileTerrains = this.map.tilesets[0].terrains.get(tileType);
		return GroundTypeProperties.fromTerrains(tileTerrains);
	}

	public inline function forVehicle(vehicle:Vehicle):WorldGrid {
		return this.grids[Type.enumIndex(vehicle)];
	}

	public function setTargetStatus(target:TargetObject, active:Bool) {
		target.tileObject.active = active;
		var tileType:Int;
		if (active) {
			tileType = target.tileObject.gid;
		} else {
			tileType = map.bg.tiles.get(target.tileObject.coords);
		}
		this.ground.set(target.tileObject.coords, this.tileTypeToGroundType(tileType));
		for (listener in tileObjectsListeners) {
			listener.targetObjectStatusChanged(target, active);
		}
	}

	public inline function addTileObjectsListeners(listener:ITargetObjectListener) {
		this.tileObjectsListeners.push(listener);
	}
}
