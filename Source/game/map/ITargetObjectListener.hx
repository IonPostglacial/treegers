package game.map;

interface ITargetObjectListener {
	function targetObjectStatusChanged(target:TargetObject, active:Bool):Void;
}
