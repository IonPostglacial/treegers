package game.components;

import geometry.Coordinates;
import game.mapmanagement.Vehicle;


class Movement {
	public var vehicle:Vehicle = Vehicle.Foot;
	public var period:Float = 0.5;
	public var oldPosition(default, set):Coordinates = null;
	public var delta(get, never):Float;
	public var ready(get, never):Bool;
	var timeSinceLastMove:Float = 0;

	public function new() {}

	public function get_ready():Bool {
		return timeSinceLastMove >= period;
	}

	public function make(deltaTime:Float) {
		if (timeSinceLastMove < period) {
			timeSinceLastMove += deltaTime;
		}
	}

	public function set_oldPosition(oldPosition:Coordinates):Coordinates {
		this.oldPosition = oldPosition;
		timeSinceLastMove -= period;
		return oldPosition;
	}

	public function get_delta():Float {
		var delta = timeSinceLastMove / period;
		return if (delta < 0) 0 else if (delta > 1) 1 else delta;
	}
}
