/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package game.components;

import grid.Coordinates;


@:publicFields
class Position {
	var x:Int;
	var y:Int;

	inline function new(x, y) {
		this.x = x;
		this.y = y;
	}

	inline function equals(other:Position):Bool {
		return this.x == other.x && this.y == other.y;
	}

	inline function coords():Coordinates {
		return new Coordinates(x, y);
	}
}
