package game.actions;

import ash.core.Entity;

import game.nodes.ActionedNode;

interface Action
{
	var done(get, never):Bool;
	function execute(stage:GameStage, node:ActionedNode, deltaTime:Float):Void;
}
