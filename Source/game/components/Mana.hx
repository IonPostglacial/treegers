package game.components;

class Mana implements IGaugeableComponent {
	public var level:Float = 100;
	public var max:Float = 100;
	public var recovery:Float = 100.0;
	public var changedThisRound:Bool = false;

	public function new() {}
}
