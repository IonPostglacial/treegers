package game.nodes;

import ash.core.Node;

import game.components.Movement;
import hex.Position;

class MovingNode extends Node<MovingNode> {
	public var position:Position;
	public var movement:Movement;
}
