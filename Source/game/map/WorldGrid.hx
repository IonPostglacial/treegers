package game.map;

import graph.IPathfindable;
import geometry.Coordinates;
import geometry.I2DGrid;
import geometry.Map2D;

using Lambda;
using game.map.GroundTypeProperties;


class WorldGrid implements IPathfindable<Coordinates> {
	var ground:Map2D<GroundType>;
	var grid:I2DGrid;
	var vehicle:Vehicle;

	public inline function new(ground:Map2D<GroundType>, grid:I2DGrid, vehicle:Vehicle) {
		this.ground = ground;
		this.grid = grid;
		this.vehicle = vehicle;
	}

	public function distanceBetween(p1:Coordinates, p2:Coordinates):Int {
		return grid.distanceBetween(p1, p2);
	}

	public function neighborsOf(p:Coordinates):Iterable<Coordinates> {
		return grid.neighborsOf(p).filter(function (position) {
			var groundType = ground.get(position);
			return groundType.crossableWith(vehicle);
		});
	}
}
