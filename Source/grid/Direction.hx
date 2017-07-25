package grid;


@:enum
abstract Direction(Int) from Int to Int {
    var None = 0;

    public function dx():Int {
        return if (this < -1)
            this + 3
        else if (this > 1)
            this - 3
        else this;
    }

    public function dy():Int {
        return if (this < -1)
            -1
        else if (this > 1)
            1
        else 0;
    }

    public static function fromVect(dx:Int, dy:Int):Direction {
        var direction = 0;
        if (dx != 0) {
            if (dx > 0) direction += 1
            else direction -= 1;
        }
        if (dy != 0) {
            if (dy > 0) direction += 3
            else direction -= 3;
        }
        return direction;
    }
}
