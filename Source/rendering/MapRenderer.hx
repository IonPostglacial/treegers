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
	var tilesByObjectsId:Map<Int, Tile> = new Map();

	public function new(map:TiledMap) {
		this.map = map;
		tileset = new Tileset(map.tilesets[0].image);
		super(map.effectiveTileWidth * map.width, map.effectiveTileHeight * map.height, tileset);
		loadTilesets(map);
		loadTileLayer(map);
		loadObjectsLayer(map);
	}

	inline function loadTileLayer(map:TiledMap) {
		var baseLayer = map.tileLayers[0];
		for (position in baseLayer.tiles.keys()) {
			var pixPosition = map.coordinates.toPixel(position);
			var tileId = baseLayer.tiles.get(position) - map.tilesets[0].firstGid;
			this.addTile(new Tile(tileId, pixPosition.x, pixPosition.y));
		}
	}

	inline function loadObjectsLayer(map:TiledMap) {
		for (objectLayer in map.objectLayers) {
			for (tiledObject in objectLayer.objects) {
				var normalizedPosition = map.coordinates.toPixel(tiledObject.coords);
				var objectTile = this.createObjectTile(tiledObject.gid, normalizedPosition.x, normalizedPosition.y);
				objectTile.visible = tiledObject.active;
				tilesByObjectsId.set(tiledObject.id, objectTile);
				this.addTile(objectTile);
			}
		}
	}

	inline function loadTilesets(map:TiledMap) {
		for (mapTileset in map.tilesets) {
			var rectWidth = mapTileset.tileWidth;
			var rectHeight = mapTileset.tileHeight;
			var widthInTiles = Std.int(mapTileset.image.width / rectWidth);
			var heightInTiles = Std.int(mapTileset.image.height / rectHeight);
			for (y in 0... heightInTiles) {
				for (x in 0...widthInTiles) {
					tileset.addRect(new Rectangle(rectWidth * x, rectHeight * y, rectWidth, rectHeight));
				}
			}
		}
	}

	inline function createObjectTile(type:Int, x:Float, y:Float):Tile {
		return new Tile(type - map.tilesets[0].firstGid, x, y);
	}

	public inline function getTileForObjectId(objectId:Int):Tile {
		return tilesByObjectsId.get(objectId);
	}

	public inline function getTileFromCoords(layerId:Int, position:Coordinates):Tile {
		var tileIndex = 0;
		for (layerIndex in 0...layerId) {
			tileIndex += this.map.tileLayers[layerId].tiles.size;
		}
		tileIndex += this.map.tileLayers[layerId].tiles.indexOf(position.x, position.y);
		return this.getTileAt(tileIndex);
	}
}
