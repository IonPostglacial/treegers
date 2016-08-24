/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package graph;

import haxe.ds.HashMap;
import de.polygonal.ds.Heap;
import de.polygonal.ds.Heapable;

class Node<T> implements Heapable<Node<T>>
{
	public var currentStep:T;
	public var previousStep:T;
	public var costSoFar:Int;
	public var estimatedCost:Int;
	public var position:Int;

	public function new(currentStep:T, previousStep:T, costSoFar:Int, heuristic:Int)
	{
		this.currentStep = currentStep;
		this.previousStep = previousStep;
		this.costSoFar = costSoFar;
		this.estimatedCost = costSoFar + heuristic;
	}

	public function compare(other:Node<T>):Int
	{
		return other.estimatedCost - this.estimatedCost;
	}
}

class Path
{
	static inline function reconstructPath<P:Step<P>>(nodes:HashMap<P, Node<P>>, start:P, goal:P):Array<P>
	{
		var path = [];
		var currentStep = goal;

		while (!currentStep.equals(start))
		{
			path.push(currentStep);
			currentStep = nodes.get(currentStep).previousStep;
		}
		path.push(start);
		return path;
	}

	public static function find<P:Step<P>>(graph:Pathfindable<P>, start:P, goal:P):Array<P>
	{
		var nodes = new HashMap<P, Node<P>>();
		var frontier = new Heap<Node<P>>();
		var firstNode = new Node(start, null, 0, graph.distanceBetween(start, goal));

		nodes.set(start, firstNode);
		frontier.add(firstNode);

		while (!frontier.isEmpty())
		{
			var currentNode = frontier.pop();
			var currentStep = currentNode.currentStep;

			if (currentStep.equals(goal))
				return reconstructPath(nodes, start, goal);
			for (neighbor in graph.neighborsOf(currentStep))
			{
				var costToNeighbor = currentNode.costSoFar + graph.distanceBetween(currentStep, neighbor);
				var heuristic = graph.distanceBetween(neighbor, goal);
				var previousEvaluation = nodes.get(neighbor);

				if (previousEvaluation == null || costToNeighbor < previousEvaluation.costSoFar)
				{
					var neighborNode = new Node(neighbor, currentStep, costToNeighbor, heuristic);

					nodes.set(neighbor, neighborNode);
					frontier.add(neighborNode);
				}
			}
		}
		return [];
	}
}
