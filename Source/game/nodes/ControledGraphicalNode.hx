package game.nodes;

import ash.core.Node;

import game.components.Controled;
import game.components.EyeCandy;
import hex.Position;

class ControledGraphicalNode extends Node<ControledGraphicalNode> {
	public var controled:Controled;
	public var eyeCandy:EyeCandy;
	public var position:Position;
}
