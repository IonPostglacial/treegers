package game.actions;

import ash.core.Entity;

import game.nodes.ActionedNode;

interface IAction {
	var done(get, never):Bool;
	function execute(node:ActionedNode, deltaTime:Float):Void;
}
