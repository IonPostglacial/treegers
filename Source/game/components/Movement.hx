package game.components;

import geometry.Coordinates;
import geometry.Direction;
import game.map.Vehicle;


class Movement {
	public var vehicle:Vehicle = Vehicle.Foot;
	public var period:Float = 0.5;
	public var direction = Direction.None;
	public var alreadyMoved = false;
	public var timeSinceLastMove:Float = 0;

	public function new() {}
}
