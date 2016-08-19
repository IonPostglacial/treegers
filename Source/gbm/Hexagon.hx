package gbm;

import openfl.geom.Point;

class Hexagon
{
    static var SQRT3 = Math.sqrt(3);
    public var center:Point;
    public var radius:Float;
    public var area(get, null):Float;
    public var corners(get, null):Array<Point>;

    public function new(center:Point, radius:Float)
    {
        this.center = center;
        this.radius = radius;
    }

    public function get_area():Float
    {
        return 1.5 * SQRT3 * radius * radius;
    }

    public function get_corners():Array<Point>
    {
        var H_OFFSET = SQRT3 * 0.5 * radius;
        var V_OFFSET = radius * 0.5;
        return
        [
            new Point(center.x - H_OFFSET, center.y - V_OFFSET),
            new Point(center.x, center.y - radius),
            new Point(center.x + H_OFFSET, center.y - V_OFFSET),
            new Point(center.x + H_OFFSET, center.y + V_OFFSET),
            new Point(center.x, center.y + radius),
            new Point(center.x - H_OFFSET, center.y + V_OFFSET)
        ];
    }
}
