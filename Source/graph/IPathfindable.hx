/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package graph;


/*
 * The IPathfindable interface should be implemented by classes representing graphs on which we want to perform pathfinding.
 */
interface IPathfindable<T> {
	function nodeIndex(node:T):Int;
	function areNeighbors(p1:T, p2:T):Bool;
	function neighborsOf(position:T):Iterator<T>;
	function distanceBetween(start:T, goal:T):Int;
}
