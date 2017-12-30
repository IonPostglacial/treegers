package grid;


class Coordinates {
	public var x:TilesCoord;
	public var y:TilesCoord;

	public inline function new(x, y) {
		this.x = x;
		this.y = y;
	}

	public inline function equals(other:Coordinates):Bool {
		return this.x == other.x && this.y == other.y;
	}

	public function direction(other:Coordinates):Direction {
		return Direction.fromVect(other.x - this.x, other.y - this.y);
	}
}
