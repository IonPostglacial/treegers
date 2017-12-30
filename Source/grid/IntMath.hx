package grid;


@:publicFields
class IntMath {
    static function abs(n:Int):Int {
        return n >= 0 ? n : -n;
    }

    static function max(a:Int, b:Int):Int {
        return a >= b ? a : b;
    }
}
