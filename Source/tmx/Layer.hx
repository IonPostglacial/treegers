package tmx;


@:publicFields
class Layer {
	var name:String = "<unnamed>";
	var opacity:Float = 1.0;
	var visible:Bool = true;
	var offsetX:Int = 0;
	var offsetY:Int = 0;

	var orientation:Orientation;
	var width:Int;
	var height:Int;

	function new(map:TiledMap) {
		this.orientation = map.orientation;
		this.width = map.width;
		this.height = map.height;
	}

	function loadFromXml(xml:Xml) {
		ObjectExt.fromMap(xml, Layer, this);
	}
}
