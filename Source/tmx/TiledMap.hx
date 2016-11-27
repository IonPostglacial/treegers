package tmx;

import Type;

import geometry.CoordinatesSystem;
import geometry.HexagonalCoordinates;
import geometry.OrthogonalCoordinates;
import geometry.Grid2D;
import geometry.HexagonalGrid;
import geometry.OrthogonalGrid;
import geometry.Map2D;

using StringTools;


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

	public var coordinates:CoordinatesSystem;
	public var grid:Grid2D;
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
				coordinates = new HexagonalCoordinates(tileWidth, tileHeight, hexSideLength);
				grid = new HexagonalGrid(width, height);
				effectiveTileHeight = Std.int(0.75 * effectiveTileHeight);
			default:
				coordinates = new OrthogonalCoordinates(tileWidth, tileHeight);
				grid = new OrthogonalGrid(width, height);
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
