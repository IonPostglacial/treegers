/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package graph;

interface Pathfindable
{
    public function neighborsOf(position:Position):Iterable<Position>;
    public function distanceBetween(start:Position, goal:Position):Int;
}