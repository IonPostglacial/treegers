package game.components;

import game.actions.Action;

class Controled {
	public var actions:Array<Action>;
	public var selected:Bool;
	public var selectedThisRound:Bool = false; // has the entity been selected in this round
	public var currentAction(get,never):Action;

	public function new() {
		this.actions = [];
	}

	public function get_currentAction() {
		return actions[actions.length - 1];
	}
}
