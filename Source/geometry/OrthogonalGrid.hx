package geometry;

class OrthogonalGrid implements Grid2D {
	static var deltas = [-1, -1, -1, 0, -1, 1, 0, -1, 0, 1, 1, -1, 1, 0, 1, 1];

	public var width:Int;
	public var height:Int;
	public var size(get, never):Int;

	public function new(width, height) {
		this.width = width;
		this.height = height;
	}

	static function abs(n:Int):Int {
		return n >= 0 ? n : -n;
	}

	static function max(a:Int, b:Int) {
		return a >= b ? a : b;
	}

	public inline function indexOf(x:Int, y:Int):Int {
		return x + width * y;
	}

	public inline function contains(x:Int, y:Int):Bool {
		return x >= 0 && x < width && y >= 0 && y < height;
	}

	public function cells() {
		return new OrthogonalGridIterator(width, height);
	}

	public function get_size():Int {
		return width * height;
	}

	public inline function distanceBetween(p1:Coordinates, p2:Coordinates):Int {
		return max(abs(p1.x - p2.x), abs(p1.y - p2.y));
	}

	public inline function neighborsOf(p:Coordinates):Array<Coordinates> {
		var neighbors:Array<Coordinates> = [];
		for (i in 0...8) {
			var x = p.x + deltas[2 * i];
			var y = p.y + deltas[2 * i + 1];
			if (contains(x, y)) {
				neighbors.push(new Coordinates(x, y));
			}
		}
		return neighbors;
	}
}
