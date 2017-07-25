package game.components;


@:publicFields
class Mana implements IGaugeableComponent {
	var level:Float = 100;
	var max:Float = 100;
	var recovery:Float = 100.0;
	var changedThisRound:Bool = false;

	function new() {}
}
