/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package;

import openfl.display.Sprite;

class SampleMap implements graph.Pathfindable
{
	public var width:Int;
	public var height:Int;

	public function new(width:Int, height:Int)
	{
		this.width = width;
		this.height = height;
	}

	public function neighborsOf(p:graph.Position):Array<graph.Position>
	{
		var neighbors = [];
		for (dy in -1...2)
		{
			for (dx in -1...2)
			{
				if (p.x + dx >= 0 && p.x + dx < width && p.y + dy >= 0 && p.y + dy < height)
				{
					neighbors.push(new graph.Position(p.x + dx, p.y + dy));
				}
			}
		}
		return neighbors;
	}

	public function distanceBetween(p1:graph.Position, p2:graph.Position):Int
	{
		var dx = p1.x > p2.x ? p1.x - p2.x : p2.x - p1.x;
		var dy = p1.y > p2.y ? p1.y - p2.y : p2.y - p1.y;
		return dx + dy;
	}
}

class Main extends Sprite
{
	static var TILE_SIZE = 32;
	static var SQUARE_SIZE = 10;

	public function new()
	{
		super();
		graphics.beginFill(0x000000);
		graphics.drawRect(0, 0, SQUARE_SIZE * TILE_SIZE, SQUARE_SIZE * TILE_SIZE);
		graphics.endFill();

		trace(new hex.Hexagon(new openfl.geom.Point(0, 0), 5).corners);

		var path = graph.Path.between(new graph.Position(0, 0), new graph.Position(9, 5), new SampleMap(10, 10));

		graphics.beginFill(0xffffff);
		for (step in path)
		{
			graphics.drawRect(step.x * TILE_SIZE, step.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
		}
		graphics.endFill();
	}
}
