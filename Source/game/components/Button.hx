package game.components;

import haxe.ds.Vector;


class Button implements OwningComponent {
	public var isPressed:Bool = false;
	public var triggered:Bool = false;
	public var isToggle:Bool;
	public var affectedTiles:Array<tmx.TileObject> = [];

	public function new(isToggle) {
		this.isToggle = isToggle;
	}

	public function flip() {
		isPressed = !isPressed;
		if (isToggle || isPressed) {
			triggered = !triggered;
		}
	}

	public function addRelatedObject(relation:String, object:Dynamic) {
		if (relation == "linked-tile") {
			this.affectedTiles.push(object);
		}
	}
}
