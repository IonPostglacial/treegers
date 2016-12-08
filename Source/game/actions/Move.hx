package game.actions;

import ash.core.Entity;

import game.components.Movement;
import game.components.PathWalker;
import game.nodes.ActionedNode;
import geometry.Coordinates;


class Move implements IAction {
	public var done(get, never):Bool;
	var path:Array<Coordinates>;
	var entity:Entity;

	public function new(entity, path) {
		this.entity = entity;
		this.path = path;
		this.path.pop();
	}

	public function get_done():Bool {
		var walker = entity.get(PathWalker);
		return walker == null || walker.path.length == 0;
	}

	public function execute(node:ActionedNode, deltaTime:Float) {
		var walker = entity.get(PathWalker);
		if (walker != null && walker.path.length == 0) {
			entity.remove(PathWalker);
		}
		var newWalker = new PathWalker();
		newWalker.path = path;
		entity.add(newWalker);
	}
}
