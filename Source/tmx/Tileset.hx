package tmx;

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
		name = new Def(name).or(xml.get("name"));
		source = new Def(source).or(xml.get("source"));
		firstGid = new Def(firstGid).or(Std.parseInt(xml.get("firstgid")));
		tileWidth = new Def(tileWidth).or(Std.parseInt(xml.get("tilewidth")));
		tileHeight = new Def(tileHeight).or(Std.parseInt(xml.get("tileheight")));
		spacing = new Def(spacing).or(Std.parseInt(xml.get("spacing")));
		margin = new Def(margin).or(Std.parseInt(xml.get("margin")));
		tileCount = new Def(tileCount).or(Std.parseInt(xml.get("tilecount")));
		columns = new Def(columns).or(Std.parseInt(xml.get("columns")));
		var imageElements = xml.elementsNamed('image');
		for (imageElement in imageElements) {
			var imagePath = new Def("").or(imageElement.get("source"));
			image = openfl.Assets.getBitmapData("assets/" + imagePath);
		}
	}
}
