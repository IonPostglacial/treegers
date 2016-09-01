package game.orders;

import ash.core.Entity;

import game.components.Speed;
import game.nodes.ControledNode;

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

	public function take(stage:GameStage, node:ControledNode, deltaTime:Float):Bool
	{
		if (path.length > 0)
		{
			var newPosition = processMovement(node.speed, deltaTime);
			if (newPosition != null)
			{
				node.position.assign(newPosition);
			}
			return false;
		}
		else
		{
			return true;
		}
	}
}
