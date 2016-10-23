package tmx;

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
		name = new Def(name).or(xml.get("name"));
		opacity = Std.parseFloat(new Def("1.0").or(xml.get("opacity")));
		visible = Std.parseInt(new Def("1").or(xml.get("visible"))) == 1;
		offsetX = new Def(offsetX).or(Std.parseInt(xml.get("offsetx")));
		offsetY = new Def(offsetY).or(Std.parseInt(xml.get("offsety")));
	}
}
