package orders;

import ash.core.Entity;
import components.Speed;

class Move implements Order {
	var path:Array<hex.Position>;

	public function new(path)
	{
		this.path = path;
	}

	function processMovement(speed:Speed, time:Float):Null<hex.Position>
	{
		var updatedPosition:Null<hex.Position> = null;

		if (speed.timeSinceLastMove >= speed.period)
		{
			updatedPosition = path.pop();
			speed.timeSinceLastMove -= speed.period;
		}
		return updatedPosition;
	}

	public function take(stage:GameStage, entity:Entity, deltaTime:Float):Bool
	{
		if (path.length > 0)
		{
			var newPosition = processMovement(entity.get(Speed), deltaTime);
			if (newPosition != null)
			{
				entity.add(newPosition);
			}
			return false;
		}
		else
		{
			return true;
		}
	}
}
