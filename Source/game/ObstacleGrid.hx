package game;

import graph.Pathfindable;
import game.components.Position;
import game.geometry.HexagonalGrid;
import game.geometry.HexagonalMap;


class ObstacleGrid implements Pathfindable<Position> {
	var grid:HexagonalGrid;
	var tiles:HexagonalMap<TileType>;
	public var vehicle:Vehicle;

	public inline function new(grid, tiles, vehicle) {
		this.grid = grid;
		this.tiles = tiles;
		this.vehicle = vehicle;
	}

	public function distanceBetween(p1:Position, p2:Position):Int {
		return grid.distanceBetween(p1, p2);
	}

	public function neighborsOf(p:Position):Iterable<Position> {
		return grid.neighborsOf(p).filter(function (position) {
			return tiles.get(position).crossableWith(vehicle);
		});
	}
}
