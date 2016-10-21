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

class HexagonalMap<T> extends HexagonalGrid implements haxe.Constraints.IMap<Coordinates, T> {
	public var data:Vector<T>;
	public var defaultData(default,null):Null<T>;

	public function new(width, height, ?value:T) {
		super(width, height);
		if (value == null) {
			data = new Vector<T>(width * height);
		} else {
			data = Vector.fromArrayCopy([for (i in 0...width * height) value]);
		}
	}

	public static function fromVector<T>(data:Vector<T>, width, height):HexagonalMap<T> {
		var map = new HexagonalMap<T>(width, height);
		for (i in 0...map.data.length) {
			map.data[i] = data[i];
		}
		return map;
	}

	public function get(coordinates:Coordinates):T {
		return data[indexOf(coordinates.x, coordinates.y)];
	}

	public function set(coordinates:Coordinates, value:T) {
		data[indexOf(coordinates.x, coordinates.y)] = value;
	}

	public function remove(coordinates:Coordinates):Bool {
		data[indexOf(coordinates.x, coordinates.y)] = defaultData;
		return true;
	}

	public function exists(coordinates):Bool {
		return contains(coordinates.x, coordinates.y);
	}

	public function iterator() {
		return new HexagonalMapIterator<T>(this);
	}

	public function keys() {
		return cells();
	}

	public function toString() {
		var buffer = new StringBuf();
		buffer.add("{ ");
		for (coordinates in keys()) {
			buffer.add(coordinates);
			buffer.add(": ");
			buffer.add(get(coordinates));
		}
		buffer.add(" }");
		return buffer.toString();
	}

	override public function get_size():Int {
		return data.length;
	}
}
