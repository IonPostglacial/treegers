package game.map;

import geometry.Coordinates;
import geometry.HexagonalMap;
import geometry.Map2D;
import geometry.OrthogonalMap;

class WorldMap {
	var map:tmx.TiledMap;
	var ground:Map2D<GroundType>;
	static var arrowDeltas = [[0, -1], [1, 0], [-1, 0], [0, 1], [1, -1], [-1, 1]];

	public var grids(default,null):Array<WorldGrid> = [];
	var tileObjectsListeners:Array<ITileObjectListener> = [];

	public function new(map:tmx.TiledMap) {
		this.map = map;
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

	public function at(p:Coordinates) {
		return this.ground.get(p);
	}

	function tileTypeToGroundType(tileType:Int):GroundType {
		var tileTerrains = this.map.tilesets[0].terrains.get(tileType);
		if (tileTerrains != null) {
			var i = 0;
			var waterTerrainsNumber = 0;
			for (terrain in tileTerrains) {
				switch (Terrain.createByIndex(terrain)) {
				case Terrain.Obstacle:
					return GroundType.Uncrossable;
				case Terrain.Water:
					waterTerrainsNumber += 1;
				case Terrain.Arrow:
					var dxdy = arrowDeltas[i];
					return GroundType.Arrow(dxdy[0], dxdy[1]);
				case Terrain.Pikes:
					return GroundType.Hurting(1);
				default: // pass
				}
				i += 1;
			}
			if (waterTerrainsNumber == 0) {
				return GroundType.Basic;
			} else if (waterTerrainsNumber < 4) { // TODO: make it work for Hexagonal maps.
				return GroundType.Uncrossable;
			} else {
				return GroundType.Water;
			}
		}
		return GroundType.Basic;
	}

	public inline function forVehicle(vehicle:Vehicle):WorldGrid {
		return this.grids[Type.enumIndex(vehicle)];
	}

	public function setObjectStatus(tileObject:tmx.TileObject, active:Bool) {
		tileObject.active = active;
		var tileType:Int;
		if (active) {
			tileType = tileObject.gid;
		} else {
			tileType = map.bg.tiles.get(tileObject.coords);
		}
		this.ground.set(tileObject.coords, this.tileTypeToGroundType(tileType));
		for (listener in tileObjectsListeners) {
			listener.tileObjectStatusChanged(tileObject, active);
		}
	}

	public inline function addTileObjectsListeners(listener:ITileObjectListener) {
		this.tileObjectsListeners.push(listener);
	}
}
