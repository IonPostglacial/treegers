package game.systems;

import openfl.display.Sprite;
import openfl.geom.Rectangle;

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


class ControledSystem extends ListIteratingSystem<ControledNode> {
	var targetBlinkElapsedTime:Float = 0;
	var targetBlinkPeriod:Float = 1;
	var worldMap:WorldMap;
	var camera:openfl.geom.Rectangle;
	var orderBoard:Order.Board;
	var targetSprites:Sprite;
	var coordinates:ICoordinatesSystem;
	var hoverWidth:Int;
	var hoverHeight:Int;
	var pathfinders:Array<graph.CompressingPathfinder<Coordinates>> = [];
	var potentialTargets:Iterable<TargetObject> = [];

	public function new(worldMap:WorldMap, orderBoard:Order.Board, coordinates:ICoordinatesSystem, camera:openfl.geom.Rectangle, hoverWidth:Int, hoverHeight:Int) {
		this.worldMap = worldMap;
		this.coordinates = coordinates;
		this.camera = camera;
		this.orderBoard = orderBoard;
		this.hoverWidth = hoverWidth;
		this.hoverHeight = hoverHeight;
		this.targetSprites = new Sprite();
		openfl.Lib.current.addChild(this.targetSprites);
		for (groundGrid in this.worldMap.grids) {
			this.pathfinders.push(new graph.CompressingPathfinder(groundGrid));
		}
		super(ControledNode, updateNode);
	}

	function getOrder():Order {
		if (this.orderBoard.mouseClicked) {
			for (potentialTarget in this.potentialTargets) {
				if (potentialTarget.x == this.orderBoard.mousePositionX && potentialTarget.y == this.orderBoard.mousePositionY) {
					return PowerOrdered(potentialTarget);
				}
			}
			for (node in this.nodeList) {
				if (node.position.x == this.orderBoard.mousePositionX && node.position.y == this.orderBoard.mousePositionY) {
					return TargetSelected(this.orderBoard.mousePositionX, this.orderBoard.mousePositionY);
				}
			}
			return MovementOrdered(this.orderBoard.mousePositionX, this.orderBoard.mousePositionY);
		}
		return Nothing;
	}

	override function update(deltaTime:Float) {
		if (this.targetSprites.numChildren > 0) {
			this.targetBlinkElapsedTime += deltaTime;
			if (this.targetBlinkElapsedTime >= this.targetBlinkPeriod) {
				this.targetBlinkElapsedTime -= this.targetBlinkPeriod;
			}
			this.targetSprites.alpha = this.targetBlinkElapsedTime / this.targetBlinkPeriod;
		}
		this.orderBoard.currentOrder = getOrder();
		super.update(deltaTime);
	}

	function createTargetSprites() {
		for (target in this.potentialTargets) {
			var targetPixPosition = this.coordinates.toPixel(target.x, target.y);
			var targetSprite = new Sprite();
			targetSprite.graphics.lineStyle(2, 0x0077ff);
			targetSprite.graphics.drawRoundRect(0, 0, hoverWidth, hoverHeight, hoverWidth);
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
		switch (this.orderBoard.currentOrder) {
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
			if (nearestNeighbor != null) {
				var path = pathfinders[Type.enumIndex(node.movement.vehicle)].find(node.position.coords(), nearestNeighbor);
				if (path.length != 0 || smallestDistance == 0) {
					node.controled.actions = [new UseMana(node.mana, node.objectChanger, target), new Move(node.entity, path)];
				}
			}
		case Nothing: // Nothing to do.
		}
	}
}
