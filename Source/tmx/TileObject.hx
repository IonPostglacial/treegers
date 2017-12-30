package tmx;

using grid.Pixel;


@:publicFields
class TileObject {
	var active:Bool = true;
	var type:String = "";
	var id:Int = 0;
	var gid:Int = 0;
	var x:Pixel = 0.pixel();
	var y:Pixel = 0.pixel();
	var coordX:Int = 0;
	var coordY:Int = 0;
	var width:Pixel = 0.pixel();
	var height:Pixel = 0.pixel();
	var properties:Map<String, String> = new Map();

	public function new() {}
}
