package tmx;

@:enum abstract Orientation(String) from String to String {
	var Orthogonal = "orthogonal";
	var Isometric = "isometric";
	var Staggered = "staggered";
	var Hexagonal = "hexagonal";

	public function adjacentTilesNumber():Int {
		switch (this) {
		case Hexagonal, Staggered:
			return 6;
		default:
			return 4;	
		}
	}
}
