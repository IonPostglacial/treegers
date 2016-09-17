package game.nodes;

import ash.core.Node;

import game.components.EyeCandy;
import game.components.Movement;
import hex.Position;

class MovingGraphicalNode extends Node<MovingGraphicalNode> {
	public var movement:Movement;
	public var eyeCandy:EyeCandy;
	public var position:Position;
}
