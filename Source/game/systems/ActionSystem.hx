package game.systems;

import ash.tools.ListIteratingSystem;
import game.actions.Move;
import game.nodes.ActionedNode;
import game.map.GroundType;
import game.map.WorldMap;
import grid.Coordinates;
import grid.Direction;
import game.components.PathWalker;


class ActionSystem extends ListIteratingSystem<ActionedNode> {
	var worldMap:WorldMap;

	public function new(worldMap:WorldMap) {
		this.worldMap = worldMap;
		super(ActionedNode, updateNode);
	}

	function updateNode(node:ActionedNode, deltaTime:Float) {
		var currentAction = node.controled.actions[node.controled.actions.length - 1];
		if (currentAction == null) {
			return;
		}
		currentAction.execute(this.worldMap, node, deltaTime);
		if (currentAction.done) {
			node.controled.actions.pop();
		}
		switch (this.worldMap.at(node.position.x, node.position.y)) {
		case GroundType.Arrow(dx, dy):
			node.movement.direction = Direction.fromVect(dx, dy);
			node.movement.alreadyMoved = false;
			var newPath = [new Coordinates(node.position.x + dx, node.position.y + dy)];
			node.controled.actions = [new Move(node.entity, newPath)];
		default: // pass
		}
	}
}
