package game.nodes;

import ash.core.Node;

import game.components.Movement;
import game.components.LinearWalker;
import game.components.Position;

class LinearWalkingNode extends Node<LinearWalkingNode> {
	public var position:Position;
	public var linearWalker:LinearWalker;
	public var movement:Movement;
}
