package grid;

abstract Pixel(Float) {
    private inline function new(px:Float) {
        this = px;
    }

    @:op(A >= B) static function gte(a:Pixel, b:Pixel):Bool;
    @:op(A <= B) static function lte(a:Pixel, b:Pixel):Bool;
    @:op(A > B) static function gt(a:Pixel, b:Pixel):Bool;
    @:op(A < B) static function lt(a:Pixel, b:Pixel):Bool;
    @:op(A + B) static function add(a:Pixel, b:Pixel):Pixel;
    @:op(A - B) static function sub(a:Pixel, b:Pixel):Pixel;
    @:commutative @:op(A * B) static function mul(a:Pixel, factor:Float):Pixel;
    @:commutative @:op(A / B) static function div(a:Pixel, divider:Float):Pixel;

    public static inline function pixel(n:Float) return new Pixel(n);
    public function toFloat():Float return this;
}