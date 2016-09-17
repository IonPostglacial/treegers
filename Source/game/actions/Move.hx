package game.actions;

import ash.core.Entity;

import game.components.Movement;
import game.components.PathWalker;
import game.nodes.ActionedNode;
import hex.Position;

class Move implements Action {
	public var done(get, never):Bool;
	var entity:Entity;
	var path:Array<hex.Position>;

	public function new(stage:GameStage, entity, goal) {
		this.entity = entity;
		this.path = graph.Path.find(stage.obstaclesFor(entity.get(Movement).transportation), entity.get(Position), goal);
		this.path.pop();
	}

	public function get_done():Bool {
		var walker = entity.get(PathWalker);
		return walker == null || walker.path.length == 0;
	}

	public function execute(stage:GameStage, node:ActionedNode, deltaTime:Float) {
		var walker = entity.get(PathWalker);
		if (walker != null && walker.path.length == 0) {
			entity.remove(PathWalker);
		}
		entity.add(new PathWalker(path));
	}
}
