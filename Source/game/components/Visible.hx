package game.components;

import haxe.ds.Vector;

import openfl.display.Sprite;
import openfl.display.Tile;


class Visible {
	public var tileType:TileType;
	public var sprite(default, null):Sprite;
	public var tile:Null<Tile>;

	public function new(tileType) {
		this.sprite = new Sprite();
		this.tileType = tileType;
	}
}
