/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package hex;

import graph.Path.Node;

class Position implements Node<Position>
{
	public var x(default, null):Int;
	public var y(default, null):Int;

	public function new(x, y)
	{
		this.x = x;
		this.y = y;
	}

	public function equals(other):Bool
	{
		return this.x == other.x && this.y == other.y;
	}

	public function assign(other:Position)
	{
		this.x = other.x;
		this.y = other.y;
	}

	public inline function hashCode():Int
	{
		return x + 31 * y;
	}
}
