package gbm;

class Distance
{
    public static function grid(p1:Position, p2:Position):Int
    {
            var dx = p1.x > p2.x ? p1.x - p2.x : p2.x - p1.x;
            var dy = p1.y > p2.y ? p1.y - p2.y : p2.y - p1.y;
            return dx > dy ? dx : dy;
    }

    public static function manhattan(p1:Position, p2:Position):Int
    {
            var dx = p1.x > p2.x ? p1.x - p2.x : p2.x - p1.x;
            var dy = p1.y > p2.y ? p1.y - p2.y : p2.y - p1.y;
            return dx + dy;
    }
}
