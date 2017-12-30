package game.map;

import grid.TilesDelta;


class GroundTypeProperties {
    static var arrowDeltas = [[0, -1], [1, 0], [-1, 0], [0, 1], [1, -1], [-1, 1]];

    public static function crossableWith(type:GroundType, vehicle:Vehicle):Bool {
        return type != GroundType.Uncrossable && (type != GroundType.Water || vehicle != Vehicle.Foot);
    }

    public static function fromTerrains(tileTerrains:Array<Int>):GroundType {
        if (tileTerrains != null) {
            var i = 0;
            var waterTerrainsNumber = 0;
            for (terrain in tileTerrains) {
                switch (Terrain.createByIndex(terrain)) {
                case Terrain.Hole:
                    return GroundType.Hole;
                case Terrain.DigPile:
                    return GroundType.DigPile;
                case Terrain.Obstacle:
                    return GroundType.Uncrossable;
                case Terrain.Water:
                    waterTerrainsNumber += 1;
                case Terrain.Arrow:
                    var dxdy = arrowDeltas[i];
                    return GroundType.Arrow(new TilesDelta(dxdy[0]), new TilesDelta(dxdy[1]));
                case Terrain.Pikes:
                    return GroundType.Hurting(1);
                default: // pass
                }
                i += 1;
            }
            if (waterTerrainsNumber == 0) {
                return GroundType.Basic;
            } else if (waterTerrainsNumber < tileTerrains.length) {
                return GroundType.Uncrossable;
            } else {
                return GroundType.Water;
            }
        }
        return GroundType.Basic;
    }
}
