package game.actions;

import ash.core.Entity;

import game.nodes.ActionedNode;

interface Action {
	var done(get, never):Bool;
	function execute(stage:Stage, node:ActionedNode, deltaTime:Float):Void;
}
