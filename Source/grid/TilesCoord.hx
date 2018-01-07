package grid;


abstract TilesCoord(Int) {
    private inline function new(n:Int) {
        this = n;
    }

    @:op(A >= B) static function gte(a:TilesCoord, b:TilesCoord):Bool;
    @:op(A <= B) static function lte(a:TilesCoord, b:TilesCoord):Bool;
    @:op(A > B) static function gt(a:TilesCoord, b:TilesCoord):Bool;
    @:op(A < B) static function lt(a:TilesCoord, b:TilesCoord):Bool;
    @:op(A - B) static function sub(a:TilesCoord, b:TilesCoord):TilesDelta;
    @:commutative @:op(A + B) static function addDelta(a:TilesCoord, b:TilesDelta):TilesCoord;
    @:commutative @:op(A - B) static function subDelta(a:TilesCoord, b:TilesDelta):TilesCoord;

    public static inline function tiles(n:Int) return new TilesCoord(n);
    public inline function toInt():Int return this;
}