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

	public function new() {}

	public function loadFromXml(xml:Xml) {
		name = xml.defget("name", name);
		source = xml.defget("source", source);
		firstGid = Std.parseInt(xml.defget("firstgid", "0"));
		tileWidth = Std.parseInt(xml.defget("tilewidth", "0"));
		tileHeight = Std.parseInt(xml.defget("tileheight", "0"));
		spacing = Std.parseInt(xml.defget("spacing", "0"));
		margin = Std.parseInt(xml.defget("margin", "0"));
		tileCount = Std.parseInt(xml.defget("tilecount", "0"));
		columns = Std.parseInt(xml.defget("columns", "0"));
		var imageElements = xml.elementsNamed('image');
		for (imageElement in imageElements) {
			var imagePath = imageElement.defget("source", "");
			image = openfl.Assets.getBitmapData("assets/" + imagePath);
		}
	}
}
