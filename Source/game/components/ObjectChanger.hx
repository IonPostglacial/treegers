package game.components;

import game.map.GroundType;


class ObjectChanger {
	public var affectedTypes:Array<GroundType> = [];
	public var loadTime:Float = 1.0;
	public var elapsedLoadTime:Float = 0;
	public var range:Int = 1;

	public function new() {}
}
