package grid.hex;

import grid.TilesCoord;


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

	override function indexOf(x:TilesCoord, y:TilesCoord):Int {
		return x.toInt() + Std.int(y.toInt()/2) + width * y.toInt();
	}

	override function contains(tx:TilesCoord, ty:TilesCoord):Bool {
		var x = tx.toInt(), y = ty.toInt();
		return x + Std.int(y / 2) >= 0 && x + Std.int(y / 2) < width && y >= 0 && y < height;
	}

	override function keys() {
		return new GridIterator(width, height);
	}

	override function iterator() {
		return new CompactMapIterator<T>(this);
	}
}
