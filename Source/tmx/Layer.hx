package tmx;

using tmx.XmlDef;


class Layer {
	public var name:String = "<unnamed>";
	public var opacity:Float = 1.0;
	public var visible:Bool = true;
	public var offsetX:Int = 0;
	public var offsetY:Int = 0;

	var map:TiledMap; // weak ref

	public function new(map:TiledMap) {
		this.map = map;
	}

	public function loadFromXml(xml:Xml) {
		name = xml.defget("name", name);
		opacity = Std.parseFloat(xml.defget("opacity", "1.0"));
		visible = Std.parseInt(xml.defget("visible", "1")) == 1;
		offsetX = Std.parseInt(xml.defget("offsetx", "0"));
		offsetY = Std.parseInt(xml.defget("offsety", "0"));
	}
}
