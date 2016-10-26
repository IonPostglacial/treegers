package geometry;

import openfl.geom.Point;


class HexagonalCoordinates implements CoordinatesSystem {
	static var SQRT3 = Math.sqrt(3);

	var radius:Float = 0;
	var hexWidth:Float;
	var hexHeight:Float;

	public function new(hexWidth, hexHeight, radius) {
		this.hexWidth = hexWidth;
		this.hexHeight = hexHeight;
		this.radius = radius;
	}

	public function fromPixel(point:Point):Coordinates {
		var y = Math.floor(point.y / (0.75 * hexHeight));
		var x = Math.floor((point.x / hexWidth) - 0.5 * y);

		return new Coordinates(x, y);
	}

	public function toPixel(coordinates:Coordinates):Point {
		var x = coordinates.x * hexWidth + coordinates.y * 0.5 * hexWidth;
		var y = 0.75 * hexHeight * coordinates.y;

		return new Point(x, y);
	}
}
