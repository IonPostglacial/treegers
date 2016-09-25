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

enum Vehicle { Foot; Boat; Plane; }

class Crossable {
	public static function with(type:Type, vehicle:Vehicle):Bool return switch (type) {
		case None: false;
		case Water: vehicle != Foot;
		case Cliff: false;
		default:true;
	}
}

class Color {
	public static function of(type:Type):Int return switch(type) {
		case None: 0x000000;
		case Ground: 0xBD7207;
		case Water: 0x55BBDD;
		case Hole: 0xFFDDCA;
		case Pikes: 0xDDAAAA;
		case Cliff: 0xAAAAAA;
		case Arrow(_): 0xDD7777;
		default:0x000000;
	}
}
