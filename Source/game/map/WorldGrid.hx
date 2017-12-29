package game.map;

import graph.IPathfindable;
import grid.Coordinates;
import grid.I2DGrid;
import grid.Map2D;

using game.map.GroundTypeProperties;


class WorldGrid implements IPathfindable<Coordinates> {
	public var ground:Map2D<GroundType>;
	public var grid:I2DGrid;
	public var vehicle:Vehicle;

	public inline function new(ground:Map2D<GroundType>, grid:I2DGrid, vehicle:Vehicle) {
		this.ground = ground;
		this.grid = grid;
		this.vehicle = vehicle;
	}

	public function distanceBetween(p1:Coordinates, p2:Coordinates):Int {
		return grid.distanceBetween(p1, p2);
	}

	public function neighborsOf(p:Coordinates):WorldGridNeighborsIterator {
		return new WorldGridNeighborsIterator(this, p);
	}

	public function nodeIndex(node:Coordinates):Int {
		return grid.nodeIndex(node);
	}

	public function areNeighbors(p1:Coordinates, p2:Coordinates):Bool {
		return grid.areNeighbors(p1, p2);
	}
}


class WorldGridNeighborsIterator {
	var worldGrid:WorldGrid;
	var potentialNeighbors:Iterator<Coordinates>;
	var nextElement:Coordinates;

	public function new(worldGrid:WorldGrid, p:Coordinates) {
		this.worldGrid = worldGrid;
		this.potentialNeighbors = worldGrid.grid.neighborsOf(p);
	}

	public function iterator() {
		return this;
	}

	public function hasNext():Bool {
		var hasNext:Bool;
		var groundType:GroundType = null;
		do {
			hasNext = potentialNeighbors.hasNext();
			if (hasNext) {
				nextElement = potentialNeighbors.next();
				groundType = worldGrid.ground.get(nextElement);
			}
		} while (hasNext && !groundType.crossableWith(worldGrid.vehicle));

		return hasNext;
	}

	public function next():Coordinates {
		return nextElement;
	}
}
