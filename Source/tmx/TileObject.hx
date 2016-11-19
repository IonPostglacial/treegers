package tmx;

class TileObject {
	public var active:Bool = true;
	public var type:String = "";
	public var id:Int = 0;
	public var gid:Int = 0;
	public var x:Int = 0;
	public var y:Int = 0;
	public var coords:geometry.Coordinates;
	public var width:Int = 0;
	public var height:Int = 0;
	public var properties:Map<String, String> = new Map();

	public function new() {}
}
