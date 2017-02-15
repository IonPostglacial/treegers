package game;

import game.map.TargetObject;


interface ITargetListListener {
	function targetListChanged(targets:Iterable<TargetObject>):Void;
}
