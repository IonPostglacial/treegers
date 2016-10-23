package geometry;

import graph.Pathfindable;


interface Map2D<T>
	extends haxe.Constraints.IMap<Coordinates, T>
	extends Pathfindable<Coordinates> {

}
