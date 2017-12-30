package game.map;

import grid.TilesDelta;


enum GroundType {
	Unknown;
	Basic;
	Uncrossable;
	Water;
	Hole;
	DigPile;
	Fatal;
	Hurting(intensity:Int);
	Arrow(dx:TilesDelta, dy:TilesDelta);
}
