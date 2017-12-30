package grid;


@:generic interface ICoordinateSystem {
	function fromPixel(pixelX:Pixel, pixelY:Pixel):Coordinates;
	function toPixel(coordX:Int, coordY:Int):Vector2D;
}
