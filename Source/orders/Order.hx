package orders;

import ash.core.Entity;

interface Order
{
	function take(stage:GameStage, entity:Entity, deltaTime:Float):Bool;
}
