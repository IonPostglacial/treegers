package tmx;

import geometry.CoordinatesSystem;
import geometry.HexagonalCoordinates;
import geometry.OrthogonalCoordinates;
import geometry.Grid2D;
import geometry.HexagonalGrid;
import geometry.OrthogonalGrid;
import geometry.Map2D;

using StringTools;
using tmx.XmlDef;

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
	public var bgTiles(get,never):Map2D<Int>;

	public function new() {}

	public function get_bgTiles() {
		return this.tileLayers[0].tiles;
	}

	public function loadFromXml(xml:Xml) {
		var root = xml.firstElement();

		version = root.defget("version", version);
		orientation = root.defget("orientation", orientation);
		renderOrder = root.defget("renderorder", renderOrder);
		width = Std.parseInt(root.defget("width", "0"));
		height = Std.parseInt(root.defget("height", "0"));
		tileWidth = Std.parseInt(root.defget("tilewidth", "0"));
		tileHeight = Std.parseInt(root.defget("tileheight", "0"));
		effectiveTileWidth = tileWidth;
		effectiveTileHeight = tileHeight;
		hexSideLength = Std.parseInt(root.defget("hexsidelength", "0"));
		staggerAxis = root.defget("staggeraxis", staggerAxis);
		staggerIndex = root.defget("staggerindex", staggerIndex);
		backgroundColor = Std.parseInt(root.defget("backgroundcolor", "0"));
		var nextObjId = Std.parseInt(root.defget("nextobjectid", "").replace("#", "0x"));
		nextObjectId = nextObjId != null ? nextObjId : 0;

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
				tilesets.push(new Tileset());
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
