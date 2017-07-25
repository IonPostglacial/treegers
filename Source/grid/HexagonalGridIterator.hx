package grid;


class HexagonalGridIterator {
	var width:Int;
	var height:Int;
	var i:Int;
	var y:Int;

	public inline function new(width, height) {
		i = -1;
		y = 0;
		this.width = width;
		this.height = height;
	}

	public function hasNext():Bool {
		return i != width - 1 || y != height - 1;
	}

	public function next():Coordinates {
		i += 1;
		if (i == width) {
			i = 0;
			y += 1;
		}
		return new Coordinates(i - Std.int(y / 2), y);
	}
}
