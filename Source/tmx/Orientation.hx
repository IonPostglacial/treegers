package tmx;

@:enum abstract Orientation(String) from String {
	var Orthogonal = "orthogonal";
	var Isometric = "isometric";
	var Staggered = "staggered";
	var Hexagonal = "hexagonal"; 
}
