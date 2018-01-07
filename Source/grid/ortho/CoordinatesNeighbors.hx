package grid.ortho;

import grid.TilesDelta;


class CoordinatesNeighbors {
    static var deltas = [-1, -1, -1, 0, -1, 1, 0, -1, 0, 1, 1, -1, 1, 0, 1, 1].map(TilesDelta.new);
    var grid:Grid;
	var coord:Coordinates;
	var i = -1;

	public function new(grid:Grid, coord:Coordinates) {
		this.grid = grid;
        this.coord = coord;
	}

    public function iterator() {
        return this;
    }

	public function hasNext():Bool {
        do {
            i += 1;
        } while (i < 8 && !this.grid.contains(coord.x + deltas[2 * i], coord.y + deltas[2 * i + 1]));
		return i < 8;
	}

	public function next():Coordinates {
        var x = coord.x + deltas[2 * i];
        var y = coord.y + deltas[2 * i + 1];
        return new Coordinates(x, y);
	}
}
