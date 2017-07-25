/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package graph;

/*
 * A Pathfinding object can be used to find the shortest path in a graph.
 * A graph is a class implementing interface IPathfindable.
 * The Pathfinding class and the IPathfindable interface are generic, their type parameter is the type of the nodes of the graph.
 * Nodes must be comparable by equality and they must provide a hashCode function.
 * It returns an Array containing every nodes composing the calculated path, starting node and ending node included.
 */
@:generic
class Pathfinder<Node_t:INode<Node_t>> {
	var graph:IPathfindable<Node_t>;
	var reconstructPath:PathBuildingStrategy.Type<Node_t>;
	function compareScore(s1, s2) return s2.estimatedCost - s1.estimatedCost;

	public function new(graph, pathBuildingStrategy) {
		this.graph = graph;
		this.reconstructPath = pathBuildingStrategy;
	}

	public function find(start:Node_t, goal:Node_t):Array<Node_t> {
		var scores = new Map<Int, Score<Node_t>>();
		var frontier = [];
		var firstScore = new Score(start, null, 0, graph.distanceBetween(start, goal));

		scores.set(graph.nodeIndex(start), firstScore);
		frontier.push(firstScore);

		while (frontier.length > 0) {
			var currentScore = frontier.pop();
			var currentNode = currentScore.currentNode;

			if (currentNode.equals(goal)) {
				return reconstructPath(graph, scores, start, goal);
			}
			for (neighbor in graph.neighborsOf(currentNode)) {
				var costToNeighbor = currentScore.costSoFar + graph.distanceBetween(currentNode, neighbor);
				var heuristic = graph.distanceBetween(neighbor, goal);
				var neighborIndex = graph.nodeIndex(neighbor);
				var previousEvaluation = scores.get(neighborIndex);

				if (previousEvaluation == null || costToNeighbor < previousEvaluation.costSoFar) {
					var neighborScore = new Score(neighbor, currentNode, costToNeighbor, heuristic);
					scores.set(neighborIndex, neighborScore);
					frontier.push(neighborScore);
					frontier.sort(compareScore);
				}
			}
		}
		return [];
	}
}
