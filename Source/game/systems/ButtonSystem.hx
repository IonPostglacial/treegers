package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.core.System;

import game.Stage;
import game.nodes.MovingNode;

import game.components.Button;
import game.components.Position;


class ButtonNode extends Node<ButtonNode> {
	public var button:Button;
	public var position:Position;
}

class ButtonSystem extends System {
	var stage:Stage;
	var buttons:NodeList<ButtonNode>;
	var movers:NodeList<MovingNode>;

	public function new(stage:Stage) {
		this.stage = stage;
		super();
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
				buttonNode.button.flip();
				for (tileObject in buttonNode.button.affectedTiles) {
					this.stage.ground.setObjectStatus(tileObject, buttonNode.button.triggered);
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
