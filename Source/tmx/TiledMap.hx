package tmx;

import geometry.CoordinatesSystem;
import geometry.HexagonalCoordinates;
import geometry.OrthogonalCoordinates;


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

	public function new() {}

	public function loadFromXml(xml:Xml) {
		var root = xml.firstElement();

		version = new Def(version).or(root.get("version"));
		orientation = new Def(orientation).or(root.get("orientation"));
		renderOrder = new Def(renderOrder).or(root.get("renderorder"));
		width = new Def(width).or(Std.parseInt(root.get("width")));
		height = new Def(height).or(Std.parseInt(root.get("height")));
		tileWidth = new Def(tileWidth).or(Std.parseInt(root.get("tilewidth")));
		tileHeight = new Def(tileHeight).or(Std.parseInt(root.get("tileheight")));
		hexSideLength = new Def(hexSideLength).or(Std.parseInt(root.get("hexsidelength")));
		staggerAxis = new Def(staggerAxis).or(root.get("staggeraxis"));
		staggerIndex = new Def(staggerIndex).or(root.get("staggerindex"));
		backgroundColor = new Def(backgroundColor).or(Std.parseInt(root.get("backgroundcolor")));
		nextObjectId = new Def(nextObjectId).or(Std.parseInt(new Def("").or(root.get("nextobjectid")).replace("#", "0x")));

		switch (orientation) {
			case Orientation.Hexagonal:
				coordinates = new HexagonalCoordinates(hexSideLength);
			default:
				coordinates = new OrthogonalCoordinates(tileWidth, tileHeight);
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
			}
			if (mapElement != null) {
				mapElement.loadFromXml(element);
			}
		}
	}
}
