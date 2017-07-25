package grid.hex;

import grid.IntMath.abs;


@:publicFields
class Grid implements I2DGrid {
	private static var deltas = [-1, 0, -1, 1, 0, -1, 0, 1, 1, -1, 1, 0];

	var width:Int;
	var height:Int;
	var size(get, never):Int;

	function new(width, height) {
		this.width = width;
		this.height = height;
	}

	inline function indexOf(x:Int, y:Int):Int {
		return x + Std.int(y/2) + width * y;
	}

	inline function contains(x:Int, y:Int):Bool {
		return x + Std.int(y / 2) >= 0 && x + Std.int(y / 2) < width && y >= 0 && y < height;
	}

	function cells():Iterator<Coordinates> {
		return new GridIterator(width, height);
	}

	function get_size():Int {
		return width * height;
	}

	inline function distanceBetween(p1:Coordinates, p2:Coordinates):Int {
		return Std.int((abs(p1.x - p2.x) + abs(p1.x + p1.y - p2.x - p2.y) + abs(p1.y - p2.y)) / 2);
	}

	function areNeighbors(p1:Coordinates, p2:Coordinates):Bool {
		return distanceBetween(p1, p2) <= 1;
	}

	inline function neighborsOf(p:Coordinates):CoordinatesNeighbors {
		return new CoordinatesNeighbors(this, p);
	}

	function nodeIndex(node:Coordinates):Int {
		return node.x + node.y * width;
	}
}
