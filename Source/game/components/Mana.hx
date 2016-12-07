package game.components;

import game.mapmanagement.GroundType;


class Mana implements IGaugeableComponent {
	public var affectedTypes:Array<GroundType> = [];
	public var level:Float = 100;
	public var max:Float = 100;
	public var recovery:Float = 100.0;
	public var loadTime:Float = 1.0;
	public var elapsedLoadTime:Float = 0;
	public var range:Int = 1;
	public var targets:Array<Int> = [];
	public var changedThisRound:Bool = false;

	public function new() {}
}
