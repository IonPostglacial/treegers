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

import game.mapmanagement.GroundType;

import geometry.Coordinates;
import geometry.Vector2D;


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
	static var SCROLL_MARGIN = 64;
	static var SCROLL_SPEED = 8;

	public function new(stage:Stage) {
		this.stage = stage;
		this.events = [];
		this.hover = new Sprite();
		this.hover.graphics.lineStyle(2, 0xFF0000);
		this.hover.graphics.drawRect(0, 0, stage.map.effectiveTileWidth, stage.map.effectiveTileHeight);
		this.stage.foreground.addChild(this.hover);
		Lib.current.addEventListener(MouseEvent.CLICK, function(e) {
			var mousePosition = stage.map.coordinates.fromPixel(new Vector2D(e.stageX + stage.camera.x, e.stageY + stage.camera.y));
			pointedCoords = mousePosition;
		});
		Lib.current.addEventListener(MouseEvent.MOUSE_MOVE, function(e) {
			var mousePosition = stage.map.coordinates.fromPixel(new Vector2D(e.stageX + stage.camera.x, e.stageY + stage.camera.y));
			var mousePoint = stage.map.coordinates.toPixel(mousePosition);
			this.hover.x = mousePoint.x;
			this.hover.y = mousePoint.y;
		});
		for (groundGrid in stage.ground.grids) {
			this.pathfinders.push(new graph.Pathfinder(groundGrid));
		}
		super(ControledNode, updateNode);
	}

	override function update(deltaTime:Float) {
		var relativeX = Lib.current.mouseX - stage.camera.x;
		var relativeY = Lib.current.mouseY - stage.camera.y;
		var maxX = Lib.current.width - stage.camera.width;
		var maxY = Lib.current.height - stage.camera.height;

		if (relativeX < SCROLL_MARGIN) {
			stage.camera.x = Math.max(stage.camera.x - SCROLL_SPEED, 0);
		}
		if (relativeX > stage.camera.width - SCROLL_MARGIN) {
			stage.camera.x = Math.min(stage.camera.x + SCROLL_SPEED, maxX);
		}
		if (relativeY < SCROLL_MARGIN) {
			stage.camera.y = Math.max(stage.camera.y - SCROLL_SPEED, 0);
		}
		if (relativeY > stage.camera.height - SCROLL_MARGIN) {
			stage.camera.y = Math.min(stage.camera.y + SCROLL_SPEED, maxY);
		}
		Lib.current.scrollRect = stage.camera;
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
		node.controled.selectedThisRound = false;
		for (event in events) {
			switch (event) {
			case MovementOrdered(goal):
				if (node.controled.selected) {
					var path = pathfinders[Type.enumIndex(node.movement.vehicle)].find(node.position, goal);
					node.controled.actions = [new Move(node.entity, path)];
				}
			case TargetSelected(position):
				node.controled.selected = !node.controled.selected && node.position.equals(position);
				node.controled.selectedThisRound = true;
			case GroupSelected(area): // TODO: implement it :p
			case PowerOrdered(goal): // TODO: implement it :p
			}
		}
		switch (stage.ground.forVehicle(node.movement.vehicle).at(node.position)) {
		case GroundType.Arrow(dx, dy):
			var newPath = [new Coordinates(node.position.x + dx, node.position.y + dy), node.position];
			node.controled.actions = [new Move(node.entity, newPath)];
		default: // pass
		}
	}
}
