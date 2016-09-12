package game.nodes;

import ash.core.Node;

import game.components.EyeCandy;
import game.components.Health;
import hex.Position;

class HealthyGraphicalNode extends Node<HealthyGraphicalNode> {
	public var health:Health;
	public var position:Position;
	public var eyeCandy:EyeCandy;
}
