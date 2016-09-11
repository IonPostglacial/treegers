package game;

enum TileType {
	None;
	Ground;
	Water;
	Hole;
	Pikes;
	Cliff;
	Arrow(dx:Int, dy:Int);
}
