package game.actions;

import ash.core.Entity;

import game.components.Speed;
import game.nodes.ActionedNode;

class Move implements Action {
	public var done(get, never):Bool;
	var path:Array<hex.Position>;
	var _done = false;

	public function new(path) {
		this.path = path;
	}

	function processMovement(speed:Speed, time:Float):Null<hex.Position> {
		var updatedPosition:Null<hex.Position> = null;

		if (speed.timeSinceLastMove >= speed.period) {
			updatedPosition = path.pop();
			speed.timeSinceLastMove -= speed.period;
		}
		return updatedPosition;
	}

	public function get_done():Bool {
		return _done;
	}

	public function execute(stage:GameStage, node:ActionedNode, deltaTime:Float) {
		if (path.length > 0) {
			var newPosition = processMovement(node.speed, deltaTime);
			if (newPosition != null) {
				node.position.assign(newPosition);
			}
		} else {
			_done = true;
		}
	}
}
