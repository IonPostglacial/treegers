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
			var pixPosition = map.coordinates.toPixel(position);
			var tileId = baseLayer.tiles.get(position) - map.tilesets[0].firstGid;
			this.addTile(new Tile(tileId, pixPosition.x, pixPosition.y));
		}
	}

	inline function allocateIds(map:TiledMap) {
		for (mapTileset in map.tilesets) {
			var rectWidth = mapTileset.tileWidth;
			var rectHeight = mapTileset.tileHeight;
			var i = 0;
			for (tileType in 0...mapTileset.tileCount) {
				tileset.addRect(new Rectangle(rectWidth * i, 0, rectWidth, rectHeight));
				i += 1;
			}
		}
	}

	public inline function createObjectTile(type:Int, x:Float, y:Float):Tile {
		var tile = new Tile(type - map.tilesets[0].firstGid, x, y);
		this.addTile(tile);
		return tile;
	}

	public inline function getTileFromCoords(layerId:Int, position:Coordinates):Tile {
		var tileIndex = 0;
		for (layerIndex in 0...layerId) {
			tileIndex += this.map.tileLayers[layerId].tiles.size;
		}
		tileIndex += this.map.tileLayers[layerId].tiles.indexOf(position.x, position.y);
		return this.getTileAt(tileIndex);
	}

	public inline function setTileTypeAt(layerId:Int, position:Coordinates, type:Int) {
		var tile = this.getTileFromCoords(layerId, position);
		tile.id = type - map.tilesets[0].firstGid;
	}
}
