package game;

@:enum abstract TileType(Int) from Int to Int {
	var None = 0;
	var Grunt = 1;
	var Water = 2;
	var Ground = 3;
	var Button = 4;
	var Pikes = 5;
	var Cliff = 6;
	var ArrowA = 7;
	var ArrowD = 8;
	var ArrowE = 9;
	var ArrowB = 10;
	var ArrowF = 11;
	var ArrowC = 12;
	var RollingBall = 13;
	var Last = 14;

	public function crossableWith(vehicle:Vehicle):Bool return switch (this) {
		case TileType.None: false;
		case TileType.Water: std.Type.enumEq(vehicle, Boat) || std.Type.enumEq(vehicle, Plane);
		case TileType.Cliff: false;
		default:true;
	}

	public function isArrow():Bool return switch(this) {
		case TileType.ArrowA,
			TileType.ArrowB,
			TileType.ArrowC,
			TileType.ArrowD,
			TileType.ArrowE,
			TileType.ArrowF: true;
		default:false;
	}

	public function dx():Int return switch(this) {
		case TileType.ArrowA: 1;
		case TileType.ArrowB: 0;
		case TileType.ArrowC: -1;
		case TileType.ArrowD: -1;
		case TileType.ArrowE: 0;
		case TileType.ArrowF: 1;
		default:0;
	}

	public function dy():Int return switch(this) {
		case TileType.ArrowA: 0;
		case TileType.ArrowB: 1;
		case TileType.ArrowC: 1;
		case TileType.ArrowD: 0;
		case TileType.ArrowE: -1;
		case TileType.ArrowF: -1;
		default:0;
	}
}
