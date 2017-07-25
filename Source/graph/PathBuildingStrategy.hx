package graph;


typedef Type<T:INode<T>> = IPathfindable<T> -> Map<Int, Score<T>> -> T -> T -> Array<T>;

typedef CompressibleNode<T> = {
	function equals(other:T):Bool;
    function direction(other:T):Int;
}

@:publicFields
class PathBuildingStrategy {
	static function simple<Node_t:INode<Node_t>>(graph:IPathfindable<Node_t>, nodes:Map<Int, Score<Node_t>>, start:Node_t, goal:Node_t):Array<Node_t> {
		var path = [];
        var currentNode = goal;

        while (!currentNode.equals(start)) {
            path.push(currentNode);
            currentNode = nodes.get(graph.nodeIndex(currentNode)).previousNode;
        }
        return path;
	}

	static function compressed<Node_t:CompressibleNode<Node_t>>(graph:IPathfindable<Node_t>, nodes:Map<Int, Score<Node_t>>, start:Node_t, goal:Node_t):Array<Node_t> {
		var path = [];
        var currentNode = goal;
        var currentDirection = 0;

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
