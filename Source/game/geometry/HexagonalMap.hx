package game.geometry;

import haxe.Constraints.IMap;
import game.components.Position;


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

class HexagonalMap<T> {
	public var data:Array<T>;

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
		return x + Std.int(y/2) + width * y;
	}

	public function get(position:Position):T {
		return data[indexOf(position.x, position.y)];
	}

	public function set(position:Position, value:T) {
		data[indexOf(position.x, position.y)] = value;
	}

	public function exists(position):Bool {
		return indexOf(position.x, position.y) < data.length;
	}

	public function iterator() {
		return new HexagonalMapIterator<T>(this);
	}

	public function keys() {
		return new HexagonalGridIterator(width, height);
	}

	public function toString() {
		var buffer = new StringBuf();
		buffer.add("{ ");
		for (position in keys()) {
			buffer.add(position);
			buffer.add(": ");
			buffer.add(get(position));
		}
		buffer.add(" }");
		return buffer.toString();
	}

	public function get_size():Int {
		return data.length;
	}
}
