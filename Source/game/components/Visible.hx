package game.components;

import haxe.ds.Vector;

import openfl.display.Sprite;
import openfl.display.Tile;


class Visible {
	public var objectId:Int;
	public var sprite(default, null) = new Sprite();
	public var tile:Null<Tile> = null;

	public function new(objectId:Int) {
		this.objectId = objectId;
	}
}
