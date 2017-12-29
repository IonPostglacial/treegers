package game.components;

import openfl.display.Sprite;
import openfl.display.Tile;


@:publicFields
class Visible {
	var objectId:Int;
	var sprite(default, null) = new Sprite();
	var tile:Null<Tile> = null;

	function new(objectId:Int) {
		this.objectId = objectId;
	}
}
