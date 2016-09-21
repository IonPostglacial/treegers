package game.components;

import haxe.ds.Vector;
import hex.Position;

class Button {
	var alternatingTileTypes:Array<Tile.Type>;

	public var isPressed(default,null):Bool = false;
	public var triggered(default,default):Bool = false;
	public var isToggle(default,null):Bool;
	public var affectedTiles(default,null):Array<Position>;
	public var currentTileType(get,never):Tile.Type;

	public function new(isToggle, affectedTiles, upTileTiles, pushedTileType) {
		this.isToggle = isToggle;
		this.affectedTiles = affectedTiles;
		this.alternatingTileTypes = [upTileTiles, pushedTileType];
	}

	public function get_currentTileType():Tile.Type {
		return alternatingTileTypes[triggered ? 1 : 0];
	}

	public function flip() {
		isPressed = !isPressed;
		if (isToggle || isPressed) {
			triggered = !triggered;
		}
	}
}
