package game;

import game.components.Position;


interface TileChangeListener {
	function tileChanged(position:Position, oldType:Tile.Type, newType:Tile.Type):Void;
}
