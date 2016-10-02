/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package graph;


/*
 * The Pathfindable interface shoudl be implemented by classes representing graphs on which we want to perform pathfinding.
 */
interface Pathfindable<T> {
	public function neighborsOf(position:T):Iterable<T>;
	public function distanceBetween(start:T, goal:T):Int;
}
