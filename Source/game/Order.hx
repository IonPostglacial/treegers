package game;

using grid.Pixel;

import openfl.Lib;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

import game.map.TargetObject;
import grid.ICoordinateSystem;


enum Order {
	Nothing;
	MovementOrdered(x:Int, y:Int);
	PowerOrdered(target:TargetObject);
	TargetSelected(x:Int, y:Int);
}

class Board {
	public var currentOrder:Order = Nothing;
	public var mouseClicked(default,null):Bool = false;
	public var mouseMoved(default,null):Bool = false;
	public var mousePositionX(default,null):Int = 0;
	public var mousePositionY(default,null):Int = 0;

	public function new(camera:Rectangle, coordinates:ICoordinateSystem) {
		Lib.current.addEventListener(MouseEvent.CLICK, function(e) {
			this.mouseClicked = true;
		});
		Lib.current.addEventListener(MouseEvent.MOUSE_MOVE, function(e) {
			this.mouseMoved = true;
			var mousePosition = coordinates.fromPixel((e.stageX + camera.x).pixel(), (e.stageY + camera.y).pixel());
			this.mousePositionX = mousePosition.x;
			this.mousePositionY = mousePosition.y;
		});
	}

	public function refresh() {
		this.currentOrder = Nothing;
		this.mouseClicked = false;
		this.mouseMoved = false;
	}
}
