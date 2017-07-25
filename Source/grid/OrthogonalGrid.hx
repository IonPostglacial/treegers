package grid;


class OrthogonalGrid implements I2DGrid {
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
		var dx = p1.x - p2.x;
		var dy = p1.y - p2.y;
		return dx * dx + dy * dy;
	}

	public function areNeighbors(p1:Coordinates, p2:Coordinates):Bool {
		return abs(p1.x - p2.x) <= 1 && abs(p1.y - p2.y) <= 1;
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

	public function nodeIndex(node:Coordinates):Int {
		return node.x + node.y * width;
	}
}
