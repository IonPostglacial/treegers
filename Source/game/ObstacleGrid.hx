package game;

import graph.Path;
import game.components.Position;
import game.geometry.HexagonalGrid;
import game.geometry.HexagonalMap;

class ObstacleGrid implements Path.Findable<Position> {
	var grid:HexagonalGrid;
	var tiles:HexagonalMap<Tile.Type>;
	public var transportation:Tile.Transportation;

	public inline function new(grid, tiles, transportation) {
		this.grid = grid;
		this.tiles = tiles;
		this.transportation = transportation;
	}

	public function distanceBetween(p1:Position, p2:Position):Int {
		return grid.distanceBetween(p1, p2);
	}

	public function neighborsOf(p:Position):Iterable<Position> {
		return grid.neighborsOf(p).filter(function (position) {
			return Tile.Crossable.with(tiles.get(position.x, position.y), transportation);
		});
	}
}
