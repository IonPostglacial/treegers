package game.nodes;

import ash.core.Node;

import game.components.Collector;
import game.components.Position;

class CollectorNode extends Node<CollectorNode> {
	public var collector:Collector;
	public var position:Position;
}
