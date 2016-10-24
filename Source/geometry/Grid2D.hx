package geometry;

import graph.Pathfindable;


interface Grid2D extends Pathfindable<Coordinates> {
	var size(get,null):Int;
	function indexOf(x:Int, y:Int):Int;
	function contains(x:Int, y:Int):Bool;
	function cells():Iterator<Coordinates>;
}
