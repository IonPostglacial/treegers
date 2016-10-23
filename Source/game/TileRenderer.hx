package game;

import openfl.Assets;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;

import drawing.Shape;
import geometry.Coordinates;
import geometry.HexagonalMap;

import tmx.TiledMap;


class TileRenderer extends Tilemap {
	var tilesTypeToTilesId:Array<Int> = [];
	var tiles:HexagonalMap<Tile>;
	var map:TiledMap;

	public function new(map:TiledMap) {
		this.map = map;
		tileset = new Tileset(map.tilesets[0].image);
		super(openfl.Lib.current.stage.stageWidth, openfl.Lib.current.stage.stageHeight, tileset);
		tiles = new HexagonalMap<Tile>(map.width, map.height);
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
		var hexagonWidth = Math.sqrt(3) * map.hexSideLength;
		var i = 0;
		for (tileType in 0...TileType.Last) {
			tilesTypeToTilesId.push(tileset.addRect(new Rectangle(hexagonWidth * (i - 1), 0,
				map.tilesets[0].tileWidth, map.tilesets[0].tileHeight)));
			i += 1;
		}
	}

	public inline function createTileAt(type:TileType, x:Float, y:Float):Tile {
		var tile = new Tile(tilesTypeToTilesId[type], 0, 0);
		moveTile(tile, x, y);
		this.addTile(tile);
		return tile;
	}

	public function setTileTypeAt(position:Coordinates, type:TileType) {
		var oldTile = tiles.get(position);
		var index = -1;
		if (oldTile != null) {
			index = this.getTileIndex(oldTile);
			this.removeTile(oldTile);
		}
		var pixPosition = map.coordinates.toPixel(position);
		var newTile = new Tile(tilesTypeToTilesId[type], 0, 0);
		moveTile(newTile, pixPosition.x, pixPosition.y);
		tiles.set(position, newTile);
		if (index >= 0) {
			this.addTileAt(newTile, index);
		} else {
			this.addTile(newTile);
		}
	}

	public inline function moveTile(tile:Tile, x:Float, y:Float) {
		var tileset = map.tilesets[0];
		tile.x = x - 0.5 * tileset.tileWidth;
		tile.y = y - 0.5 * tileset.tileHeight;
	}
}
