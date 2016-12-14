package geometry;

class OrthogonalCoordinates implements ICoordinatesSystem {
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

	public function fromPixel(pointX:Float, pointY:Float):Coordinates {
		return new Coordinates(Std.int(pointX  * widthRatio), Std.int(pointY * heightRatio));
	}

	public function toPixel(coordX:Int, coordY:Int):Vector2D {
		return new Vector2D(coordX  * width, coordY * height);
	}
}
