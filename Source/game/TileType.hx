package game;

@:enum abstract TileType(Int) {
	var None = 0;
	var Ground = 1;
	var Water = 2;
	var Hole = 3;
	var Pikes = 4;
	var Cliff = 5;
	var ArrowA = 6;
	var ArrowB = 7;
	var ArrowC = 8;
	var ArrowD = 9;
	var ArrowE = 10;
	var ArrowF = 11;

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

	public function color():Int return switch(this) {
		case TileType.None: 0x000000;
		case TileType.Ground: 0xBD7207;
		case TileType.Water: 0x55BBDD;
		case TileType.Hole: 0xFFDDCA;
		case TileType.Pikes: 0xDDAAAA;
		case TileType.Cliff: 0xAAAAAA;
		case TileType.ArrowA,
			TileType.ArrowB,
			TileType.ArrowC,
			TileType.ArrowD,
			TileType.ArrowE,
			TileType.ArrowF: 0xDD7777;
		default:0x000000;
	}
}
