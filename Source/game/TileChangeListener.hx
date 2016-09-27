package game;

import game.components.Position;


interface TileChangeListener {
	function tileChanged(position:Position, oldType:TileType, newType:TileType):Void;
}
