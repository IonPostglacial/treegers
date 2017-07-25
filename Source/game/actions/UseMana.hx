package game.actions;

import grid.Coordinates;
import game.nodes.ActionedNode;
import game.components.Mana;
import game.components.ObjectChanger;
import game.map.WorldMap;
import game.map.TargetObject;


class UseMana implements IAction {
	public var done(get, never):Bool;
	public var mana:Mana;
	public var objectChanger:ObjectChanger;
	public var target:TargetObject;
	var _done:Bool = false;


	public function new(mana:Mana, objectChanger:ObjectChanger,target:TargetObject) {
		this.mana = mana;
		this.objectChanger = objectChanger;
		this.target = target;
	}

	public function get_done():Bool {
		return _done;
	}

	public function execute(worldMap:WorldMap, node:ActionedNode, deltaTime:Float) {
		var isManaLoaded = objectChanger.elapsedLoadTime >= objectChanger.loadTime;
		if (isManaLoaded) {
			worldMap.setTargetStatus(target, !target.isActive);
			mana.level = 0;
			objectChanger.elapsedLoadTime = 0;
			_done = true;
		} else {
			objectChanger.elapsedLoadTime += deltaTime;
		}
	}
}
