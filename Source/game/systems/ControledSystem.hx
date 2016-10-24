package game.systems;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.Lib;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.actions.Move;
import game.components.Controled;
import game.components.Movement;
import game.components.Position;
import geometry.Hexagon;
import geometry.Coordinates;
import drawing.Shape;


enum Order {
	MovementOrdered(goal:Coordinates);
	PowerOrdered(goal:Coordinates);
	TargetSelected(position:Coordinates);
	GroupSelected(area:Rectangle);
}

class ControledNode extends Node<ControledNode> {
	public var controled:Controled;
	public var movement:Movement;
	public var position:Position;
}

class ControledSystem extends ListIteratingSystem<ControledNode> {
	var stage:Stage;
	var hover:Sprite;
	var events:Array<Order>;
	var pointedCoords:Coordinates;
	var pathfinders:Array<graph.Pathfinder<Coordinates>> = [];

	public function new(stage:Stage) {
		this.stage = stage;
		this.events = [];
		this.hover = new Sprite();
		this.hover.graphics.lineStyle(2, 0xFF0000);
		if (stage.map.orientation == tmx.Orientation.Hexagonal) {
			Shape.hexagon(this.hover.graphics, new Hexagon(0, 0, stage.map.hexSideLength));
		} else {
			this.hover.graphics.drawRect(0, 0, stage.map.tileWidth, stage.map.tileHeight);
		}
		this.stage.foreground.addChild(this.hover);
		Lib.current.addEventListener(MouseEvent.CLICK, function(e) {
			var mousePosition = stage.map.coordinates.fromPixel(new openfl.geom.Point(e.stageX, e.stageY));
			pointedCoords = mousePosition;
		});
		Lib.current.addEventListener(MouseEvent.MOUSE_MOVE, function(e) {
			var mousePosition = stage.map.coordinates.fromPixel(new openfl.geom.Point(e.stageX, e.stageY));
			var mousePoint = stage.map.coordinates.toPixel(mousePosition);
			this.hover.x = mousePoint.x;
			this.hover.y = mousePoint.y;
		});
		for (vehicle in Type.allEnums(Vehicle)) {
			var obstacles = new ObstacleGrid(stage.map.bgTiles, stage.map.grid, vehicle);
			this.pathfinders.push(new graph.Pathfinder(obstacles));
		}
		super(ControledNode, updateNode);
	}

	override function update(deltaTime:Float) {
		if (pointedCoords != null) {
			var targetSelected = false;
			for (node in nodeList) {
				if (node.position.equals(pointedCoords)) {
					targetSelected = true;
					break;
				}
			}
			if (targetSelected) {
				events.push(TargetSelected(pointedCoords.copy()));
			} else {
				events.push(MovementOrdered(pointedCoords.copy()));
			}
			pointedCoords = null;
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
			var newPath = [new Coordinates(node.position.x + tileType.dx(), node.position.y + tileType.dy()), node.position];
			node.controled.actions = [new Move(node.entity, newPath)];
		}
	}
}
