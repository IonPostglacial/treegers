package game.nodes;

import ash.core.Node;

import game.components.Pace;
import game.components.LinearWalker;
import hex.Position;

class LinearWalkingNode extends Node<LinearWalkingNode> {
	public var position:Position;
	public var linearWalker:LinearWalker;
	public var pace:Pace;
}
