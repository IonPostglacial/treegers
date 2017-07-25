package game.components;


@:publicFields
class Health implements IGaugeableComponent {
	var level:Float = 100;
	var max:Float = 100;
	var armor:Float = 2;
	var changedThisRound:Bool = false;

	function new() {}
}
