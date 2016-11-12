package game.components;

class Collector {
	public var backup:Iterable<Dynamic>;
	public var expirationTime:Float;

	public function new(backup, expirationTime) {
		this.backup = backup;
		this.expirationTime = expirationTime;
	}
}
