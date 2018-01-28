package game.actions;

import ash.core.Entity;

import game.components.PathWalker;
import game.map.WorldMap;
import game.nodes.ActionedNode;

using Lambda;


class Move implements IAction {
	public var done(get, never):Bool;
	var launched = false;
	var pathWalker:PathWalker;
	var entity:Entity;

	public function new(entity, pathWalker) {
		this.entity = entity;
		this.pathWalker = pathWalker;
	}

	public function get_done():Bool {
		return pathWalker.path.empty();
	}

	public function execute(worldMap:WorldMap, node:ActionedNode, deltaTime:Float) {
		if (pathWalker != null && pathWalker.path.empty()) {
			entity.remove(PathWalker);
		}
		if (!launched) {
			entity.add(pathWalker);
			launched = true;
		}
	}
}
