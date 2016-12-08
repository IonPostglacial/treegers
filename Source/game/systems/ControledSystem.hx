package game.systems;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.Lib;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.actions.Move;
import game.actions.UseMana;

import game.components.Controled;
import game.components.Mana;
import game.components.Movement;
import game.components.Position;

import game.map.WorldMap;
import game.map.GroundType;

import geometry.Coordinates;
import geometry.ICoordinatesSystem;
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
	public var mana:Mana;
	public var position:Position;
}

class ControledSystem extends ListIteratingSystem<ControledNode> {
	var worldMap:WorldMap;
	var camera(default,null):openfl.geom.Rectangle;
	var hover:Sprite;
	var events:Array<Order>;
	var coordinates:ICoordinatesSystem;
	var pointedCoords:Coordinates;
	var manaCoords:Coordinates;
	var pathfinders:Array<graph.Pathfinder<Coordinates>> = [];
	static var SCROLL_MARGIN = 64;
	static var SCROLL_SPEED = 8;

	public function new(worldMap:WorldMap, coordinates:ICoordinatesSystem, width:Int, height:Int, hoverWidth:Int, hoverHeight:Int) {
		this.worldMap = worldMap;
		this.coordinates = coordinates;
		openfl.Lib.current.scrollRect = new openfl.geom.Rectangle(0, 0, width, height);
		this.camera = openfl.Lib.current.scrollRect;
		this.events = [];
		this.hover = new Sprite();
		this.hover.graphics.lineStyle(2, 0xFF0000);
		this.hover.graphics.drawRect(0, 0, hoverWidth, hoverHeight);
		openfl.Lib.current.addChild(this.hover);
		Lib.current.addEventListener(MouseEvent.CLICK, function(e) {
			var mousePosition = this.coordinates.fromPixel(new Vector2D(e.stageX + camera.x, e.stageY + camera.y));
			pointedCoords = mousePosition;
		});
		Lib.current.addEventListener(MouseEvent.RIGHT_CLICK, function(e) {
			var mousePosition = this.coordinates.fromPixel(new Vector2D(e.stageX + camera.x, e.stageY + camera.y));
			manaCoords = mousePosition;
		});
		Lib.current.addEventListener(MouseEvent.MOUSE_MOVE, function(e) {
			var mousePosition = this.coordinates.fromPixel(new Vector2D(e.stageX + camera.x, e.stageY + camera.y));
			var mousePoint = this.coordinates.toPixel(mousePosition);
			this.hover.x = mousePoint.x;
			this.hover.y = mousePoint.y;
		});
		for (groundGrid in this.worldMap.grids) {
			this.pathfinders.push(new graph.Pathfinder(groundGrid));
		}
		super(ControledNode, updateNode);
	}

	function updateCamera(deltaTime:Float) {
		var relativeX = Lib.current.mouseX - camera.x;
		var relativeY = Lib.current.mouseY - camera.y;
		var maxX = Lib.current.width - camera.width;
		var maxY = Lib.current.height - camera.height;

		if (relativeX < SCROLL_MARGIN) {
			camera.x = Math.max(camera.x - SCROLL_SPEED, 0);
		}
		if (relativeX > camera.width - SCROLL_MARGIN) {
			camera.x = Math.min(camera.x + SCROLL_SPEED, maxX);
		}
		if (relativeY < SCROLL_MARGIN) {
			camera.y = Math.max(camera.y - SCROLL_SPEED, 0);
		}
		if (relativeY > camera.height - SCROLL_MARGIN) {
			camera.y = Math.min(camera.y + SCROLL_SPEED, maxY);
		}
		Lib.current.scrollRect = camera;
	}

	override function update(deltaTime:Float) {
		updateCamera(deltaTime);
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
		if (manaCoords != null) {
			events.push(PowerOrdered(manaCoords.copy()));
			manaCoords = null;
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
			case PowerOrdered(goal): // TODO: implement it properly :p
				var groundGrid = this.worldMap.forVehicle(node.movement.vehicle);
				var nearestNeighbor = null;
				var smallestDistance = 0;
				for (neighbor in groundGrid.neighborsOf(goal)) {
					var neighborDistance = groundGrid.distanceBetween(node.position, neighbor);
					if (nearestNeighbor == null || neighborDistance < smallestDistance) {
						nearestNeighbor = neighbor;
						smallestDistance = neighborDistance;
					}
				}
				if (nearestNeighbor == null) {
					break; // the loop
				}
				var path = pathfinders[Type.enumIndex(node.movement.vehicle)].find(node.position, nearestNeighbor);
				if (path.length == 0 && smallestDistance > 0) {
					break; // the loop
				}
				node.controled.actions = [new UseMana(node.mana, goal), new Move(node.entity, path)];
			}
		}
		switch (this.worldMap.at(node.position)) {
		case GroundType.Arrow(dx, dy):
			var newPath = [new Coordinates(node.position.x + dx, node.position.y + dy), node.position];
			node.controled.actions = [new Move(node.entity, newPath)];
		default: // pass
		}
	}
}
