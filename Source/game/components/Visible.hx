package game.components;

import haxe.ds.Vector;

import openfl.display.Sprite;
import openfl.display.Tile;


class Visible {
	public var objectId:Int;
	public var sprite(default, null):Sprite;
	public var tile:Null<Tile>;

	public function new(objectId:Int) {
		this.sprite = new Sprite();
		this.objectId = objectId;
	}
}
