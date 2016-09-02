package drawing;

import hex.Hexagon;
import hex.Position;
import openfl.display.Graphics;
import openfl.geom.Point;

class Shape {
	static var SQRT3 = Math.sqrt(3);

	public static inline function pointToPosition(point:Point, radius:Float):Position {
		var WIDTH_NUM = Std.int(point.x / (SQRT3 * radius / 2));
		var HEIGHT_NUM = Std.int(point.y / (radius / 2));
		var HEX_Y = Std.int(HEIGHT_NUM / 3);
		var HEX_X = Std.int((WIDTH_NUM - HEX_Y) / 2);

		return new Position(HEX_X, HEX_Y);
	}

	public static inline function positionToPoint(point:Position, radius:Float):Point {
		var PIX_Y = radius + 1.5 * radius * point.y;
		var PIX_X = (PIX_Y - radius) / SQRT3 + SQRT3 * radius * (point.x + 0.5);

		return new Point(PIX_X, PIX_Y);
	}

	public static function hexagon(graphics:Graphics, hexagon:Hexagon) {
		var corners = hexagon.corners;

		graphics.moveTo(corners[5].x, corners[5].y);
		for (corner in corners) {
			graphics.lineTo(corner.x, corner.y);
		}
	}

	public static function hexagonGrid(graphics:Graphics, grid:hex.Grid) {
		var HEX_WIDTH = SQRT3 * grid.radius;
		var HEX_HEIGHT = 2 * grid.radius;
		var LAST_Y = (1.5 * grid.height + 1) * grid.radius;
		var y = 0.5 * grid.radius;

		while (y < LAST_Y) {
			for (i in 0...grid.width) {
				var x = i * HEX_WIDTH;

				graphics.moveTo(x, y + grid.radius);
				graphics.lineTo(x, y);
				graphics.lineTo(x + 0.5 * HEX_WIDTH, y - 0.5 * grid.radius);
				graphics.lineTo(x + HEX_WIDTH, y);
				graphics.moveTo(x, y + grid.radius);
				graphics.lineTo(x + 0.5 * HEX_WIDTH, y + 1.5 * grid.radius);
				if (y < LAST_Y - 1.5 * HEX_HEIGHT) {
					graphics.lineTo(x + 0.5 * HEX_WIDTH, y + 2.5 * grid.radius);
					graphics.moveTo(x + 0.5 * HEX_WIDTH, y + 1.5 * grid.radius);
				}
				graphics.lineTo(x + HEX_WIDTH, y + grid.radius);
			}
			graphics.lineTo(HEX_WIDTH * grid.width, y);
			y += 1.5 * HEX_HEIGHT;
		}
	}
}
