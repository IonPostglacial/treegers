package game.components;

import haxe.ds.Vector;


class Button {
	public var isPressed:Bool = false;
	public var triggered:Bool = false;
	public var isToggle:Bool;
	public var affectedTiles:Iterable<tmx.TileObject>;

	public function new(isToggle, affectedTiles) {
		this.isToggle = isToggle;
		this.affectedTiles = affectedTiles;
	}

	public function flip() {
		isPressed = !isPressed;
		if (isToggle || isPressed) {
			triggered = !triggered;
		}
	}
}
