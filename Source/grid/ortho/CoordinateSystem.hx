package grid.ortho;


class CoordinateSystem implements ICoordinateSystem {
	var width:Float = 1;
	var height:Float = 1;
	var widthRatio:Float = 1;
	var heightRatio:Float = 1;

	public function new(width, height) {
		this.width = width;
		this.height = height;
		this.widthRatio = 1 / width;
		this.heightRatio = 1 / height;
	}

	public function fromPixel(pointX:Pixel, pointY:Pixel):Coordinates {
		return new Coordinates(Std.int(pointX.toFloat()  * widthRatio), Std.int(pointY.toFloat() * heightRatio));
	}

	public function toPixel(coordX:TilesCoord, coordY:TilesCoord):Vector2D {
		return new Vector2D(coordX.toInt()  * width, coordY.toInt() * height);
	}
}
