package geometry;

class OrthogonalCoordinates implements CoordinatesSystem {
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

	public function fromPixel(point:Vector2D):Coordinates {
		return new Coordinates(Std.int(point.x  * widthRatio), Std.int(point.y * heightRatio));
	}

	public function toPixel(coordinates:Coordinates):Vector2D {
		return new Vector2D(coordinates.x  * width, coordinates.y * height);
	}
}
