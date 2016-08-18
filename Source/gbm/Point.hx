package gbm;

class Point
{
    public var x:Int;
    public var y:Int;

    public function new(x:Int, y:Int)
    {
        this.x = x;
        this.y = y;
    }

    public function hashCode():Int
    {
        var result = x;
        result = 31 * result + y;
        return result;
    }
}
