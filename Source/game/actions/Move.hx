package game.actions;

import ash.core.Entity;

import game.components.Movement;
import game.components.PathWalker;
import game.components.Position;
import game.nodes.ActionedNode;
import game.components.Position;


class Move implements Action {
	public var done(get, never):Bool;
	var entity:Entity;
	var path:Array<Position>;

	public function new(stage:Stage, entity, goal) {
		this.entity = entity;
		this.path = stage.findPath(entity.get(Movement).vehicle, entity.get(Position), goal);
		this.path.pop();
	}

	public function get_done():Bool {
		var walker = entity.get(PathWalker);
		return walker == null || walker.path.length == 0;
	}

	public function execute(stage:Stage, node:ActionedNode, deltaTime:Float) {
		var walker = entity.get(PathWalker);
		if (walker != null && walker.path.length == 0) {
			entity.remove(PathWalker);
		}
		entity.add(new PathWalker(path));
	}
}
