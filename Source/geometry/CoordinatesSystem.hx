package geometry;


@:generic interface CoordinatesSystem {
	function fromPixel(point:Vector2D):Coordinates;
	function toPixel(point:Coordinates):Vector2D;
}
