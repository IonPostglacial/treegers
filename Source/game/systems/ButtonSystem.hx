package game.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;

import game.Stage;
import game.nodes.ButtonNode;
import game.nodes.MovingNode;

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
				for (position in buttonNode.button.affectedTiles) {
					stage.setTileAt(position, buttonNode.button.currentTileType);
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
