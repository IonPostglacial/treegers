/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package graph;

import haxe.ds.HashMap;
import de.polygonal.ds.Heap;
import de.polygonal.ds.Heapable;


typedef Node<T> = {
	function equals(other:T):Bool;
	function hashCode():Int;
}

/*
 * The goal of the Score class is to store the costs associated with a Node:
 * - costSoFar is the cost to go to currentNode following the currently examined path
 * - estimatedCost is the estimated cost to go to the goal node following the currently examined path, considering no obstacles will be encountered.
 */
private class Score<Node_t:Node<Node_t>> implements Heapable<Score<Node_t>> {
	public var currentNode:Node_t;
	public var previousNode:Node_t;
	public var costSoFar:Int;
	public var estimatedCost:Int;
	public var position:Int;

	public function new(currentNode, previousNode, costSoFar, heuristic) {
		this.currentNode = currentNode;
		this.previousNode = previousNode;
		this.costSoFar = costSoFar;
		this.estimatedCost = costSoFar + heuristic;
	}

	public function compare(other:Score<Node_t>):Int {
		return other.estimatedCost - this.estimatedCost;
	}
}

/*
 * A Pathfinding object can be used to find the shortest path in a graph.
 * A graph is a class implementing interface Pathfindable.
 * The Pathfinding class and the Pathfindable interface are generic, their type parameter is the type of the nodes of the graph.
 * Nodes must be comparable by equality and they must provide a hashCode function.
 * It returns an Array containing every nodes composing the calculated path, starting node and ending node included.
 */
@:generic
class Pathfinder<Node_t:Node<Node_t>> {
	var graph:Pathfindable<Node_t>;

	public function new(graph) {
		this.graph = graph;
	}

	inline function reconstructPath(nodes:HashMap<Node_t, Score<Node_t>>, start:Node_t, goal:Node_t):Array<Node_t> {
		var path = [];
		var currentNode = goal;

		while (!currentNode.equals(start)) {
			path.push(currentNode);
			currentNode = nodes.get(currentNode).previousNode;
		}
		path.push(start);
		return path;
	}

	public function find(start:Node_t, goal:Node_t):Array<Node_t> {
		var scores = new HashMap<Node_t, Score<Node_t>>();
		var frontier = new Heap<Score<Node_t>>();
		var firstScore = new Score(start, null, 0, graph.distanceBetween(start, goal));

		scores.set(start, firstScore);
		frontier.add(firstScore);

		while (!frontier.isEmpty()) {
			var currentScore = frontier.pop();
			var currentNode = currentScore.currentNode;

			if (currentNode.equals(goal)) {
				return reconstructPath(scores, start, goal);
			}
			for (neighbor in graph.neighborsOf(currentNode)) {
				var costToNeighbor = currentScore.costSoFar + graph.distanceBetween(currentNode, neighbor);
				var heuristic = graph.distanceBetween(neighbor, goal);
				var previousEvaluation = scores.get(neighbor);

				if (previousEvaluation == null || costToNeighbor < previousEvaluation.costSoFar) {
					var neighborScore = new Score(neighbor, currentNode, costToNeighbor, heuristic);

					scores.set(neighbor, neighborScore);
					frontier.add(neighborScore);
				}
			}
		}
		return [];
	}
}
