package game.components;

import geometry.Coordinates;
import game.mapmanagement.Vehicle;


class Movement {
	public var vehicle:Vehicle;
	public var period:Float;
	public var oldPosition(default, set):Coordinates;
	public var delta(get, never):Float;
	public var ready(get, never):Bool;
	var timeSinceLastMove:Float;

	public function new(vehicle, period) {
		this.vehicle = vehicle;
		this.period = period;
		this.timeSinceLastMove = 0;
		this.oldPosition = null;
	}

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
