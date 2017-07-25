package grid.ortho;


class GridIterator {
	var width:Int;
	var height:Int;
	var x:Int;
	var y:Int;

	public inline function new(width, height) {
		x = -1;
		y = 0;
		this.width = width;
		this.height = height;
	}

	public function hasNext():Bool {
		return x != width - 1 || y != height - 1;
	}

	public function next():Coordinates {
		x += 1;
		if (x == width) {
			x = 0;
			y += 1;
		}
		return new Coordinates(x, y);
	}
}
