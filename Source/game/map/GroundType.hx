package game.mapmanagement;

enum GroundType {
	Unknown;
	Basic;
	Uncrossable;
	Water;
	Hole;
	Fatal;
	Hurting(intensity:Int);
	Arrow(dx:Int, dy:Int);
}
