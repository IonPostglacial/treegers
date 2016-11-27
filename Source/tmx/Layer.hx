package tmx;

class Layer {
	public var name:String = "<unnamed>";
	public var opacity:Float = 1.0;
	public var visible:Bool = true;
	public var offsetX:Int = 0;
	public var offsetY:Int = 0;

	public var orientation:Orientation;
	public var width:Int;
	public var height:Int;

	public function new(map:TiledMap) {
		this.orientation = map.orientation;
		this.width = map.width;
		this.height = map.height;
	}

	public function loadFromXml(xml:Xml) {
		ObjectExt.fromMap(xml, Layer, this);
	}
}
