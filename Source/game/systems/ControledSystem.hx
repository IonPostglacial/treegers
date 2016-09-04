package game.systems;

import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.Lib;

import ash.tools.ListIteratingSystem;

import drawing.Shape;
import game.Conf;
import game.actions.Move;
import game.nodes.ControledNode;
import hex.Position;

enum Order {
	MovementOrdered(goal:Position);
	PowerOrdered(goal:Position);
	TargetSelected(position:Position);
	GroupSelected(area:Rectangle);
}

class ControledSystem extends ListIteratingSystem<ControledNode> {
	var stage:GameStage;
	var events:Array<Order>;

	public function new(stage:GameStage) {
		this.stage = stage;
		this.events = [];
		Lib.current.addEventListener(MouseEvent.CLICK, function(e) {
			var mousePosition = drawing.Shape.pointToPosition(new openfl.geom.Point(e.stageX, e.stageY), stage.grid.radius);
			this.events.push(TargetSelected(mousePosition));
		});
		Lib.current.addEventListener(MouseEvent.RIGHT_CLICK, function(e) {
			var mousePosition = drawing.Shape.pointToPosition(new openfl.geom.Point(e.stageX, e.stageY), stage.grid.radius);
			this.events.push(MovementOrdered(mousePosition));
		});
		super(ControledNode, updateNode);
	}

	override function update(deltaTime:Float) {
		super.update(deltaTime);
		events = [];
	}

	function updateNode(node:ControledNode, deltaTime:Float) {
		for (event in events) {
			switch (event) {
			case MovementOrdered(goal):
				if (node.controled.selected) {
					var path = graph.Path.find(stage.grid, node.position, goal);
					if (path != null) {
						node.controled.actions = [new Move(path)];
					}
				}
			case TargetSelected(position):
				node.controled.selected = node.position.equals(position);
			case GroupSelected(area): // TODO: implement it :p
			case PowerOrdered(goal): // TODO: implement it :p
			}
		}
	}
}
