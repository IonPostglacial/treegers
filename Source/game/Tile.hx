package game;

enum Type {
	None;
	Ground;
	Water;
	Hole;
	Pikes;
	Cliff;
	Arrow(dx:Int, dy:Int);
}

class Color {
	public static function of(type:Type):Int return switch(type) {
		case None: 0x000000;
		case Ground: 0xBD7207;
		case Water: 0x22DDEE;
		case Hole: 0xFFDDCA;
		case Pikes: 0xDDAAAA;
		case Cliff: 0xAAAAAA;
		case Arrow(_): 0xDD7777;
		default:0x000000;
	}
}
