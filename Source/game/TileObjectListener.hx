package game;

interface TileObjectListener {
	function tileObjectStatusChanged(tileObject:tmx.TileObject, active:Bool):Void;
}
