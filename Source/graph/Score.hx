package graph;

/*
 * The goal of the Score class is to store the costs associated with a Node:
 * - costSoFar is the cost to go to currentNode following the currently examined path
 * - estimatedCost is the estimated cost to go to the goal node following the currently examined path, considering no obstacles will be encountered.
 */
class Score<Node_t:INode<Node_t>> {
	public var currentNode:Node_t;
	public var previousNode:Node_t;
	public var costSoFar:Int;
	public var estimatedCost:Int;

	public function new(currentNode, previousNode, costSoFar, heuristic) {
		this.currentNode = currentNode;
		this.previousNode = previousNode;
		this.costSoFar = costSoFar;
		this.estimatedCost = costSoFar + heuristic;
	}
}
