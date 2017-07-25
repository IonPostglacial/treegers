/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package;


import game.Stage;


class Main {
	public static function main() {
		var game = new Stage("demo.tmx", 800, 600);
		game.start();
	}
}
