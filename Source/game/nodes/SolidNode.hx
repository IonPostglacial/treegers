package game.nodes;

import ash.core.Node;
import game.components.Position;
import game.components.Solid;


class SolidNode extends Node<SolidNode> {
	public var solid:Solid;
	public var position:Position;
}