package geometry;


class Coordinates {
	public var x:Int;
	public var y:Int;

	public inline function new(x, y) {
		this.x = x;
		this.y = y;
	}

	public inline function equals(other):Bool {
		return this.x == other.x && this.y == other.y;
	}

	public inline function hashCode():Int {
		return y | (x << 16); // x can be negative while y cannot.
	}
}
