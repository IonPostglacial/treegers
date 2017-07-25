package grid;

import grid.IntMath.abs;


@:publicFields
class OrthogonalGrid implements I2DGrid {
	private static var deltas = [-1, -1, -1, 0, -1, 1, 0, -1, 0, 1, 1, -1, 1, 0, 1, 1];

	var width:Int;
	var height:Int;
	var size(get, never):Int;

	function new(width, height) {
		this.width = width;
		this.height = height;
	}

	inline function indexOf(x:Int, y:Int):Int {
		return x + width * y;
	}

	inline function contains(x:Int, y:Int):Bool {
		return x >= 0 && x < width && y >= 0 && y < height;
	}

	function cells():Iterator<Coordinates> {
		return new OrthogonalGridIterator(width, height);
	}

	function get_size():Int {
		return width * height;
	}

	inline function distanceBetween(p1:Coordinates, p2:Coordinates):Int {
		var dx = p1.x - p2.x;
		var dy = p1.y - p2.y;
		return dx * dx + dy * dy;
	}

	function areNeighbors(p1:Coordinates, p2:Coordinates):Bool {
		return abs(p1.x - p2.x) <= 1 && abs(p1.y - p2.y) <= 1;
	}

	inline function neighborsOf(p:Coordinates):OrthogonalCoordinatesNeighbors {
		return new OrthogonalCoordinatesNeighbors(this, p);
	}

	function nodeIndex(node:Coordinates):Int {
		return node.x + node.y * width;
	}
}
