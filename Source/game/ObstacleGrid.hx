package game;

import graph.Pathfindable;
import geometry.Coordinates;
import geometry.Map2D;
import geometry.HexagonalMap;
import geometry.OrthogonalMap;
import geometry.Grid2D;

using Lambda;


class ObstacleGrid implements Pathfindable<Coordinates> implements TileObjectListener {
	var map:tmx.TiledMap;
	var obstacles:Map2D<Bool>;
	public var vehicle:Vehicle;
	static var arrowDeltas = [[0, -1], [1, 0], [-1, 0], [0, 1], [1, -1], [-1, 1]];

	public inline function new(map:tmx.TiledMap, vehicle) {
		this.map = map;
		this.vehicle = vehicle;
		this.obstacles = if (map.orientation == tmx.Orientation.Hexagonal) {
			new HexagonalMap(map.width, map.height);
		} else {
			new OrthogonalMap(map.width, map.height);
		}
		for (coords in map.bgTiles.keys()) {
			var tileType = map.bgTiles.get(coords);
			var crossable = this.crossable(tileType);
			this.obstacles.set(coords, crossable || activeCrossableTileObject(coords));
		}
	}

	public function distanceBetween(p1:Coordinates, p2:Coordinates):Int {
		return map.grid.distanceBetween(p1, p2);
	}

	public function neighborsOf(p:Coordinates):Iterable<Coordinates> {
		return map.grid.neighborsOf(p).filter(function (position) {
			return this.obstacles.get(position);
		});
	}

	public inline function isCrossable(p:Coordinates):Bool {
		return this.obstacles.get(p);
	}

	public function isHurting(gid:Int):Bool {
		var tileTerrains = this.map.tilesets[0].terrains.get(gid);
		if (tileTerrains == null) {
			return false;
		}
		for (terrain in tileTerrains) {
			if (terrain == Type.enumIndex(Terrain.Pikes)) {
				return true;
			}
		}
		return false;
	}

	public function asArrow(gid:Int):TileArrow {
		var tileTerrains = this.map.tilesets[0].terrains.get(gid);
		if (tileTerrains == null) {
			return TileArrow.None;
		}
		var arrowIndex = tileTerrains.indexOf(Type.enumIndex(Terrain.Arrow));
		if (arrowIndex >= 0) {
			var dxdy = arrowDeltas[arrowIndex];
			return TileArrow.Arrow(dxdy[0], dxdy[1]);
		} else {
			return TileArrow.None;
		}
	}

	function crossable(gid:Int):Bool {
		var tileTerrains = this.map.tilesets[0].terrains.get(gid);
		if (tileTerrains == null) {
			return true;
		}
		for (terrain in tileTerrains) {
			if (terrain == Type.enumIndex(Terrain.Obstacle) ||
					this.vehicle == Vehicle.Foot && terrain == Type.enumIndex(Terrain.Water)) {
				return false;
			}
		}
		return true;
	}

	public function tileObjectStatusChanged(tileObject:tmx.TileObject, active:Bool):Void {
		var tileType:Int;
		if (active) {
			tileType = tileObject.gid;
		} else {
			tileType = map.bgTiles.get(tileObject.coords);
		}
		this.obstacles.set(tileObject.coords, this.crossable(tileType));
	}

	public function activeCrossableTileObject(p:Coordinates):Bool {
		for (objectLayer in map.objectLayers) {
			for (tileObject in objectLayer.objects) {
				var tileType:Int = tileObject.gid;
				if (tileObject.active && tileObject.coords.equals(p)) {
					return this.crossable(tileType);
				}
			}
		}
		return false;
	}
}
