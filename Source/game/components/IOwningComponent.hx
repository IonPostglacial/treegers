package game.components;

import game.map.TargetObject;


interface IOwningComponent {
	function addRelatedObject(relation:String, object:TargetObject):Void;
}
