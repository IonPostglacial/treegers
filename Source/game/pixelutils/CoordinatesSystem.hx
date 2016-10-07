package game.pixelutils;

import openfl.geom.Point;
import game.components.Position;


interface CoordinatesSystem {
	function pointToPosition(point:Point):Position;
	function positionToPoint(point:Position):Point;
}
