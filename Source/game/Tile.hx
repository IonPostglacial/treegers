package game;

enum Type {
	None;
	Ground;
	Water;
	Hole;
	Pikes;
	Cliff;
}

class Color {
	public static function of(type:Type):Int return switch(type) {
		case None: 0x000000;
		case Ground: 0xBD7207;
		case Water: 0x22DDEE;
		case Hole: 0xFFDDCA;
		case Pikes: 0xFFDDDD;
		case Cliff: 0xCACACA;
		default:0x000000;
	}
}
