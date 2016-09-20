package game.nodes;

import ash.core.Node;

import game.components.Button;
import hex.Position;

class ButtonNode extends Node<ButtonNode> {
	public var button:Button;
	public var position:Position;
}
