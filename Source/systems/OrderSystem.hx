package systems;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import components.Controled;
import components.Speed;
import hex.Position;

class OrderNode extends Node<OrderNode>
{
	public var controled:Controled;
	public var position:Position;
	public var speed:Speed;
}

class OrderSystem extends ListIteratingSystem<OrderNode>
{
	private var stage:GameStage;

	public function new(stage:GameStage)
	{
		this.stage = stage;
		super(OrderNode, updateNode);
	}

	function updateNode(node:OrderNode, deltaTime:Float):Void
	{
		var oldPosition = node.position;
		if (node.controled.currentOrder == null)
			return;
		node.speed.timeSinceLastMove += deltaTime;
		if (node.controled.currentOrder.take(stage, node.entity, deltaTime))
		{
			node.controled.orders.pop();
			node.controled.oldPosition = oldPosition;
			node.speed.timeSinceLastMove = 0;
		}
	}
}
