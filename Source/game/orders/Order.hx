package game.orders;

import ash.core.Entity;

import game.nodes.ControledNode;

interface Order
{
	function take(stage:GameStage, node:ControledNode, deltaTime:Float):Bool;
}
