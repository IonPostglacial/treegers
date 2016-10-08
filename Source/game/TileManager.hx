package game;

import openfl.Assets;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;

import game.components.Position;
import game.pixelutils.Shape;
import game.geometry.HexagonalMap;


class TileManager {
	var tilesTypeToTilesId:Array<Int> = [];
	var tiles:HexagonalMap<Tile>;

	var stage:Stage;
	var tilemap:Tilemap;
	var tileset:Tileset;

	public function new(stage:Stage) {
		var imgAsset = Assets.getBitmapData("assets/tileset.png");
		this.stage = stage;
		tileset = new Tileset(imgAsset);
		tilemap = new Tilemap(openfl.Lib.current.stage.stageWidth, openfl.Lib.current.stage.stageHeight, tileset);
		tiles = new HexagonalMap<Tile>(stage.map.width, stage.map.height);
		allocateIds(stage);
		populateMap(stage);
	}

	inline function populateMap(stage:Stage) {
		for (position in stage.map.cells()) {
			this.setTileTypeAt(position, stage.map.get(position));
		}
	}

	inline function allocateIds(stage:Stage) {
		var hexagonWidth = Math.sqrt(3) * stage.hexagonRadius;
		var i = 0;
		for (tileType in 0...TileType.Last) {
			tilesTypeToTilesId.push(tileset.addRect(new openfl.geom.Rectangle(hexagonWidth * i, 0, 55, 64)));
			i += 1;
		}
		stage.background.addChild(tilemap);
	}

	public inline function createTileAt(type:TileType, x:Float, y:Float):Tile {
		var tile = new Tile(tilesTypeToTilesId[type], 0, 0);
		moveTile(tile, x, y);
		tilemap.addTile(tile);
		return tile;
	}

	public function setTileTypeAt(position:Position, type:TileType) {
		var oldTile = tiles.get(position);
		var index = -1;
		if (oldTile != null) {
			index = tilemap.getTileIndex(oldTile);
			tilemap.removeTile(oldTile);
		}
		var pixPosition = stage.coords.positionToPoint(position);
		var newTile = new Tile(tilesTypeToTilesId[type], 0, 0);
		moveTile(newTile, pixPosition.x, pixPosition.y);
		tiles.set(position, newTile);
		if (index >= 0) {
			tilemap.addTileAt(newTile, index);
		} else {
			tilemap.addTile(newTile);
		}
	}

	public static inline function moveTile(tile:Tile, x:Float, y:Float) {
		tile.x = x - 28;
		tile.y = y - 32;
	}

	public inline function removeTile(tile:Tile) {
		tilemap.removeTile(tile);
	}
}
