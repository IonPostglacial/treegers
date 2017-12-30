package grid.hex;


class CoordinateSystem implements ICoordinateSystem {
	var hexWidth:Float;
	var effectiveHeight:Float;
	var effectiveHeightRatio:Float;

	public function new(hexWidth, hexHeight, radius) {
		this.hexWidth = hexWidth;
		this.effectiveHeight = 0.75 * hexHeight;
		this.effectiveHeightRatio = 1 / this.effectiveHeight;
	}

	public function fromPixel(pointX:Pixel, pointY:Pixel):Coordinates {
		var realHeight = (pointY  * effectiveHeightRatio).toFloat();
		var y = Math.floor(realHeight);
		var x = Math.floor((pointX.toFloat() / hexWidth) - y / 2);

		return new Coordinates(x, y);
	}

	public function toPixel(coordX:TilesCoord, coordY:TilesCoord):Vector2D {
		var x = Math.floor(coordX.toInt() * hexWidth + coordY.toInt() * hexWidth / 2);
		var y = Math.floor(effectiveHeight * coordY.toInt());

		return new Vector2D(x, y);
	}
}
