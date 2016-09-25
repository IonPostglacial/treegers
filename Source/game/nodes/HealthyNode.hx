package game.nodes;

import ash.core.Node;

import game.components.Health;
import game.components.Position;

class HealthyNode extends Node<HealthyNode> {
	public var health:Health;
	public var position:Position;
}
