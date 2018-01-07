package grid;

import graph.IPathfindable;


interface I2DGrid extends IPathfindable<Coordinates> {
	var size(get,null):Int;
	function contains(x:TilesCoord, y:TilesCoord):Bool;
	function cells():Iterator<Coordinates>;
}
