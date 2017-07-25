package rendering;

import openfl.Assets;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;

import tmx.TiledMap;


class MapRenderer extends Tilemap {
	var map:TiledMap;
	var tilesByObjectsId:Map<Int, Tile> = new Map();
	var animatedTiles:Array<AnimatedTile> = [];

	public function new(map:TiledMap) {
		super(map.effectiveTileWidth * map.width, map.effectiveTileHeight * map.height, tileset);
		this.map = map;
		tileset = new Tileset(map.tilesets[0].image);
		loadTilesets(map);
		loadTileLayer(map);
		loadObjectsLayer(map);
	}

	inline function loadTileLayer(map:TiledMap) {
		var baseLayer = map.tileLayers[0];
		for (position in baseLayer.tiles.keys()) {
			var pixPosition = map.coordinateSystem.toPixel(position.x, position.y);
			var tileId = baseLayer.tiles.get(position) - map.tilesets[0].firstGid;
			this.addTile(createObjectTile(tileId, pixPosition.x, pixPosition.y));
		}
	}

	inline function loadObjectsLayer(map:TiledMap) {
		for (objectLayer in map.objectLayers) {
			for (tiledObject in objectLayer.objects) {
				var normalizedPosition = map.coordinateSystem.toPixel(tiledObject.coordX, tiledObject.coordY);
				var objectTile = this.createObjectTile(tiledObject.gid - map.tilesets[0].firstGid, normalizedPosition.x, normalizedPosition.y);
				objectTile.visible = tiledObject.active;
				tilesByObjectsId.set(tiledObject.id, objectTile);
				this.addTile(objectTile);
			}
		}
	}

	public function update(deltaTime:Float) {
		for (animatedTile in this.animatedTiles) {
			animatedTile.update(deltaTime);
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

	inline function createObjectTile(tileId:Int, x:Float, y:Float):Tile {
		var tile:Tile;
		if (map.tilesets[0].animationFramesIds.exists(tileId)) {
			var animatedTile = new AnimatedTile(map.tilesets[0].animationFramesIds.get(tileId), 0.1, x, y);
			this.animatedTiles.push(animatedTile);
			tile = animatedTile;
		} else {
			tile = new Tile(tileId, x, y);
		}
		return tile;
	}

	public inline function getTileForObjectId(objectId:Int):Tile {
		return tilesByObjectsId.get(objectId);
	}
}
