package game.map;

import tmx.TileObject;


class TargetObject {
    public var objectId(get,never):Int;
    @:allow(game.map.WorldMap.setTargetStatus)
    private var tileObject:TileObject;

    public function new(tileObject:TileObject) {
        this.tileObject = tileObject;
    }

    public function get_objectId():Int {
        return this.tileObject.id;
    }
}
