package game.nodes;

import ash.core.Node;

import game.components.Controled;
import game.components.Movement;
import game.components.Position;

class ActionedNode extends Node<ActionedNode> {
	public var controled:Controled;
	public var position:Position;
	public var movement:Movement;
}
