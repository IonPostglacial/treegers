package game.map;

import grid.Coordinates;
import grid.TilesCoord;
import grid.hex.CompactMap as HexMap;
import grid.Map2D;
import grid.ortho.CompactMap as OrthoMap;
import game.nodes.SolidNode;

using Lambda;


class WorldMap {
	var map:tmx.TiledMap;
	var groundTypeByCoords:Map2D<GroundType>;
	var targetObjects:Iterable<TargetObject>;

	public var obstacles(default,null):Array<SolidNode> = [];
	var views(default,null):Array<WorldView>;
	var tileObjectsListeners:Array<ITargetObjectListener> = [];

	public function new(map:tmx.TiledMap) {
		this.map = map;
		targetObjects = map.objectLayers
							.flatMap(function (layer) return
								layer.objects
									.map(TargetObject.fromMapTileObject.bind(map, _)));
		groundTypeByCoords = if (map.orientation == tmx.Orientation.Hexagonal) {
			new HexMap(map.width, map.height);
		} else {
			new OrthoMap(map.width, map.height);
		}
		for (coords in map.bg.tiles.keys()) {
			groundTypeByCoords.set(coords, tileTypeToGroundType(map, map.bg.tiles.get(coords)));
		}
		for (objectLayer in map.objectLayers) {
			objectLayer.objects
				.filter(function (tileObject) return tileObject.active)
				.iter(function (tileObject) return
					groundTypeByCoords.setAt(tileObject.coordX, tileObject.coordY, tileTypeToGroundType(map, tileObject.gid)));
		}
		views = Type.allEnums(Vehicle).map(WorldView.new.bind(this.groundTypeByCoords, this.map.grid, _));
	}

	public function areNeighbors(c1:Coordinates, c2:Coordinates):Bool {
		return this.map.grid.areNeighbors(c1, c2);
	}

	public function allTargetsWithType(type:GroundType):Iterable<TargetObject> {
		return targetObjects.filter(function (object) return object.groundType == type);
	}

	public function at(x:TilesCoord, y:TilesCoord):GroundType {
		return this.groundTypeByCoords.getAt(x, y);
	}

	static inline function tileTypeToGroundType(map:tmx.TiledMap, tileType:Int):GroundType {
		var tileTerrains = map.tilesets[0].terrains.get(tileType - map.tilesets[0].firstGid);
		return GroundTypeProperties.fromTerrains(tileTerrains);
	}

	public inline function viewForVehicle(vehicle:Vehicle):WorldView {
		return this.views[Type.enumIndex(vehicle)];
	}

	public function setTargetStatus(target:TargetObject, active:Bool) {
		target.tileObject.active = active;
		var tileType:Int;
		if (active) {
			tileType = target.tileObject.gid;
		} else {
			tileType = map.bg.tiles.getAt(target.tileObject.coordX, target.tileObject.coordY);
		}
		this.groundTypeByCoords.setAt(target.tileObject.coordX, target.tileObject.coordY, tileTypeToGroundType(map, tileType));
		for (listener in tileObjectsListeners) {
			listener.targetObjectStatusChanged(target, active);
		}
	}

	public inline function addTileObjectsListeners(listener:ITargetObjectListener) {
		this.tileObjectsListeners.push(listener);
	}
}
