/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package graph;

interface Step<T>
{
	function equals(other:T):Bool;
	function hashCode():Int;
}
