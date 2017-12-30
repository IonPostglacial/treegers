package grid;


@:enum
abstract Direction(Int) from Int to Int {
    var None = 0;

    private inline function new(i:Int) {
        this = i;
    }

    public function dx():TilesDelta {
        return new TilesDelta(if (this < -1)
            this + 3
        else if (this > 1)
            this - 3
        else this);
    }

    public function dy():TilesDelta {
        return new TilesDelta(if (this < -1)
            -1
        else if (this > 1)
            1
        else 0);
    }

    public static function fromVect(tdx:TilesDelta, tdy:TilesDelta):Direction {
        var direction = 0, dx = tdx.toInt(), dy = tdy.toInt();
        if (dx != 0) {
            if (dx > 0) direction += 1
            else direction -= 1;
        }
        if (dy != 0) {
            if (dy > 0) direction += 3
            else direction -= 3;
        }
        return new Direction(direction);
    }
}
