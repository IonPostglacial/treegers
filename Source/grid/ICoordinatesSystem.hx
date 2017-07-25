package grid;


@:generic interface ICoordinatesSystem {
	function fromPixel(pixelX:Float, pixelY:Float):Coordinates;
	function toPixel(coordX:Int, coordY:Int):Vector2D;
}
