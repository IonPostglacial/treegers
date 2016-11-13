package game;

@:enum abstract TileType(Int) from Int to Int {
	var None = 0;
	var Grunt = 107;
	var Water = 1;
	var Ground = 6;
	var Button = 136;
	var Pikes = 48;
	var Cliff = 6;
	var ArrowA = 76;
	var ArrowB = 77;
	var ArrowC = 78;
	var ArrowD = 79;
	var ArrowE = 80;
	var ArrowF = 81;
	var RollingBall = 121;
	var Last = 121;

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
		case TileType.ArrowB: -1;
		case TileType.ArrowC: 0;
		case TileType.ArrowD: 0;
		case TileType.ArrowE: 0;
		case TileType.ArrowF: 1;
		default:0;
	}

	public function dy():Int return switch(this) {
		case TileType.ArrowA: 0;
		case TileType.ArrowB: 0;
		case TileType.ArrowC: 1;
		case TileType.ArrowD: -1;
		case TileType.ArrowE: -1;
		case TileType.ArrowF: -1;
		default:0;
	}
}
