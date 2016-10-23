package game;

import graph.Pathfindable;
import geometry.Coordinates;
import geometry.Map2D;

using Lambda;


class ObstacleGrid implements Pathfindable<Coordinates> {
	var map:Map2D<TileType>;
	public var vehicle:Vehicle;

	public inline function new(map, vehicle) {
		this.map = map;
		this.vehicle = vehicle;
	}

	public function distanceBetween(p1:Coordinates, p2:Coordinates):Int {
		return map.distanceBetween(p1, p2);
	}

	public function neighborsOf(p:Coordinates):Iterable<Coordinates> {
		return map.neighborsOf(p).filter(function (position) {
			return map.get(position).crossableWith(vehicle);
		});
	}
}
