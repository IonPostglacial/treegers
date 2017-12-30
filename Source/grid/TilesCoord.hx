package grid;


abstract TilesCoord(Int) from Int to Int {
    public inline function new(px:Int) {
        this = px;
    }

    @:op(A >= B) static function gte(a:TilesCoord, b:TilesCoord):Bool;
    @:op(A <= B) static function lte(a:TilesCoord, b:TilesCoord):Bool;
    @:op(A > B) static function gt(a:TilesCoord, b:TilesCoord):Bool;
    @:op(A < B) static function lt(a:TilesCoord, b:TilesCoord):Bool;
    @:op(A - B) static function sub(a:TilesCoord, b:TilesCoord):TilesDelta;
    @:commutative @:op(A + B) static function addDelta(a:TilesCoord, b:TilesDelta):TilesCoord;
    @:commutative @:op(A - B) static function subDelta(a:TilesCoord, b:TilesDelta):TilesCoord;

    public function toInt():Int return this;
}