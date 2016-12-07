package game.mapmanagement;

import graph.IPathfindable;
import geometry.Coordinates;

using Lambda;
using game.mapmanagement.GroundTypeProperties;


class GroundGrid implements IPathfindable<Coordinates> {
	var groundManager:GroundManager;
	var vehicle:Vehicle;

	public inline function new(groundManager:GroundManager, vehicle) {
		this.groundManager = groundManager;
		this.vehicle = vehicle;
	}

	public function distanceBetween(p1:Coordinates, p2:Coordinates):Int {
		return groundManager.map.grid.distanceBetween(p1, p2);
	}

	public function neighborsOf(p:Coordinates):Iterable<Coordinates> {
		return groundManager.map.grid.neighborsOf(p).filter(function (position) {
			var groundType = groundManager.at(position);
			return groundType.crossableWith(vehicle);
		});
	}
}
