package geometry;

import openfl.geom.Point;


class HexagonalCoordinates implements CoordinatesSystem {
	static var SQRT3 = Math.sqrt(3);

	var hexWidth:Float;
	var effectiveHeight:Float;
	var effectiveHeightRatio:Float;

	public function new(hexWidth, hexHeight, radius) {
		this.hexWidth = hexWidth;
		this.effectiveHeight = 0.75 * hexHeight;
		this.effectiveHeightRatio = 1 / this.effectiveHeight;
	}

	public function fromPixel(point:Point):Coordinates {
		var y = Math.floor(point.y  * effectiveHeightRatio);
		var x = Math.floor((point.x / hexWidth) - y / 2);

		return new Coordinates(x, y);
	}

	public function toPixel(coordinates:Coordinates):Point {
		var x = coordinates.x * hexWidth + coordinates.y * hexWidth / 2;
		var y = effectiveHeight * coordinates.y;

		return new Point(x, y);
	}
}
