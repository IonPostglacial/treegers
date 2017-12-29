package tmx;

import grid.ICoordinateSystem;
import grid.hex.CoordinateSystem as HexCoordinateSystem;
import grid.ortho.CoordinateSystem as OrthoCoordinateSystem;
import grid.I2DGrid;
import grid.hex.Grid as HexGrid;
import grid.ortho.Grid as OrthoGrid;


typedef XmlLoadable = {
	function loadFromXml(xml:Xml):Void;
}

class TiledMap {
	public var version(default,null):String = "0.0";
	public var orientation(default,null):Orientation = Orientation.Orthogonal;
	public var renderOrder(default,null):RenderOrder = RenderOrder.RightDown;
	public var width(default,null):Int = 0;
	public var height(default,null):Int = 0;
	public var tileWidth(default,null):Int = 0;
	public var tileHeight(default,null):Int = 0;
	public var effectiveTileWidth(default,null):Int = 0;
	public var effectiveTileHeight(default,null):Int = 0;
	public var hexSideLength(default,null):Int = 0;
	public var staggerAxis(default,null):StaggerAxis = StaggerAxis.X;
	public var staggerIndex(default,null):StaggerIndex = StaggerIndex.Event;
	public var backgroundColor(default,null):Int = 0;
	public var nextObjectId(default,null):Int = 0;

	public var tilesets(default,null):Array<Tileset> = [];
	public var tileLayers(default,null):Array<TileLayer> = [];
	public var objectLayers(default,null):Array<ObjectsLayer> = [];
	public var imageLayers(default,null):Array<ImageLayer> = [];
	public var properties(default,null):Map<String, Dynamic> = new Map();

	public var coordinateSystem:ICoordinateSystem;
	public var grid:I2DGrid;
	public var bg(get,never):TileLayer;

	public function new() {}

	public function get_bg() {
		return this.tileLayers[0];
	}

	public function loadFromXml(xml:Xml) {
		var root = xml.firstElement();
		ObjectExt.fromMap(root, TiledMap, this);
		effectiveTileWidth = tileWidth;
		effectiveTileHeight = tileHeight;

		switch (orientation) {
			case Orientation.Hexagonal:
				coordinateSystem = new HexCoordinateSystem(tileWidth, tileHeight, hexSideLength);
				grid = new HexGrid(width, height);
				effectiveTileHeight = Std.int(0.75 * effectiveTileHeight);
			default:
				coordinateSystem = new OrthoCoordinateSystem(tileWidth, tileHeight);
				grid = new OrthoGrid(width, height);
		}

		for (element in root.elements()) {
			var mapElement:Null<XmlLoadable> = null;
			switch (element.nodeName) {
			case "tileset":
				tilesets.push(new Tileset(orientation));
				mapElement = tilesets[tilesets.length - 1];
			case "layer":
				tileLayers.push(new TileLayer(this));
				mapElement = tileLayers[tileLayers.length - 1];
			case "objectgroup":
				objectLayers.push(new ObjectsLayer(this));
				mapElement = objectLayers[objectLayers.length - 1];
			}
			if (mapElement != null) {
				mapElement.loadFromXml(element);
			}
		}
	}
}
