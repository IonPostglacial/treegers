/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package;

import openfl.display.Sprite;

import game.GameStage;


class Main extends Sprite {
	var game:GameStage;

	public function new() {
		super();
		game = new GameStage(this, 14, 11);
		game.start();
	}
}
