package game.nodes;

import ash.core.Node;

import game.components.Pace;
import game.components.PathWalker;
import hex.Position;

class PathWalkingNode extends Node<PathWalkingNode> {
	public var position:Position;
	public var pathWalker:PathWalker;
	public var pace:Pace;
}
