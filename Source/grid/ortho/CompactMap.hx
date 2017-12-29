package grid.ortho;


class CompactMapIterator<T> {
	var i:Int;
	var hexMap:CompactMap<T>;

	public inline function new(hexMap) {
		this.i = 0;
		this.hexMap = hexMap;
	}

	public inline function hasNext() return i < this.hexMap.size;
	public inline function next() return this.hexMap.data[i];
}

class CompactMap<T> extends Map2D<T> {

	public function new(width, height, ?value:T) {
		super(width, height, value);
	}

	public static function fromArray<T>(data:Array<T>, width, height):CompactMap<T> {
		var map = new CompactMap<T>(width, height);
		map.data = data;
		return map;
	}

	override function indexOf(x:Int, y:Int):Int {
		return x + width * y;
	}

	override function contains(x:Int, y:Int):Bool {
		return x >= 0 && x < width && y >= 0 && y < height;
	}

	override function keys() {
		return new GridIterator(width, height);
	}

	override function iterator() {
		return new CompactMapIterator<T>(this);
	}
}
