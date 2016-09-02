/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package hex;

import openfl.geom.Point;

class Hexagon {
	static var SQRT3 = Math.sqrt(3);
	public var centerX:Float;
	public var centerY:Float;
	public var radius:Float;
	public var area(get, never):Float;
	public var corners(get, never):Array<Point>;

	public function new(centerX:Float, centerY:Float, radius:Float) {
		this.centerX = centerX;
		this.centerY = centerY;
		this.radius = radius;
	}

	public function get_area():Float {
		return 1.5 * SQRT3 * radius * radius;
	}

	public function get_corners():Array<Point> {
		var H_OFFSET = SQRT3 * 0.5 * radius;
		var V_OFFSET = radius * 0.5;
		return [
			new Point(centerX - H_OFFSET, centerY - V_OFFSET),
			new Point(centerX, centerY - radius),
			new Point(centerX + H_OFFSET, centerY - V_OFFSET),
			new Point(centerX + H_OFFSET, centerY + V_OFFSET),
			new Point(centerX, centerY + radius),
			new Point(centerX - H_OFFSET, centerY + V_OFFSET)
		];
	}
}
