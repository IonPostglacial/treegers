package game.components;

import game.actions.IAction;


@:publicFields
class Controled {
	var actions:Array<IAction> = [];
	var selected:Bool = false;
	var selectedThisRound:Bool = false; // has the entity been selected in this round

	function new() {}
}
