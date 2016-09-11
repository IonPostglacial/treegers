package game.nodes;

import ash.core.Node;

import game.components.Health;
import hex.Position;

class HealthNode extends Node<HealthNode> {
	public var health:Health;
	public var position:Position;
}
