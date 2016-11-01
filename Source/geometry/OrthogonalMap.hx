package geometry;

import haxe.ds.Vector;


class OrthogonalMapIterator<T> {
	var i:Int;
	var hexMap:OrthogonalMap<T>;

	public inline function new(hexMap) {
		this.i = 0;
		this.hexMap = hexMap;
	}

	public inline function hasNext() return i < this.hexMap.size;
	public inline function next() return this.hexMap.data[i];
}

class OrthogonalMap<T> extends Map2D<T> {

	public function new(width, height, ?value:T) {
		super(width, height, value);
	}

	public static function fromArray<T>(data:Array<T>, width, height):OrthogonalMap<T> {
		var map = new OrthogonalMap<T>(width, height);
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
		return new OrthogonalGridIterator(width, height);
	}

	override function iterator() {
		return new OrthogonalMapIterator<T>(this);
	}
}
