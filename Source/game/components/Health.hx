package game.components;

class Health {
	public var level:Float;
	public var max:Float;
	public var armor:Float;

	public function new(level, max, armor) {
		this.level = level;
		this.max = max;
		this.armor = armor;
	}
}
