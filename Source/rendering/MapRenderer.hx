package rendering;

import openfl.Assets;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;

import geometry.Coordinates;
import geometry.Map2D;
import geometry.HexagonalMap;
import geometry.OrthogonalMap;

import tmx.TiledMap;


class MapRenderer extends Tilemap {
	var map:TiledMap;

	public function new(map:TiledMap) {
		this.map = map;
		tileset = new Tileset(map.tilesets[0].image);
		super(openfl.Lib.current.stage.stageWidth, openfl.Lib.current.stage.stageHeight, tileset);
		allocateIds(map);
		populateMap(map);
	}

	inline function populateMap(map:TiledMap) {
		var baseLayer = map.tileLayers[0];
		for (position in baseLayer.tiles.keys()) {
			this.setTileTypeAt(position, baseLayer.tiles.get(position));
		}
	}

	inline function allocateIds(map:TiledMap) {
		var rectWidth = map.tilesets[0].tileWidth;
		var rectHeight = map.tilesets[0].tileHeight;
		var i = 0;
		for (tileType in 0...map.tilesets[0].tileCount) {
			tileset.addRect(new Rectangle(rectWidth * i, 0, rectWidth, rectHeight));
			i += 1;
		}
	}

	public inline function createTileAt(type:Int, x:Float, y:Float):Tile {
		var tile = new Tile(type - map.tilesets[0].firstGid, 0, 0);
		moveTile(tile, x, y);
		this.addTile(tile);
		return tile;
	}

	public function setTileTypeAt(position:Coordinates, type:Int) {
		var oldTile = this.getTileAt(this.map.tileLayers[0].tiles.indexOf(position.x, position.y));
		var index = -1;
		if (oldTile != null) {
			index = this.getTileIndex(oldTile);
			this.removeTile(oldTile);
		}
		var pixPosition = map.coordinates.toPixel(position);
		var newTile = new Tile(type - map.tilesets[0].firstGid, 0, 0);
		moveTile(newTile, pixPosition.x, pixPosition.y);
		if (index >= 0) {
			this.addTileAt(newTile, index);
		} else {
			this.addTile(newTile);
		}
	}

	public inline function moveTile(tile:Tile, x:Float, y:Float) {
		var tileset = map.tilesets[0];
		tile.x = x;
		tile.y = y;
	}
}
