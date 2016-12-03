package game.components;

class Health implements GaugeableComponent {
	public var level:Float = 100;
	public var max:Float = 100;
	public var armor:Float = 2;
	public var changedThisRound:Bool = false;

	public function new() {}
}
