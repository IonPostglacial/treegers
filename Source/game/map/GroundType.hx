package game.map;

enum GroundType {
	Unknown;
	Basic;
	Uncrossable;
	Water;
	Hole;
	DigPile;
	Fatal;
	Hurting(intensity:Int);
	Arrow(dx:Int, dy:Int);
}
