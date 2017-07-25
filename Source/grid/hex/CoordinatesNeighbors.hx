package grid.hex;


class CoordinatesNeighbors {
    static var deltas = [-1, 0, -1, 1, 0, -1, 0, 1, 1, -1, 1, 0];
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
        } while (i < 6 && !this.grid.contains(coord.x + deltas[2 * i], coord.y + deltas[2 * i + 1]));
        return i < 6;
	}

	public function next():Coordinates {
        var x = coord.x + deltas[2 * i];
        var y = coord.y + deltas[2 * i + 1];
        return new Coordinates(x, y);
	}
}
