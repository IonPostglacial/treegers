/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package graph;

import haxe.ds.HashMap;
import de.polygonal.ds.Heap;
import de.polygonal.ds.Heapable;

@:generic
typedef Node<T> = {
	function equals(other:T):Bool;
	function hashCode():Int;
}

class Score<Node_t:Node<Node_t>> implements Heapable<Score<Node_t>> {
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

interface Findable<T> {
	public function neighborsOf(position:T):Iterable<T>;
	public function distanceBetween(start:T, goal:T):Int;
}

class Path {
	@:generic
	static inline function reconstructPath<Node_t:Node<Node_t>>(nodes:HashMap<Node_t, Score<Node_t>>, start:Node_t, goal:Node_t):Array<Node_t> {
		var path = [];
		var currentNode = goal;

		while (!currentNode.equals(start)) {
			path.push(currentNode);
			currentNode = nodes.get(currentNode).previousNode;
		}
		path.push(start);
		return path;
	}

	@:generic
	public static function find<Node_t:Node<Node_t>>(graph:Findable<Node_t>, start:Node_t, goal:Node_t):Array<Node_t> {
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
