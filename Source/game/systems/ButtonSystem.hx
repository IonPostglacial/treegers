package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.core.System;

import game.nodes.MovingNode;

import game.components.Button;
import game.components.Position;

import game.map.WorldMap;


class ButtonNode extends Node<ButtonNode> {
	public var button:Button;
	public var position:Position;
}

class ButtonSystem extends System {
	var worldMap:WorldMap;
	var buttons:NodeList<ButtonNode>;
	var movers:NodeList<MovingNode>;

	public function new(worldMap:WorldMap) {
		this.worldMap = worldMap;
		super();
	}

	function flipButton(button:Button) {
		button.isPressed = !button.isPressed;
		if (button.isToggle || button.isPressed) {
			button.triggered = !button.triggered;
		}
	}

	override public function update(deltaTime:Float) {
		for (buttonNode in buttons) {
			var buttonAlreadyPressed = buttonNode.button.isPressed;
			var buttonCurrentlyPressed = false;
			for (mover in movers) {
				buttonCurrentlyPressed = mover.position.equals(buttonNode.position);
				if (buttonCurrentlyPressed) {
					break;
				}
			}
			if (buttonAlreadyPressed != buttonCurrentlyPressed) {
				flipButton(buttonNode.button);
				for (tileObject in buttonNode.button.affectedTiles) {
					this.worldMap.setTargetStatus(tileObject, buttonNode.button.triggered);
				}
			}
		}
	}

	override public function addToEngine(engine:Engine) {
		buttons = engine.getNodeList(ButtonNode);
		movers = engine.getNodeList(MovingNode);
		super.addToEngine(engine);
	}
}
