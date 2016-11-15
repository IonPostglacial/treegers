package game;

enum GroundType {
	Unknown;
	Basic;
	Uncrossable;
	Fatal;
	Hurting(intensity:Int);
	Arrow(dx:Int, dy:Int);
}
