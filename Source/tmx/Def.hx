package tmx;

abstract Def<T>(T) from Null<T> {
	public function new(value:T) {
		this = value;
	}

	public function or(value:Null<T>):T return if (value == null) {
		this;
	} else {
		value;
	}
}
