package game.nodes;

import ash.core.Node;

import game.components.EyeCandy;
import game.components.Pace;
import hex.Position;

class MovingGraphicalNode extends Node<MovingGraphicalNode> {
	public var pace:Pace;
	public var eyeCandy:EyeCandy;
	public var position:Position;
}
