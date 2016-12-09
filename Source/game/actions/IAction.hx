package game.actions;

import ash.core.Entity;

import game.nodes.ActionedNode;
import game.map.WorldMap;

interface IAction {
	var done(get, never):Bool;
	function execute(worldMap:WorldMap, node:ActionedNode, deltaTime:Float):Void;
}
