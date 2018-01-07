package game.map;

import game.nodes.SolidNode;
import graph.IPathfindable;
import grid.Coordinates;
import grid.I2DGrid;
import grid.Map2D;

using game.map.GroundTypeProperties;


/* A WorldView is a view of the World map for a particular Vehicle
 */
class WorldView implements IPathfindable<Coordinates> {
	public var ground:Map2D<GroundType>;
	public var grid:I2DGrid;
	public var vehicle:Vehicle;
	public var obstacles:Array<SolidNode>;

	public inline function new(ground, grid, obstacles, vehicle) {
		this.ground = ground;
		this.grid = grid;
		this.obstacles = obstacles;
		this.vehicle = vehicle;
	}

	public function distanceBetween(p1:Coordinates, p2:Coordinates):Int {
		return grid.distanceBetween(p1, p2);
	}

	public function neighborsOf(p:Coordinates):NeighborsIterator {
		return new NeighborsIterator(this, p);
	}

	public function nodeIndex(node:Coordinates):Int {
		return grid.nodeIndex(node);
	}

	public function areNeighbors(p1:Coordinates, p2:Coordinates):Bool {
		return grid.areNeighbors(p1, p2);
	}
}


class NeighborsIterator {
	var worldGrid:WorldView;
	var potentialNeighbors:Iterator<Coordinates>;
	var nextElement:Coordinates;

	public function new(worldGrid:WorldView, p:Coordinates) {
		this.worldGrid = worldGrid;
		this.potentialNeighbors = worldGrid.grid.neighborsOf(p);
	}

	public function iterator() {
		return this;
	}

	inline function obstacleDetected(coords:grid.Coordinates) {
		var isObstacle = false;
		for (obstacle in worldGrid.obstacles) {
			trace(coords);
			trace(obstacle.position);
			isObstacle = obstacle.position.x == coords.x && obstacle.position.y == coords.y;
			if (isObstacle) break;
		}
		return isObstacle;
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
		} while (hasNext && (!groundType.crossableWith(worldGrid.vehicle) || obstacleDetected(nextElement)));

		return hasNext;
	}

	public function next():Coordinates {
		return nextElement;
	}
}
