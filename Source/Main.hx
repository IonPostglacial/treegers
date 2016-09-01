/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package;

import openfl.display.Sprite;

class Main extends Sprite
{
	var grid = new hex.Grid(14, 11, Conf.HEX_RADIUS);
	var game:GameStage;


	public function new()
	{
		super();
		game = new GameStage(this, grid.width, grid.height);
		game.start();
	}
}
