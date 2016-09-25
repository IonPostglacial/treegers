package game.nodes;

import ash.core.Node;

import game.components.Collectible;
import game.components.Position;

class CollectibleNode extends Node<CollectibleNode> {
	public var collectible:Collectible;
	public var position:Position;
}
