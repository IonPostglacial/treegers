package game;

@:enum abstract TileType(Int) to Int {
	var Grunt = 0;
	var Water = 1;
	var Ground = 2;
	var Button = 3;
	var Pikes = 4;
	var Cliff = 5;
	var ArrowA = 6;
	var ArrowD = 7;
	var ArrowE = 8;
	var ArrowB = 9;
	var ArrowF = 10;
	var ArrowC = 11;
	var RollinBall = 12;
	var None = 13;
	var Last = 13;

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
