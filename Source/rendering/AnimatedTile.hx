package rendering;

import openfl.display.Tile;


class AnimatedTile extends Tile {
	public var ids(default, set):Array<Int>;
	private var __curentFrame:Int = 0;
	private var __period:Float;
	private var __elapsedTime:Float = 0;

	public function new(ids:Array<Int>, period:Float = 1.0, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0) {
		super(ids[0], x, y, scaleX, scaleY, rotation);
		this.ids = ids;
		this.__period = period;
	}

	private function set_ids(value:Array<Int>):Array<Int> {
		this.id = value[0];
		return this.ids = value;
	}

	public function update(deltaTime:Float):Void {
		this.__elapsedTime += deltaTime;
		while (this.__elapsedTime >= this.__period) {
			this.__elapsedTime -= this.__period;
			this.__curentFrame += 1;
			if (this.__curentFrame >= this.ids.length) {
				this.__curentFrame = 0;
			}
		}
		this.id = this.ids[this.__curentFrame];
	}
}
