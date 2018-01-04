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

	function new() {}

	function get_bg() {
		return this.tileLayers[0];
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
			default: // TODO: Unimplemented
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
