package game.nodes;

import ash.core.Node;

import game.components.Controled;
import game.components.Visible;
import hex.Position;

class VisiblyControledNode extends Node<VisiblyControledNode> {
	public var controled:Controled;
	public var visible:Visible;
	public var position:Position;
}
