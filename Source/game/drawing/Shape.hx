package game.drawing;

import game.components.Position;
import game.geometry.Hexagon;
import game.geometry.HexagonalGrid;
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

	public static inline function gridPixelWidth(grid:HexagonalGrid):Int {
		return Std.int(SQRT3 * grid.width * grid.radius);
	}

	public static inline function gridPixelHeight(grid:HexagonalGrid):Int {
		return Std.int((1.5 * grid.height + 0.5) * grid.radius);
	}

	public static function hexagon(graphics:Graphics, hexagon:Hexagon) {
		var corners = hexagon.corners;

		graphics.moveTo(corners[5].x, corners[5].y);
		for (corner in corners) {
			graphics.lineTo(corner.x, corner.y);
		}
	}

	public static function hexagonGrid(graphics:Graphics, grid:HexagonalGrid) {
		for (position in grid.positions) {
			var center = positionToPoint(position, grid.radius);
			hexagon(graphics, new Hexagon(center.x, center.y, grid.radius));
		}
	}
}
