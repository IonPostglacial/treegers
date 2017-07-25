package game.map;

import tmx.TileObject;


@:publicFields
class TargetObject {
    var objectId(get,never):Int;
    var x(get,never):Int;
    var y(get,never):Int;
    var isActive(get,never):Bool;
    var groundType(default,null):GroundType;
    @:allow(game.map.WorldMap.setTargetStatus)
    private var tileObject:TileObject;

    function new(tileObject:TileObject, type:GroundType) {
        this.tileObject = tileObject;
        this.groundType = type;
    }

    function get_isActive():Bool {
        return this.tileObject.active;
    }

    function get_objectId():Int {
        return this.tileObject.id;
    }

    function get_x():Int {
        return this.tileObject.coordX;
    }

    function get_y():Int {
        return this.tileObject.coordY;
    }
}
