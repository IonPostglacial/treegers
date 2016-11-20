package game.mapmanagement;

interface TileObjectListener {
	function tileObjectStatusChanged(tileObject:tmx.TileObject, active:Bool):Void;
}
