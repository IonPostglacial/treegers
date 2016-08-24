/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package graph;

interface Pathfindable<T>
{
	public function neighborsOf(position:T):Iterable<T>;
	public function distanceBetween(start:T, goal:T):Int;
}
