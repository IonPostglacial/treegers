package game.components;

import game.map.GroundType;


@:publicFields
class ObjectChanger {
	var affectedTypes:Array<GroundType> = [];
	var loadTime:Float = 1.0;
	var elapsedLoadTime:Float = 0;
	var range:Int = 1;

	function new() {}
}
