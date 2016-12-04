package game.components;


class Button implements OwningComponent {
	public var isPressed:Bool = false;
	public var triggered:Bool = false;
	public var isToggle:Bool = false;
	public var affectedTiles:Array<tmx.TileObject> = [];

	public function new() {}

	public function addRelatedObject(relation:String, object:Dynamic) {
		if (relation == "linked-tile") {
			this.affectedTiles.push(object);
		}
	}
}
