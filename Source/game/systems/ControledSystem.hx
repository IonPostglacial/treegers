package game.systems;

import openfl.geom.Rectangle;

import ash.tools.ListIteratingSystem;

import drawing.Shape;
import game.Conf;
import game.actions.Move;
import game.nodes.ControledNode;
import hex.Position;

enum Order
{
	MovementOrdered(goal:Position);
	PowerOrdered(goal:Position);
	TargetSelected(area:Rectangle);
}

class ControledSystem extends ListIteratingSystem<ControledNode>
{
	var stage:GameStage;
	var events:Array<Order>;

	public function new(stage:GameStage)
	{
		this.stage = stage;
		this.events = [];
		super(ControledNode, updateNode);
	}

	function updateNode(node:ControledNode, deltaTime:Float)
	{
		for (event in events)
		{
			switch (event)
			{
			case MovementOrdered(goal):
				if (node.controled.selected)
				{
					var path = graph.Path.find(stage.grid, node.position, goal);
					if (path != null)
					{
						node.controled.actions = [new Move(path)];
					}
				}
			case TargetSelected(area):
				node.controled.selected = area.containsPoint(Shape.positionToPoint(node.position, Conf.HEX_RADIUS));
			case PowerOrdered(goal): // TODO: implement it :p
			}
		}
	}
}
