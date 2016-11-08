package game.components;

import haxe.ds.Vector;


class Button {
	public var isPressed(default,null):Bool = false;
	public var triggered(default,default):Bool = false;
	public var isToggle(default,null):Bool;
	public var affectedTiles(default,null):Array<tmx.TileObject>;

	public function new(isToggle, affectedTiles, upTileTiles, pushedTileType) {
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
