package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.ControledNode;

class OrderSystem extends ListIteratingSystem<ControledNode>
{
	private var stage:GameStage;

	public function new(stage:GameStage)
	{
		this.stage = stage;
		super(ControledNode, updateNode);
	}

	function updateNode(node:ControledNode, deltaTime:Float):Void
	{
		var oldPosition = node.position;
		if (node.controled.currentOrder == null)
			return;
		node.speed.timeSinceLastMove += deltaTime;
		if (node.controled.currentOrder.take(stage, node, deltaTime))
		{
			node.controled.orders.pop();
			node.controled.oldPosition = oldPosition;
			node.speed.timeSinceLastMove = 0;
		}
	}
}
