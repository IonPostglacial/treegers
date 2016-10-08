/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package game.components;


class Position extends geometry.Coordinates {
	public inline function new(x, y) {
		super(x, y);
	}

	public inline function fromCoordinates(coords:geometry.Coordinates) {
		return new Position(coords.x, coords.y);
	}
}
