package game.nodes;

import ash.core.Node;

import game.components.Speed;
import game.components.LinearMover;
import hex.Position;

class LinearMovingNode extends Node<LinearMovingNode> {
	public var position:Position;
	public var linearMover:LinearMover;
	public var speed:Speed;
}
