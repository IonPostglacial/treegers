package game.components;

import hex.Position;

class Speed {
	public var period:Float;
	public var timeSinceLastMove:Float;
	public var delta(get, never):Float;
	public var oldPosition:Position;

	public function new(period) {
		this.period = period;
		this.timeSinceLastMove = 0;
		this.oldPosition = new Position(-1, -1);
	}

	public function get_delta():Float {
		var delta = timeSinceLastMove / period;
		return delta <= 1 ? delta : 1;
	}
}
