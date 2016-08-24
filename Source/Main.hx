/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package;

import openfl.display.Sprite;

class Main extends Sprite
{
	static var TILE_SIZE = 32;

	public function new()
	{
		super();
		graphics.beginFill(0xbd7207);
		graphics.drawRect(0, 0, 800, 600);
		graphics.endFill();

		var grid = new hex.Grid(14, 11, TILE_SIZE);
		var path = graph.Path.find(grid, new hex.Position(0, 0), new hex.Position(3, 6));

		graphics.lineStyle(2, 0xffa200);
		drawing.Shape.hexagonGrid(graphics, grid);

		graphics.beginFill(0xffcb40);
		for (step in path)
		{
			drawing.Shape.hexagon(graphics, new hex.Hexagon(drawing.Shape.positionToPoint(step, TILE_SIZE), TILE_SIZE));
		}
		graphics.endFill();
	}
}
