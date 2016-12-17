package graph;


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
        var oldNode = currentNode;
        var currentDirection = 0;
        var pastDirection = 1; // anything != currentDirection

		while (!currentNode.equals(start)) {
            if (currentDirection != pastDirection) {
    			path.push(currentNode);
                pastDirection = currentDirection;
            }
            oldNode = currentNode;
			currentNode = nodes.get(graph.nodeIndex(currentNode)).previousNode;
            currentDirection = currentNode.direction(oldNode);
		}
		path.push(start);
		return path;
	}
}
