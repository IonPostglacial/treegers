package game.nodes;

import ash.core.Node;

import game.components.Visible;
import game.components.Health;
import hex.Position;

class VisiblyHealthyNode extends Node<VisiblyHealthyNode> {
	public var health:Health;
	public var position:Position;
	public var visible:Visible;
}
