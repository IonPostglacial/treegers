package game.components;

import grid.Coordinates;


@:publicFields
class PathWalker {
	var path:Array<Coordinates>;

	function new(?path) {
		this.path = if(path != null) path else [];
	}
}
