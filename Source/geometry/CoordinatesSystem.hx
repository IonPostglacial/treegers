package geometry;

import openfl.geom.Point;


interface CoordinatesSystem {
	function fromPixel(point:Point):Coordinates;
	function toPixel(point:Coordinates):Point;
}
