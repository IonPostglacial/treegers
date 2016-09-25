package game.nodes;

import ash.core.Node;

import game.components.Visible;
import game.components.Movement;
import game.components.Position;

class VisiblyMovingNode extends Node<VisiblyMovingNode> {
	public var movement:Movement;
	public var visible:Visible;
	public var position:Position;
}
