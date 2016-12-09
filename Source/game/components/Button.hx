package game.components;

import game.map.TargetObject;


class Button implements IOwningComponent {
	public var isPressed:Bool = false;
	public var triggered:Bool = false;
	public var isToggle:Bool = false;
	public var affectedTiles:Array<TargetObject> = [];

	public function new() {}

	public function addRelatedObject(relation:String, object:TargetObject) {
		if (relation == "linked-tile") {
			this.affectedTiles.push(object);
		}
	}
}
