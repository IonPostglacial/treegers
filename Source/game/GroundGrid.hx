package game;

import graph.Pathfindable;
import geometry.Coordinates;
import geometry.Map2D;
import geometry.HexagonalMap;
import geometry.OrthogonalMap;
import geometry.Grid2D;

using Lambda;


class GroundGrid implements Pathfindable<Coordinates> implements TileObjectListener {
	var map:tmx.TiledMap;
	var ground:Map2D<GroundType>;
	public var vehicle:Vehicle;
	static var arrowDeltas = [[0, -1], [1, 0], [-1, 0], [0, 1], [1, -1], [-1, 1]];

	public inline function new(map:tmx.TiledMap, vehicle) {
		this.map = map;
		this.vehicle = vehicle;
		this.ground = if (map.orientation == tmx.Orientation.Hexagonal) {
			new HexagonalMap(map.width, map.height);
		} else {
			new OrthogonalMap(map.width, map.height);
		}
		for (coords in map.bgTiles.keys()) {
			var tileType = map.bgTiles.get(coords);
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
	}

	public inline function at(coords:Coordinates):GroundType {
		return this.ground.get(coords);
	}

	inline function tileTypeToGroundType(tileType:Int):GroundType {
		var tileTerrains = this.map.tilesets[0].terrains.get(tileType);
		var groundType = GroundType.Basic;
		if (tileTerrains != null) {
			var i = 0;
			for (terrain in tileTerrains) {
				switch (Terrain.createByIndex(terrain)) {
				case Terrain.Obstacle:
					groundType = GroundType.Uncrossable;
					break; // the loop
				case Terrain.Water:
					if (this.vehicle == Vehicle.Foot) {
						groundType = GroundType.Uncrossable;
						break; // the loop
					}
				case Terrain.Arrow:
					var dxdy = arrowDeltas[i];
					groundType = GroundType.Arrow(dxdy[0], dxdy[1]);
					break; // the loop
				case Terrain.Pikes:
					var dxdy = arrowDeltas[i];
					groundType = GroundType.Hurting(1);
					break; // the loop
				default: // pass
				}
				i += 1;
			}
		}
		return groundType;
	}

	public function distanceBetween(p1:Coordinates, p2:Coordinates):Int {
		return map.grid.distanceBetween(p1, p2);
	}

	public function neighborsOf(p:Coordinates):Iterable<Coordinates> {
		return map.grid.neighborsOf(p).filter(function (position) {
			return this.ground.get(position) != GroundType.Uncrossable;
		});
	}

	public function tileObjectStatusChanged(tileObject:tmx.TileObject, active:Bool):Void {
		var tileType:Int;
		if (active) {
			tileType = tileObject.gid;
		} else {
			tileType = map.bgTiles.get(tileObject.coords);
		}
		this.ground.set(tileObject.coords, this.tileTypeToGroundType(tileType));
	}
}
