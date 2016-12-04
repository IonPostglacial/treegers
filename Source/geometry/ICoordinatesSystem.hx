package geometry;


@:generic interface ICoordinatesSystem {
	function fromPixel(point:Vector2D):Coordinates;
	function toPixel(point:Coordinates):Vector2D;
}
