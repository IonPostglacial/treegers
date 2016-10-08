package game;

import geometry.Coordinates;


interface TileChangeListener {
	function tileChanged(position:Coordinates, oldType:TileType, newType:TileType):Void;
}
