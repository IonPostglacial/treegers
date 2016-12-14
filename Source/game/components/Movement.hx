package game.components;

import geometry.Coordinates;
import game.map.Vehicle;


class Movement {
	public var vehicle:Vehicle = Vehicle.Foot;
	public var period:Float = 0.5;
	public var oldX:Int = -1;
	public var oldY:Int = -1;
	public var timeSinceLastMove:Float = 0;

	public function new() {}
}
