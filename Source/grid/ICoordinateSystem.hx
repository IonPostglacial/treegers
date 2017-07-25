package grid;


@:generic interface ICoordinateSystem {
	function fromPixel(pixelX:Float, pixelY:Float):Coordinates;
	function toPixel(coordX:Int, coordY:Int):Vector2D;
}
