package game;

import graph.Pathfindable;
import geometry.Coordinates;
import geometry.Map2D;
import geometry.Grid2D;

using Lambda;


class ObstacleGrid implements Pathfindable<Coordinates> {
	var map:Map2D<TileType>;
	var grid:Grid2D;
	public var vehicle:Vehicle;

	public inline function new(map, grid, vehicle) {
		this.map = map;
		this.grid = grid;
		this.vehicle = vehicle;
	}

	public function distanceBetween(p1:Coordinates, p2:Coordinates):Int {
		return grid.distanceBetween(p1, p2);
	}

	public function neighborsOf(p:Coordinates):Iterable<Coordinates> {
		return grid.neighborsOf(p).filter(function (position) {
			return map.get(position).crossableWith(vehicle);
		});
	}
}
