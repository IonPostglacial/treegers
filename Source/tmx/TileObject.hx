package tmx;


@:publicFields
class TileObject {
	var active:Bool = true;
	var type:String = "";
	var id:Int = 0;
	var gid:Int = 0;
	var x:Int = 0;
	var y:Int = 0;
	var coordX:Int = 0;
	var coordY:Int = 0;
	var width:Int = 0;
	var height:Int = 0;
	var properties:Map<String, String> = new Map();

	public function new() {}
}
