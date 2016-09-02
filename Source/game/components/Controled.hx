package game.components;

import game.actions.Action;

class Controled {
	public var oldPosition:hex.Position;
	public var actions:Array<Action>;
	public var currentAction(get,never):Action;
	public var selected:Bool;

	public function new() {
		this.oldPosition = null;
		this.actions = [];
	}

	public function get_currentAction() {
		return actions[actions.length - 1];
	}
}
