/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package hex;

class Position {
	public var x(default, null):Int;
	public var y(default, null):Int;

	public inline function new(x, y) {
		this.x = x;
		this.y = y;
	}

	public inline function equals(other):Bool {
		return this.x == other.x && this.y == other.y;
	}

	public inline function assign(other:Position) {
		this.x = other.x;
		this.y = other.y;
	}

	public inline function hashCode():Int {
		return x + 31 * y;
	}
}
