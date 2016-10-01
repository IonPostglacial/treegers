package game.geometry;

import graph.Pathfindable;
import game.components.Position;


class HexagonalGrid implements Pathfindable<Position> {
	static var deltas = [-1, 0, -1, 1, 0, -1, 0, 1, 1, -1, 1, 0];

	public var width:Int;
	public var height:Int;
	public var size(get, never):Int;

	public function new(width, height) {
		this.width = width;
		this.height = height;
	}

	static function abs(n:Int):Int {
		return n >= 0 ? n : -n;
	}

	public inline function indexOf(x:Int, y:Int):Int {
		return x + Std.int(y/2) + width * y;
	}

	public inline function contains(x:Int, y:Int):Bool {
		return x + Std.int(y / 2) >= 0 && x + Std.int(y / 2) < width && y >= 0 && y < height;
	}

	public function cells() {
		return new HexagonalGridIterator(width, height);
	}

	public function get_size():Int {
		return width * height;
	}

	public inline function distanceBetween(p1:Position, p2:Position):Int {
		return Std.int((abs(p1.x - p2.x) + abs(p1.x + p1.y - p2.x - p2.y) + abs(p1.y - p2.y)) / 2);
	}

	public inline function neighborsOf(p:Position):Array<Position> {
		var neighbors:Array<Position> = [];
		for (i in 0...6) {
			var x = p.x + deltas[2 * i];
			var y = p.y + deltas[2 * i + 1];
			if (contains(x, y)) {
				neighbors.push(new Position(x, y));
			}
		}
		return neighbors;
	}
}
