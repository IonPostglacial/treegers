package tmx;

import grid.ICoordinateSystem;
import grid.hex.CoordinateSystem as HexCoordinateSystem;
import grid.ortho.CoordinateSystem as OrthoCoordinateSystem;
import grid.I2DGrid;
import grid.hex.Grid as HexGrid;
import grid.ortho.Grid as OrthoGrid;


@:publicFields
class TiledMap {
	var version(default,null):String = "0.0";
	var orientation(default,null):Orientation = Orientation.Orthogonal;
	var renderOrder(default,null):RenderOrder = RenderOrder.RightDown;
	var width(default,null):Int = 0;
	var height(default,null):Int = 0;
	var tileWidth(default,null):Int = 0;
	var tileHeight(default,null):Int = 0;
	var effectiveTileWidth(default,null):Int = 0;
	var effectiveTileHeight(default,null):Int = 0;
	var hexSideLength(default,null):Int = 0;
	var staggerAxis(default,null):StaggerAxis = StaggerAxis.X;
	var staggerIndex(default,null):StaggerIndex = StaggerIndex.Event;
	var backgroundColor(default,null):Int = 0;
	var nextObjectId(default,null):Int = 0;

	var tilesets(default,null):Array<Tileset> = [];
	var tileLayers(default,null):Array<TileLayer> = [];
	var objectLayers(default,null):Array<ObjectsLayer> = [];
	var imageLayers(default,null):Array<ImageLayer> = [];
	var properties(default,null):Map<String, Dynamic> = new Map();

	var coordinateSystem:ICoordinateSystem;
	var grid:I2DGrid;
	var bg(get,never):TileLayer;

	private inline function new() {}

	function get_bg() {
		return this.tileLayers[0];
	}

	public static inline function fromXml(xml:Xml):TiledMap {
		var tiledMap = new TiledMap();
		tiledMap.loadFromXml(xml);
		return tiledMap;
	}

	function loadFromXml(xml:Xml) {
		var root = xml.firstElement();
		ObjectExt.fromMap(root, TiledMap, this);
		effectiveTileWidth = tileWidth;
		effectiveTileHeight = tileHeight;

		switch (orientation) {
			case Orientation.Hexagonal:
				coordinateSystem = new HexCoordinateSystem(tileWidth, tileHeight, hexSideLength);
				grid = new HexGrid(width, height);
				effectiveTileHeight = Std.int(0.75 * effectiveTileHeight);
			case Orientation.Orthogonal:
				coordinateSystem = new OrthoCoordinateSystem(tileWidth, tileHeight);
				grid = new OrthoGrid(width, height);
			case Orientation.Isometric | Orientation.Staggered: // TODO: Unimplemented
		}

		for (element in root.elements()) {
			switch (element.nodeName) {
			case "tileset":
				tilesets.push(Tileset.fromXml(element, orientation));
			case "layer":
				tileLayers.push(TileLayer.fromXml(element, this));
			case "objectgroup":
				objectLayers.push(ObjectsLayer.fromXml(element, this));
			}
		}
	}
}
