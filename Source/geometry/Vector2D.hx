package geometry;

class Vector2D {
	public var x(default,null):Float;
	public var y(default,null):Float;

	public inline function new(x, y) {
		this.x = x;
		this.y = y;
	}

	public function interpolate(other:Vector2D, delta:Float):Vector2D {
		return new Vector2D(other.x + delta * (this.x - other.x), other.y + delta * (this.y - other.y));
	}
}
