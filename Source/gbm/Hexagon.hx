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

class Grid
{
    public var width(default, null):Int;
    public var height(default, null):Int;
    public var radius(default, null):Int;
    public var cellsNumber(get, null):Int;
    public var positions(get, null):Iterable<Position>;

    var posCache:Array<Position>;

    public function new(width, height, radius)
    {
        this.width = width;
        this.height = height;
        this.radius = radius;

        posCache = [];
        for (y in 0...height)
        {
            for (x in 0...width - 1)
            {
                posCache.push(new Position(x - Std.int((y + 1) / 2), y));
            }
            if (y % 2 == 0)
            {
                posCache.push(new Position(width - 1 - Std.int(y / 2), y));
            }
        }
    }

    public function get_cellsNumber():Int
    {
        return Std.int((height + 1) / 2) * width + Std.int(height / 2) * (width - 1);
    }

    public function get_positions():Iterable<Position>
    {
        return posCache;
    }

    public function contains(x:Int, y:Int):Bool
    {
        return x + Std.int(y / 2) >= 0 && x + Std.int((y + 1) / 2) < width && y >= 0 && y < height;
    }
}
