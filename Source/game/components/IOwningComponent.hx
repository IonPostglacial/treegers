package game.components;

interface IOwningComponent {
	function addRelatedObject(relation:String, object:Dynamic):Void;
}
