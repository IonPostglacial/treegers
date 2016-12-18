package graph;

import geometry.Direction;


typedef CompressibleNode<T> = {
	function equals(other:T):Bool;
    function direction(other:T):Int;
}

@:generic
class CompressingPathfinder<T:CompressibleNode<T>> extends Pathfinder<T> {

	public function new(graph) {
		super(graph);
	}

	override function reconstructPath(nodes:Map<Int, Score<T>>, start:T, goal:T):Array<T> {
		var path = [];
		var currentNode = goal;
		var currentDirection = Direction.None;

		while (!currentNode.equals(start)) {
			var nextNode = nodes.get(graph.nodeIndex(currentNode)).previousNode;
			var nextDirection = currentNode.direction(nextNode);
			if (currentDirection != nextDirection) {
				path.push(currentNode);
				currentDirection = nextDirection;
			}
			currentNode = nextNode;
		}
		return path;
	}
}
