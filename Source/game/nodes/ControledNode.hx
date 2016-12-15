package game.nodes;

import ash.core.Node;
import game.components.Controled;
import game.components.Mana;
import game.components.Movement;
import game.components.ObjectChanger;
import game.components.Position;


class ControledNode extends Node<ControledNode> {
	public var controled:Controled;
	public var movement:Movement;
	public var mana:Mana;
	public var objectChanger:ObjectChanger;
	public var position:Position;
}
