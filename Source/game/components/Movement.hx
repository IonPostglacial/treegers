package game.components;

import geometry.Coordinates;
import geometry.Direction;
import game.map.Vehicle;


class Movement {
	public var vehicle:Vehicle = Vehicle.Foot;
	public var period:Float = 0.5;
	public var nextX = 0;
	public var nextY = 0;
	public var alreadyMoved = false;
	public var timeSinceLastMove:Float = 0;

	public function new() {}
}
