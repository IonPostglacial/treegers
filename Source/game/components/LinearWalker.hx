package game.components;

import grid.TilesDelta;


@:publicFields
class LinearWalker {
	var dx:TilesDelta = new TilesDelta(1);
	var dy:TilesDelta = new TilesDelta(0);

	function new() {}
}
