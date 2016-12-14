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

	public function fromPixel(pointX:Float, pointY:Float):Coordinates {
		var y = Math.floor(pointY  * effectiveHeightRatio);
		var x = Math.floor((pointX / hexWidth) - y / 2);

		return new Coordinates(x, y);
	}

	public function toPixel(coordX:Int, coordY:Int):Vector2D {
		var x = Math.floor(coordX * hexWidth + coordY * hexWidth / 2);
		var y = Math.floor(effectiveHeight * coordY);

		return new Vector2D(x, y);
	}
}
