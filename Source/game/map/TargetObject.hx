package game.map;

import tmx.TileObject;
import geometry.Coordinates;


class TargetObject {
    public var objectId(get,never):Int;
    public var coords(get,never):Coordinates;
    public var groundType(default,null):GroundType;
    @:allow(game.map.WorldMap.setTargetStatus)
    private var tileObject:TileObject;

    public function new(tileObject:TileObject, type:GroundType) {
        this.tileObject = tileObject;
        this.groundType = type;
    }

    public function isActive():Bool {
        return this.tileObject.active;
    }

    public function get_objectId():Int {
        return this.tileObject.id;
    }

    public function get_coords():Coordinates {
        return this.tileObject.coords;
    }
}
