package game.actions;

import geometry.Coordinates;
import game.nodes.ActionedNode;
import game.components.Mana;
import game.components.ObjectChanger;
import game.map.WorldMap;


class UseMana implements IAction {
	public var done(get, never):Bool;
	public var mana:Mana;
	public var objectChanger:ObjectChanger;
	public var coords:Coordinates;
	var _done:Bool = false;

	public function new(mana:Mana, objectChanger:ObjectChanger, coords:Coordinates) {
		this.mana = mana;
		this.objectChanger = objectChanger;
		this.coords = coords;
	}

	public function get_done():Bool {
		return _done;
	}

	public function execute(worldMap:WorldMap, node:ActionedNode, deltaTime:Float) {
		// TODO: do something
		var isManaLoaded = objectChanger.elapsedLoadTime >= objectChanger.loadTime;
		if (isManaLoaded) {
			// TODO: launch power
			mana.level = 0;
			objectChanger.elapsedLoadTime = 0;
			_done = true;
		} else {
			objectChanger.elapsedLoadTime += deltaTime;
		}
	}
}
