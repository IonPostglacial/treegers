package game.components;

import geometry.Coordinates;
import game.mapmanagement.Vehicle;


class Movement {
	public var vehicle:Vehicle = Vehicle.Foot;
	public var period:Float = 0.5;
	public var oldPosition:Coordinates = null;
	public var timeSinceLastMove:Float = 0;

	public function new() {}
}
