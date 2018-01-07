package game.map;

import grid.TilesCoord;
using tmx.TileObject;


@:publicFields
class TargetObject {
    var objectId(get,never):Int;
    var x(get,never):TilesCoord;
    var y(get,never):TilesCoord;
    var isActive(get,never):Bool;
    var groundType(default,null):GroundType;
    @:allow(game.map.WorldMap.setTargetStatus)
    private var tileObject:TileObject;

    function new(tileObject:TileObject, type:GroundType) {
        this.tileObject = tileObject;
        this.groundType = type;
    }

    static inline function fromMapTileObject(map:tmx.TiledMap, object:tmx.TileObject):TargetObject {
        var tileTerrains = map.tilesets[0].terrains.get(object.gid - map.tilesets[0].firstGid);
		return new TargetObject(object, GroundTypeProperties.fromTerrains(tileTerrains));
    }

    function get_isActive():Bool {
        return this.tileObject.active;
    }

    function get_objectId():Int {
        return this.tileObject.id;
    }

    function get_x() {
        return this.tileObject.coordX;
    }

    function get_y() {
        return this.tileObject.coordY;
    }
}
