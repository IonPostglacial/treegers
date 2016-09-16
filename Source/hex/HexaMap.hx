package hex;

class HexaMap<T> {
	var data:Array<T>;

	public var width:Int;
	public var height:Int;
	public var size(get, never):Int;

	public function new(width, height, ?value:T) {
		this.width = width;
		this.height = height;
		if (value == null) {
			data = [];
		} else {
			data = [for (i in 0...width * height) value];
		}
	}

	inline function indexOf(x:Int, y:Int):Int {
		return x + Std.int(y/2) + height * y;
	}

	public function get(x:Int, y:Int):T {
		return data[indexOf(x, y)];
	}

	public function set(x:Int, y:Int, value:T) {
		data[indexOf(x, y)] = value;
	}

	public function has(x:Int, y:Int):Bool {
		return indexOf(x, y) < data.length;
	}

	public function get_size():Int {
		return data.length;
	}
}
