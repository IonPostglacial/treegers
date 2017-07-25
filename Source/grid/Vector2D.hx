package grid;


class Vector2D {
	public var x(default,null):Float;
	public var y(default,null):Float;

	public inline function new(x, y) {
		this.x = x;
		this.y = y;
	}

	public static inline function interpolate(x1:Float, y1:Float, x2:Float, y2:Float, delta:Float):Vector2D {
		return new Vector2D(x2 + delta * (x1 - x2), y2 + delta * (y1 - y2));
	}
}
