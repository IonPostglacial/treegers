/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package game.geometry;

import graph.Pathfindable;
import game.components.Position;


class HexagonalGrid implements Pathfindable<Position> {
	static var deltas = [-1, 0, -1, 1, 0, -1, 0, 1, 1, -1, 1, 0];

	public var width(default, null):Int;
	public var height(default, null):Int;
	public var radius(default, null):Int;
	public var cellsNumber(get, never):Int;

	public function new(width, height, radius) {
		this.width = width;
		this.height = height;
		this.radius = radius;
	}

	public function get_cellsNumber():Int {
		return Std.int((height + 1) / 2) * width + Std.int(height / 2) * (width - 1);
	}

	public function iterator() {
		return new HexagonalGridIterator(width, height);
	}

	public function contains(x:Int, y:Int):Bool {
		return x + Std.int(y / 2) >= 0 && x + Std.int(y / 2) < width && y >= 0 && y < height;
	}

	static function abs(n:Int):Int {
		return n >= 0 ? n : -n;
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
