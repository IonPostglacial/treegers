package game.components;

import game.actions.IAction;

class Controled {
	public var actions:Array<IAction> = [];
	public var selected:Bool = false;
	public var selectedThisRound:Bool = false; // has the entity been selected in this round

	public function new() {}
}
