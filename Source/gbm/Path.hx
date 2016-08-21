/*
 * Copyright © 2016, Nicolas Galipot
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package gbm;

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
    static function getNeighbors(p:Position, isWalkable:Position->Bool):Array<Position>
    {
        var neighbors = [];
        for (dy in -1...2)
        {
            for (dx in -1...2)
            {
                var neighbor = new Position(p.x + dx, p.y + dy);
                if ((dx != 0 || dy != 0) && isWalkable(neighbor)
                    // crossing an obstacle in diagonal is forbidden
                    && isWalkable(new Position(p.x, p.y + dy))
                    && isWalkable(new Position(p.x + dx, p.y)))
                {
                    neighbors.push(neighbor);
                }
            }
        }
        return neighbors;
    }

    static function reconstructPath(nodes:HashMap<Position, Node>, start:Position, goal:Position):Array<Position>
    {
        var path = [];
        var currentPosition = goal;

        while (currentPosition.x != start.x || currentPosition.y != start.y)
        {
            path.push(currentPosition);
            currentPosition = nodes.get(currentPosition).previousPosition;
        }
        path.push(start);
        return path;
    }

    public static function shortestBetween(start:Position, goal:Position, distance:Position->Position->Int, isWalkable:Position->Bool):Array<Position>
    {
        var nodes = new HashMap<Position, Node>();
        var frontier = new Heap<Node>();
        var firstNode = new Node(start, null, 0, distance(start, goal));

        nodes.set(start, firstNode);
        frontier.add(firstNode);

        while (!frontier.isEmpty())
        {
            var currentNode = frontier.pop();
            var currentPosition = currentNode.currentPosition;

            if (currentPosition.x == goal.x && currentPosition.y == goal.y)
                return reconstructPath(nodes, start, goal);
            for (neighbor in getNeighbors(currentPosition, isWalkable))
            {
                var costToNeighbor = currentNode.costSoFar + distance(currentPosition, neighbor);
                var heuristic = distance(neighbor, goal);
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