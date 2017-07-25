package game.components;

import geometry.Coordinates;
import geometry.Direction;
import game.map.Vehicle;


@:publicFields
class Movement {
	var vehicle:Vehicle = Vehicle.Foot;
	var period:Float = 0.5;
	var direction = Direction.None;
	var alreadyMoved = false;
	var timeSinceLastMove:Float = 0;

	public function new() {}
}
