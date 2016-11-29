package game.components;


class Collectible {
	public var components:Iterable<Dynamic>;
	public var effectDuration:Null<Float>;
	public var collected:Bool = false;
	public var expires(get,never):Bool;

	public function new(components, ?effectDuration) {
		this.components = components;
		this.effectDuration = effectDuration;
	}

	public function get_expires():Bool {
		return effectDuration != null;
	}
}
