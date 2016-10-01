package game;

import graph.Pathfindable;
import game.components.Position;
import game.geometry.HexagonalGrid;
import game.geometry.HexagonalMap;


class ObstacleGrid implements Pathfindable<Position> {
	var map:HexagonalMap<TileType>;
	public var vehicle:Vehicle;

	public inline function new(map, vehicle) {
		this.map = map;
		this.vehicle = vehicle;
	}

	public function distanceBetween(p1:Position, p2:Position):Int {
		return map.distanceBetween(p1, p2);
	}

	public function neighborsOf(p:Position):Iterable<Position> {
		return map.neighborsOf(p).filter(function (position) {
			return map.get(position).crossableWith(vehicle);
		});
	}
}
