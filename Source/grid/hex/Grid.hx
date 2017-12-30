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
		var p1x = p1.x.toInt(), p1y = p1.y.toInt(), p2x = p2.x.toInt(), p2y = p2.y.toInt();
		return Std.int((abs(p1x - p2x) + abs(p1x + p1y - p2x - p2y) + abs(p1y - p2y)) / 2);
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
