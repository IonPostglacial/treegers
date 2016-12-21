package game.systems;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.Lib;

import ash.core.Entity;
import ash.tools.ListIteratingSystem;

import game.actions.Move;
import game.actions.UseMana;

import game.map.TargetObject;
import game.map.WorldMap;

import game.nodes.ControledNode;
import game.components.ObjectChanger;

import geometry.Coordinates;
import geometry.ICoordinatesSystem;
import geometry.Vector2D;


enum Order {
	Nothing;
	MovementOrdered(x:Int, y:Int);
	PowerOrdered(target:TargetObject);
	TargetSelected(x:Int, y:Int);
}

class ControledSystem extends ListIteratingSystem<ControledNode> {
	var worldMap:WorldMap;
	var camera(default,null):openfl.geom.Rectangle;
	var hover:Sprite;
	var targetSprites:Sprite;
	var currentOrder:Order = Nothing;
	var coordinates:ICoordinatesSystem;
	var pointedX:Int = -1;
	var pointedY:Int = -1;
	var hoverWidth:Int;
	var hoverHeight:Int;
	var pathfinders:Array<graph.CompressingPathfinder<Coordinates>> = [];
	var potentialTargets:Iterable<TargetObject> = [];

	public function new(worldMap:WorldMap, coordinates:ICoordinatesSystem, camera:openfl.geom.Rectangle, hoverWidth:Int, hoverHeight:Int) {
		this.worldMap = worldMap;
		this.coordinates = coordinates;
		this.camera = camera;
		this.hoverWidth = hoverWidth;
		this.hoverHeight = hoverHeight;
		this.hover = new Sprite();
		this.hover.graphics.lineStyle(2, 0xFFFFFF);
		this.hover.graphics.drawRect(0, 0, hoverWidth, hoverHeight);
		openfl.Lib.current.addChild(this.hover);
		this.targetSprites = new Sprite();
		openfl.Lib.current.addChild(this.targetSprites);
		Lib.current.addEventListener(MouseEvent.CLICK, function(e) {
			var mousePosition = this.coordinates.fromPixel(e.stageX + camera.x, e.stageY + camera.y);
			pointedX = mousePosition.x;
			pointedY = mousePosition.y;
		});
		Lib.current.addEventListener(MouseEvent.MOUSE_MOVE, function(e) {
			var mousePosition = this.coordinates.fromPixel(e.stageX + camera.x, e.stageY + camera.y);
			var mousePoint = this.coordinates.toPixel(mousePosition.x, mousePosition.y);
			this.hover.x = mousePoint.x;
			this.hover.y = mousePoint.y;
		});
		for (groundGrid in this.worldMap.grids) {
			this.pathfinders.push(new graph.CompressingPathfinder(groundGrid));
		}
		super(ControledNode, updateNode);
	}

	function getOrder():Order {
		if (this.pointedX >= 0 && this.pointedY >= 0) {
			for (potentialTarget in this.potentialTargets) {
				if (potentialTarget.x == this.pointedX && potentialTarget.y == this.pointedY) {
					return PowerOrdered(potentialTarget);
				}
			}
			for (node in this.nodeList) {
				if (node.position.x == this.pointedX && node.position.y == this.pointedY) {
					return TargetSelected(this.pointedX, this.pointedY);
				}
			}
			return MovementOrdered(this.pointedX, this.pointedY);
		}
		return Nothing;
	}

	override function update(deltaTime:Float) {
		this.currentOrder = getOrder();
		super.update(deltaTime);
		this.currentOrder = Nothing;
		this.pointedX = -1;
		this.pointedY = -1;
	}

	function createTargetSprites() {
		for (target in this.potentialTargets) {
			var targetPixPosition = this.coordinates.toPixel(target.x, target.y);
			var targetSprite = new Sprite();
			targetSprite.graphics.lineStyle(2, 0x6666ff);
			targetSprite.graphics.drawRoundRect(0, 0, hoverWidth, hoverHeight, 8);
			targetSprite.x = targetPixPosition.x;
			targetSprite.y = targetPixPosition.y;
			this.targetSprites.addChild(targetSprite);
		}
	}

	function updatePotentialTargets(entity:Entity, componentClass:Class<Dynamic>) {
		if (componentClass == ObjectChanger) {
			var objectChanger = entity.get(ObjectChanger);
			if (objectChanger != null) { // addition
				this.potentialTargets = worldMap.allTargetsWithType(entity.get(componentClass).affectedTypes[0]);
				createTargetSprites();
			} else { // removal
				this.potentialTargets = [];
				this.targetSprites.removeChildren();
			}
		}
	}

	function updateNode(node:ControledNode, deltaTime:Float) {
		node.controled.selectedThisRound = false;
		switch (this.currentOrder) {
		case MovementOrdered(x, y):
			if (node.controled.selected) {
				var nextCoords = new Coordinates(node.position.x + node.movement.direction.dx(), node.position.y + node.movement.direction.dy());
				var path = pathfinders[Type.enumIndex(node.movement.vehicle)].find(nextCoords, new Coordinates(x, y));
				node.controled.actions = [new Move(node.entity, path)];
			}
		case TargetSelected(x, y):
			node.controled.selected = node.position.x == x && node.position.y == y && !node.controled.selected;
			node.controled.selectedThisRound = true;
			if (node.controled.selected) {
				this.potentialTargets = worldMap.allTargetsWithType(node.objectChanger.affectedTypes[0]);
				createTargetSprites();
				node.entity.componentAdded.add(updatePotentialTargets);
				node.entity.componentRemoved.add(updatePotentialTargets);
			} else {
				this.potentialTargets = [];
				this.targetSprites.removeChildren();
				node.entity.componentAdded.remove(updatePotentialTargets);
				node.entity.componentRemoved.remove(updatePotentialTargets);
			}
		case PowerOrdered(target):
			var groundGrid = this.worldMap.forVehicle(node.movement.vehicle);
			var nearestNeighbor = null;
			var smallestDistance = 0;
			for (neighbor in groundGrid.neighborsOf(new Coordinates(target.x, target.y))) {
				var neighborDistance = groundGrid.distanceBetween(node.position.coords(), neighbor);
				if (nearestNeighbor == null || neighborDistance < smallestDistance) {
					nearestNeighbor = neighbor;
					smallestDistance = neighborDistance;
				}
			}
			var path:Array<Coordinates>;
			if (nearestNeighbor != null) {
				path = pathfinders[Type.enumIndex(node.movement.vehicle)].find(node.position.coords(), nearestNeighbor);
				if (path.length != 0 || smallestDistance == 0) {
					node.controled.actions = [new UseMana(node.mana, node.objectChanger, target), new Move(node.entity, path)];
				}
			}
		case Nothing: // Nothing to do.
		}
	}
}
