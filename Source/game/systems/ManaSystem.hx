package game.systems;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Mana;


class ManaNode extends Node<ManaNode> {
	public var mana:Mana;
}

class ManaSystem extends ListIteratingSystem<ManaNode> {
	public function new() {
		super(ManaNode, updateNode);
	}

	function updateNode(node:ManaNode, deltaTime:Float) {
		if (node.mana.level < node.mana.max) {
			node.mana.level = Math.min(node.mana.level + deltaTime * node.mana.recovery, node.mana.max);
			node.mana.changedThisRound = true;
		} else {
			node.mana.changedThisRound = false;
		}
	}
}
