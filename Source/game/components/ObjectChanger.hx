package game.components;

import game.map.GroundType;
import grid.TilesDelta;


@:publicFields
class ObjectChanger {
	var affectedTypes:Array<GroundType> = [];
	var loadTime:Float = 1.0;
	var elapsedLoadTime:Float = 0;
	var range:TilesDelta = new TilesDelta(1);

	function new() {}
}
