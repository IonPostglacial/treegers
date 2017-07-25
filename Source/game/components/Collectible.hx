package game.components;


@:publicFields
class Collectible {
	var components:Iterable<Dynamic> = [];
	var effectDuration:Null<Float> = null;
	var collected:Bool = false;
	var expires:Bool = false;

	function new() {}
}
