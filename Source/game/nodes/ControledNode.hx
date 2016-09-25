package game.nodes;

import ash.core.Node;

import game.components.Controled;
import game.components.Position;

class ControledNode extends Node<ControledNode> {
	public var controled:Controled;
	public var position:Position;
}
