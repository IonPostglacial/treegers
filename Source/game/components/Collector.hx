package game.components;


@:publicFields
class Collector {
	var backup:Array<Dynamic>;
	var expirationTime:Float;

	function new(backup, expirationTime) {
		this.backup = backup;
		this.expirationTime = expirationTime;
	}
}
