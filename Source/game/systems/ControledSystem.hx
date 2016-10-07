package game.systems;

import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.Lib;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.actions.Move;
import game.components.Controled;
import game.components.Movement;
import game.components.Position;
import game.pixelutils.Shape;


enum Order {
	MovementOrdered(goal:Position);
	PowerOrdered(goal:Position);
	TargetSelected(position:Position);
	GroupSelected(area:Rectangle);
}

class ControledNode extends Node<ControledNode> {
	public var controled:Controled;
	public var movement:Movement;
	public var position:Position;
}

class ControledSystem extends ListIteratingSystem<ControledNode> {
	var stage:Stage;
	var events:Array<Order>;
	var pointedPosition:Position;
	var pathfinders:Array<graph.Pathfinder<Position>> = [];

	public function new(stage:Stage) {
		this.stage = stage;
		this.events = [];
		Lib.current.addEventListener(MouseEvent.CLICK, function(e) {
			var mousePosition = stage.coords.pointToPosition(new openfl.geom.Point(e.stageX, e.stageY));
			pointedPosition = mousePosition;
		});
		for (vehicle in Type.allEnums(Vehicle)) {
			var obstacles = new ObstacleGrid(stage.map, vehicle);
			this.pathfinders.push(new graph.Pathfinder(obstacles));
		}
		super(ControledNode, updateNode);
	}

	override function update(deltaTime:Float) {
		if (pointedPosition != null) {
			var targetSelected = false;
			for (node in nodeList) {
				if (node.position.equals(pointedPosition)) {
					targetSelected = true;
					break;
				}
			}
			if (targetSelected) {
				events.push(TargetSelected(pointedPosition.copy()));
			} else {
				events.push(MovementOrdered(pointedPosition.copy()));
			}
			pointedPosition = null;
		}
		super.update(deltaTime);
		events = [];
	}

	function updateNode(node:ControledNode, deltaTime:Float) {
		for (event in events) {
			switch (event) {
			case MovementOrdered(goal):
				if (node.controled.selected) {
					var path = pathfinders[Type.enumIndex(node.movement.vehicle)].find(node.position, goal);
					node.controled.actions = [new Move(node.entity, path)];
				}
			case TargetSelected(position):
				node.controled.selected = !node.controled.selected && node.position.equals(position);
			case GroupSelected(area): // TODO: implement it :p
			case PowerOrdered(goal): // TODO: implement it :p
			}
		}
		var tileType = stage.tileAt(node.position);
		if (tileType.isArrow()) {
			var newPath = [new Position(node.position.x + tileType.dx(), node.position.y + tileType.dy()), node.position];
			node.controled.actions = [new Move(node.entity, newPath)];
		}
	}
}
