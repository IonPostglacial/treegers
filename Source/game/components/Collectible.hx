package game.components;


class Collectible {
	public var components:Iterable<Dynamic> = [];
	public var effectDuration:Null<Float> = null;
	public var collected:Bool = false;
	public var expires(get,never):Bool;

	public function new() {}

	public function get_expires():Bool {
		return effectDuration != null;
	}
}
