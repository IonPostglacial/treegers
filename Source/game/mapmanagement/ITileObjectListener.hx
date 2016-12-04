package game.mapmanagement;

interface ITileObjectListener {
	function tileObjectStatusChanged(tileObject:tmx.TileObject, active:Bool):Void;
}
