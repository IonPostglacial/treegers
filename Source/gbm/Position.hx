package gbm;

class Position
{
    public var x(default, null):Int;
    public var y(default, null):Int;

    public function new(x:Int, y:Int)
    {
        this.x = x;
        this.y = y;
    }

    public function equals(other:Position):Bool
    {
        return this.x == other.x && this.y == other.y;
    }

    public function hashCode():Int
    {
        return x + 31 * y;
    }
}