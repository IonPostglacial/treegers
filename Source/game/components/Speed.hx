package game.components;

class Speed {
	public var period:Float;
	public var timeSinceLastMove:Float;
	public var delta(get, never):Float;

	public function new(period) {
		this.period = period;
		this.timeSinceLastMove = 0;
	}

	public function get_delta():Float {
		var delta = timeSinceLastMove / period;
		return delta <= 1 ? delta : 1;
	}
}
