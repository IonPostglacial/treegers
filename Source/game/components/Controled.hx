package game.components;

import game.actions.Action;

class Controled {
	public var actions:Array<Action>;
	public var currentAction(get,never):Action;
	public var selected:Bool;

	public function new() {
		this.actions = [];
	}

	public function get_currentAction() {
		return actions[actions.length - 1];
	}
}
