/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;

class Main extends Sprite
{
	var grid = new hex.Grid(14, 11, 32);
	var start = new hex.Position(0, 0);
	var goal = new hex.Position(3, 6);
	var overlay = new openfl.display.Sprite();

	function drawBackground()
	{
		graphics.beginFill(0xbd7207);
		graphics.drawRect(0, 0, 800, 600);
		graphics.endFill();

		graphics.lineStyle(2, 0xffa200);
		drawing.Shape.hexagonGrid(graphics, grid);
	}

	function drawPath(path:Iterable<hex.Position>)
	{
		overlay.graphics.clear();
		overlay.graphics.beginFill(0xffcb40);
		for (point in path)
		{
			drawing.Shape.hexagon(overlay.graphics, new hex.Hexagon(drawing.Shape.positionToPoint(point, grid.radius), grid.radius));
		}
		overlay.graphics.endFill();
	}

	public function new()
	{
		super();
		addChild(overlay);

		drawBackground();

		var path = graph.Path.find(grid, start, goal);
		drawPath(path);

		addEventListener(MouseEvent.MOUSE_MOVE, function(e)
		{
			var mousePosition = drawing.Shape.pointToPosition(new openfl.geom.Point(e.localX, e.localY), grid.radius);
			if (mousePosition.equals(goal))
				return;
			goal = mousePosition;
			path = graph.Path.find(grid, start, goal);
			drawPath(path);
		});
	}
}
