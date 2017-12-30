package grid;


@:generic interface ICoordinateSystem {
	function fromPixel(pixelX:Pixel, pixelY:Pixel):Coordinates;
	function toPixel(coordX:TilesCoord, coordY:TilesCoord):Vector2D;
}
