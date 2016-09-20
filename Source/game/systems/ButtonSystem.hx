package game.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;

import game.nodes.ButtonNode;
import game.nodes.MovingNode;

class ButtonSystem extends System {
	var stage:GameStage;
	var buttons:NodeList<ButtonNode>;
	var movers:NodeList<MovingNode>;

	public function new(stage:GameStage) {
		this.stage = stage;
		super();
	}

	override public function update(deltaTime:Float) {
		for (buttonNode in buttons) {
			var buttonAlreadyPressed = buttonNode.button.pressed;
			for (mover in movers) {
				buttonNode.button.pressed = mover.position.equals(buttonNode.position);
				if (buttonAlreadyPressed != buttonNode.button.pressed) {
					for (position in buttonNode.button.affectedTiles) {
						stage.setTileAt(position, buttonNode.button.currentTileType);
					}
				}
				if (buttonNode.button.pressed) {
					break;
				}
			}
		}
	}

	override public function addToEngine(engine:Engine) {
		buttons = engine.getNodeList(ButtonNode);
		movers = engine.getNodeList(MovingNode);
	}
}
