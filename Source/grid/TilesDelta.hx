package grid;

abstract TilesDelta(Int) {
    public inline function new(px:Int) {
        this = px;
    }

    @:op(A >= B) static function gte(a:TilesDelta, b:TilesDelta):Bool;
    @:op(A <= B) static function lte(a:TilesDelta, b:TilesDelta):Bool;
    @:op(A > B) static function gt(a:TilesDelta, b:TilesDelta):Bool;
    @:op(A < B) static function lt(a:TilesDelta, b:TilesDelta):Bool;
    @:op(A + B) static function add(a:TilesDelta, b:TilesDelta):TilesDelta;
    @:op(A - B) static function sub(a:TilesDelta, b:TilesDelta):TilesDelta;
    @:op(A * B) static function mul(a:TilesDelta, b:TilesDelta):TilesDelta;
    @:commutative @:op(A * B) static function muli(a:TilesDelta, factor:Int):TilesDelta;
    @:commutative @:op(A / B) static function div(a:TilesDelta, divider:Int):TilesDelta;

    public function toInt():Int return this;
}