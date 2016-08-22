/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package graph;

import haxe.ds.HashMap;
import de.polygonal.ds.Heap;
import de.polygonal.ds.Heapable;

class Node implements Heapable<Node>
{
    public var currentPosition:Position;
    public var previousPosition:Position;
    public var costSoFar:Int;
    public var estimatedCost:Int;
    public var position:Int;

    public function new(currentPosition:Position, previousPosition:Position, costSoFar:Int, heuristic:Int)
    {
        this.currentPosition = currentPosition;
        this.previousPosition = previousPosition;
        this.costSoFar = costSoFar;
        this.estimatedCost = costSoFar + heuristic;
    }

    public function compare(other:Node):Int
    {
        return other.estimatedCost - this.estimatedCost;
    }
}

class Path
{
    static inline function reconstructPath(nodes:HashMap<Position, Node>, start:Position, goal:Position):Array<Position>
    {
        var path = [];
        var currentPosition = goal;

        while (!currentPosition.equals(start))
        {
            path.push(currentPosition);
            currentPosition = nodes.get(currentPosition).previousPosition;
        }
        path.push(start);
        return path;
    }

    public static function between(start:Position, goal:Position, graph:Pathfindable):Array<Position>
    {
        var nodes = new HashMap<Position, Node>();
        var frontier = new Heap<Node>();
        var firstNode = new Node(start, null, 0, graph.distanceBetween(start, goal));

        nodes.set(start, firstNode);
        frontier.add(firstNode);

        while (!frontier.isEmpty())
        {
            var currentNode = frontier.pop();
            var currentPosition = currentNode.currentPosition;

            if (currentPosition.equals(goal))
                return reconstructPath(nodes, start, goal);
            for (neighbor in graph.neighborsOf(currentPosition))
            {
                var costToNeighbor = currentNode.costSoFar + graph.distanceBetween(currentPosition, neighbor);
                var heuristic = graph.distanceBetween(neighbor, goal);
                var previousEvaluation = nodes.get(neighbor);

                if (previousEvaluation == null || costToNeighbor < previousEvaluation.costSoFar)
                {
                    var neighborNode = new Node(neighbor, currentPosition, costToNeighbor, heuristic);

                    nodes.set(neighbor, neighborNode);
                    frontier.add(neighborNode);
                }
            }
        }
        return [];
    }
}