package game.systems;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.Lib;

import ash.core.Entity;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.actions.Move;
import game.actions.UseMana;

import game.components.Controled;
import game.components.Mana;
import game.components.Movement;
import game.components.ObjectChanger;
import game.components.Position;

import game.map.GroundType;
import game.map.TargetObject;
import game.map.WorldMap;

import geometry.Coordinates;
import geometry.ICoordinatesSystem;
import geometry.Vector2D;


enum Order {
	Nothing;
	MovementOrdered(goal:Coordinates);
	PowerOrdered(target:TargetObject);
	TargetSelected(position:Coordinates);
	GroupSelected(area:Rectangle);
}

class ControledNode extends Node<ControledNode> {
	public var controled:Controled;
	public var movement:Movement;
	public var mana:Mana;
	public var objectChanger:ObjectChanger;
	public var position:Position;
}

class ControledSystem extends ListIteratingSystem<ControledNode> {
	var worldMap:WorldMap;
	var camera(default,null):openfl.geom.Rectangle;
	var hover:Sprite;
	var events:Array<Order>;
	var coordinates:ICoordinatesSystem;
	var pointedCoords:Coordinates;
	var pathfinders:Array<graph.Pathfinder<Coordinates>> = [];
	var potentialTargets:Iterable<TargetObject> = [];

	public function new(worldMap:WorldMap, coordinates:ICoordinatesSystem, camera:openfl.geom.Rectangle, hoverWidth:Int, hoverHeight:Int) {
		this.worldMap = worldMap;
		this.coordinates = coordinates;
		this.camera = camera;
		this.events = [];
		this.hover = new Sprite();
		this.hover.graphics.lineStyle(2, 0xFF0000);
		this.hover.graphics.drawRect(0, 0, hoverWidth, hoverHeight);
		openfl.Lib.current.addChild(this.hover);
		Lib.current.addEventListener(MouseEvent.CLICK, function(e) {
			var mousePosition = this.coordinates.fromPixel(new Vector2D(e.stageX + camera.x, e.stageY + camera.y));
			pointedCoords = mousePosition;
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

	function getOrder():Order {
		if (this.pointedCoords != null) {
			for (potentialTarget in this.potentialTargets) {
				if (potentialTarget.coords.equals(this.pointedCoords)) {
					return PowerOrdered(potentialTarget);
				}
			}
			for (node in this.nodeList) {
				if (node.position.equals(this.pointedCoords)) {
					return TargetSelected(this.pointedCoords.copy());
				}
			}
			return MovementOrdered(pointedCoords.copy());
		}
		return Nothing;
	}

	override function update(deltaTime:Float) {
		events.push(getOrder());
		super.update(deltaTime);
		events = [];
		this.pointedCoords = null;
	}

	function updatePotentialTargets(entity:Entity, componentClass:Class<Dynamic>) {
		if (componentClass == ObjectChanger) {
			var objectChanger = entity.get(ObjectChanger);
			if (objectChanger != null) { // addition
				this.potentialTargets = worldMap.allTargetsWithType(entity.get(componentClass).affectedTypes[0]);
			} else { // removal
				this.potentialTargets = [];
			}
		}
	}

	function updateNode(node:ControledNode, deltaTime:Float) {
		node.controled.selectedThisRound = false;
		for (event in events) {
			switch (event) {
			case Nothing: // Well... nothing to do !
			case MovementOrdered(goal):
				if (node.controled.selected) {
					var path = pathfinders[Type.enumIndex(node.movement.vehicle)].find(node.position, goal);
					node.controled.actions = [new Move(node.entity, path)];
				}
			case TargetSelected(position):
				node.controled.selected = !node.controled.selected && node.position.equals(position);
				if (node.controled.selected) {
					this.potentialTargets = worldMap.allTargetsWithType(node.objectChanger.affectedTypes[0]);
					node.entity.componentAdded.add(updatePotentialTargets);
					node.entity.componentRemoved.add(updatePotentialTargets);
				} else {
					this.potentialTargets = [];
					node.entity.componentAdded.remove(updatePotentialTargets);
					node.entity.componentRemoved.remove(updatePotentialTargets);
				}
				node.controled.selectedThisRound = true;
			case GroupSelected(area): // TODO: implement it :p
			case PowerOrdered(target):
				var groundGrid = this.worldMap.forVehicle(node.movement.vehicle);
				var nearestNeighbor = null;
				var smallestDistance = 0;
				for (neighbor in groundGrid.neighborsOf(target.coords)) {
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
				node.controled.actions = [new UseMana(node.mana, node.objectChanger, target), new Move(node.entity, path)];
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
