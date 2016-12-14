package game.systems;

import openfl.Lib;

import ash.core.System;


class CameraSystem extends System {
	static var SCROLL_MARGIN = 64;
	static var SCROLL_SPEED = 8;

	var camera(default,null):openfl.geom.Rectangle;

	public function new(camera:openfl.geom.Rectangle) {
		this.camera = camera;
		super();
	}

	override function update(deltaTime:Float) {
		var relativeX = Lib.current.mouseX - camera.x;
		var relativeY = Lib.current.mouseY - camera.y;
		var maxX = Lib.current.width - camera.width;
		var maxY = Lib.current.height - camera.height;
		var changed = false;

		if (relativeX < SCROLL_MARGIN) {
			camera.x = Math.max(camera.x - SCROLL_SPEED, 0);
			changed = true;
		}
		if (relativeX > camera.width - SCROLL_MARGIN) {
			camera.x = Math.min(camera.x + SCROLL_SPEED, maxX);
			changed = true;
		}
		if (relativeY < SCROLL_MARGIN) {
			camera.y = Math.max(camera.y - SCROLL_SPEED, 0);
			changed = true;
		}
		if (relativeY > camera.height - SCROLL_MARGIN) {
			camera.y = Math.min(camera.y + SCROLL_SPEED, maxY);
			changed = true;
		}
		if (changed) {
			Lib.current.scrollRect = camera;
		}
	}
}
