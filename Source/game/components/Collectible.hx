package game.components;

import haxe.ds.Option;

class Collectible {
	public var components:Iterable<Dynamic>;
	public var effectDuration:Option<Float>;
	public var collected:Bool = false;
	public var expires(get,never):Bool;

	public function new(components, ?effectDuration) {
		this.components = components;
		if (effectDuration != null) {
			this.effectDuration = Some(effectDuration);
		} else {
			this.effectDuration = None;
		}
	}

	public function get_expires():Bool {
		return effectDuration != None;
	}
}
