package geometry;

class HexagonalCoordinates implements ICoordinatesSystem {
	var hexWidth:Float;
	var effectiveHeight:Float;
	var effectiveHeightRatio:Float;

	public function new(hexWidth, hexHeight, radius) {
		this.hexWidth = hexWidth;
		this.effectiveHeight = 0.75 * hexHeight;
		this.effectiveHeightRatio = 1 / this.effectiveHeight;
	}

	public function fromPixel(point:Vector2D):Coordinates {
		var y = Math.floor(point.y  * effectiveHeightRatio);
		var x = Math.floor((point.x / hexWidth) - y / 2);

		return new Coordinates(x, y);
	}

	public function toPixel(coordinates:Coordinates):Vector2D {
		var x = Math.floor(coordinates.x * hexWidth + coordinates.y * hexWidth / 2);
		var y = Math.floor(effectiveHeight * coordinates.y);

		return new Vector2D(x, y);
	}
}
