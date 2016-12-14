package game.map;

import tmx.TileObject;


class TargetObject {
    public var objectId(get,never):Int;
    public var x(get,never):Int;
    public var y(get,never):Int;
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

    public function get_x():Int {
        return this.tileObject.coordX;
    }

    public function get_y():Int {
        return this.tileObject.coordY;
    }
}
