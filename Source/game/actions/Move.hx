package game.actions;

import ash.core.Entity;

import game.components.Movement;
import game.components.PathWalker;
import game.map.WorldMap;
import game.nodes.ActionedNode;
import grid.Coordinates;


class Move implements IAction {
	public var done(get, never):Bool;
	var launched = false;
	var path:Array<Coordinates>;
	var entity:Entity;

	public function new(entity, path) {
		this.entity = entity;
		this.path = path;
	}

	public function get_done():Bool {
		var walker = entity.get(PathWalker);
		return walker == null || walker.path.length == 0;
	}

	public function execute(worldMap:WorldMap, node:ActionedNode, deltaTime:Float) {
		var walker = entity.get(PathWalker);
		if (walker != null && walker.path.length == 0) {
			entity.remove(PathWalker);
		}
		if (!launched) {
			var newWalker = new PathWalker();
			newWalker.path = path;
			entity.add(newWalker);
			launched = true;
		}
	}
}
