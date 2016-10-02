package game;

import openfl.Assets;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.Lib;

import game.components.Position;
import game.drawing.Shape;
import game.geometry.HexagonalMap;


class TileManager {
	var tilesTypeToTilesId:Array<Int> = [];
	var tiles:HexagonalMap<Tile>;

	var tileRadius:Float;
	var tilemap:Tilemap;
	var tileset:Tileset;

	public function new(stage:Stage) {
		var imgAsset = Assets.getBitmapData("assets/tileset.png");
		tileRadius = stage.hexagonRadius;
		tileset = new Tileset(imgAsset);
		tilemap = new Tilemap(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, tileset);
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
		openfl.Lib.current.addChild(tilemap);
	}

	public inline function createTileAt(type:TileType, x:Float, y:Float):Tile {
		var tile = new Tile(tilesTypeToTilesId[type], 0, 0);
		moveTile(tile, x, y);
		tilemap.addTile(tile);
		return tile;
	}

	public function setTileTypeAt(position:Position, type:TileType) {
		var oldTile = tiles.get(position);
		if (oldTile != null) {
			tilemap.removeTile(oldTile);
		}
		var pixPosition = Shape.positionToPoint(position, tileRadius);
		var newTile = new Tile(tilesTypeToTilesId[type], 0, 0);
		moveTile(newTile, pixPosition.x, pixPosition.y);
		tiles.set(position, newTile);
		tilemap.addTile(newTile);
	}

	public static inline function moveTile(tile:Tile, x:Float, y:Float) {
		tile.x = x - 28;
		tile.y = y - 32;
	}

	public inline function removeTile(tile:Tile) {
		tilemap.removeTile(tile);
	}
}
