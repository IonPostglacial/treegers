package game.map;

interface ITileObjectListener {
	function tileObjectStatusChanged(tileObject:tmx.TileObject, active:Bool):Void;
}
