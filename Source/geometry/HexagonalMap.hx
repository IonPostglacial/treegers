package geometry;

import haxe.ds.Vector;


class HexagonalMapIterator<T> {
	var i:Int;
	var hexMap:HexagonalMap<T>;

	public inline function new(hexMap) {
		this.i = 0;
		this.hexMap = hexMap;
	}

	public inline function hasNext() return i < this.hexMap.size;
	public inline function next() return this.hexMap.data[i];
}

class HexagonalMap<T> extends  Map2D<T> {

	public function new(width, height, ?value:T) {
		super(width, height, value);
	}

	public static function fromArray<T>(data:Array<T>, width, height):HexagonalMap<T> {
		var map = new HexagonalMap<T>(width, height);
		map.data = data;
		return map;
	}

	override function indexOf(x:Int, y:Int):Int {
		return x + Std.int(y/2) + width * y;
	}

	override function contains(x:Int, y:Int):Bool {
		return x + Std.int(y / 2) >= 0 && x + Std.int(y / 2) < width && y >= 0 && y < height;
	}

	override function keys() {
		return new HexagonalGridIterator(width, height);
	}

	override function iterator() {
		return new HexagonalMapIterator<T>(this);
	}
}
