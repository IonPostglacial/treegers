package game.map;

class GroundTypeProperties {
    public static function crossableWith(type:GroundType, vehicle:Vehicle):Bool {
        return type != GroundType.Uncrossable || type == GroundType.Water && vehicle == Vehicle.Foot;
    }
}
