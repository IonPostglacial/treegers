package game.actions;

import game.nodes.ActionedNode;

import geometry.Coordinates;
import game.components.Mana;


class UseMana implements IAction {
	public var done(get, never):Bool;
	public var mana:Mana;
	public var coords:Coordinates;
	var _done:Bool = false;

	public function new(mana:Mana, coords:Coordinates) {
		this.mana = mana;
		this.coords = coords;
	}

	public function get_done():Bool {
		return _done;
	}

	public function execute(node:ActionedNode, deltaTime:Float) {
		// TODO: do something
		var isManaLoaded = mana.elapsedLoadTime >= mana.loadTime;
		if (isManaLoaded) {
			// TODO: launch power
			mana.level = 0;
			mana.elapsedLoadTime = 0;
			_done = true;
		} else {
			mana.elapsedLoadTime += deltaTime;
		}
	}
}
