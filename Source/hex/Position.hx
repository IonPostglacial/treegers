/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package hex;

class Position implements graph.Step<Position>
{
	public var x(default, null):Int;
	public var y(default, null):Int;

	public function new(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}

	public function equals(other:Position):Bool
	{
		return this.x == other.x && this.y == other.y;
	}

	public inline function hashCode():Int
	{
		return x + 31 * y;
	}
}
