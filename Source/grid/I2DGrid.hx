package grid;

import graph.IPathfindable;


interface I2DGrid extends IPathfindable<Coordinates> {
	var size(get,null):Int;
	function indexOf(x:Int, y:Int):Int;
	function contains(x:Int, y:Int):Bool;
	function cells():Iterator<Coordinates>;
}
