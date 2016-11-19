package tmx;

using tmx.XmlDef;


class Tileset {
	public var firstGid:Int = 0;
	public var source:String = "";
	public var name:String = "<unnamed>";
	public var tileWidth:Int = 0;
	public var tileHeight:Int = 0;
	public var spacing:Int = 0;
	public var margin:Int = 0;
	public var tileCount:Int = 0;
	public var columns:Int = 0;
	public var properties(default,null):Map<String, Dynamic> = new Map();
	public var image:openfl.display.BitmapData;
	public var terrains:Map<Int, Array<Null<Int>>> = new Map();
	var terrainsNumberByTile = 0;

	public function new(orientation:Orientation) {
		terrainsNumberByTile = orientation.adjacentTilesNumber();
	}

	public function loadFromXml(xml:Xml) {
		xml.fillObject(Tileset, this);
		var imageElements = xml.elementsNamed('image');
		for (imageElement in imageElements) {
			var imagePath = imageElement.get("source");
			image = openfl.Assets.getBitmapData("assets/" + imagePath);
		}
		var tileElements = xml.elementsNamed('tile');
		for (tileElement in tileElements) {
			var rawTerrain = tileElement.get("terrain");
			if (rawTerrain != null) {
				var tileTerrain = rawTerrain.split(",").map(Std.parseInt);
				var tileId = Std.parseInt(tileElement.get("id"));
				this.terrains.set(firstGid + tileId, tileTerrain);
			}
		}
	}
}
