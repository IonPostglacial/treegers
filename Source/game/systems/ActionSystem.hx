package game.systems;

import ash.tools.ListIteratingSystem;

import game.nodes.ActionedNode;

class ActionSystem extends ListIteratingSystem<ActionedNode>
{
	private var stage:GameStage;

	public function new(stage:GameStage)
	{
		this.stage = stage;
		super(ActionedNode, updateNode);
	}

	function updateNode(node:ActionedNode, deltaTime:Float):Void
	{
		var oldPosition = node.position;
		if (node.controled.currentOrder == null)
			return;
		node.speed.timeSinceLastMove += deltaTime;
		node.controled.currentOrder.execute(stage, node, deltaTime);
		if (node.controled.currentOrder.done)
		{
			node.controled.orders.pop();
			node.controled.oldPosition = oldPosition;
			node.speed.timeSinceLastMove = 0;
		}
	}
}
