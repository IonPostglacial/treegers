/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package game.components;

import grid.Coordinates;
import grid.TilesCoord;


@:publicFields
class Position {
	var x:TilesCoord;
	var y:TilesCoord;

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
