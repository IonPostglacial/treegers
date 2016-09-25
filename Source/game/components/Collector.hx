package game.components;

class Collector {
	public var backup:Array<Dynamic>;
	public var expirationTime:Float;

	public function new(backup, expirationTime) {
		this.backup = backup;
		this.expirationTime = expirationTime;
	}
}
