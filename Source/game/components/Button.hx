package game.components;

import game.map.TargetObject;


@:publicFields
class Button implements IOwningComponent {
	var isPressed:Bool = false;
	var triggered:Bool = false;
	var isToggle:Bool = false;
	var affectedTiles:Array<TargetObject> = [];

	function new() {}

	function addRelatedObject(relation:String, object:TargetObject) {
		if (relation == "linked-tile") {
			this.affectedTiles.push(object);
		}
	}
}
