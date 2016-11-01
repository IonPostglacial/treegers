package game;

import ash.core.Entity;

import game.components.Position;
import game.components.Button;
import game.components.Controled;
import game.components.Visible;
import game.components.Health;
import game.components.LinearWalker;
import game.components.Movement;
import game.components.Position;
import game.components.Collectible;

import geometry.Coordinates;

class Entities {
	public static function gruntAt(coordinates:Coordinates):Entity {
		return new Entity()
		.add(new Position(coordinates.x, coordinates.y))
		.add(new Health(100, 100, 2))
		.add(new Visible(TileType.Grunt))
		.add(new Movement(Vehicle.Foot, 0.5))
		.add(new Controled());
	}

	public static function buttonAt(coordinates:Coordinates, switched:Array<Coordinates>, tiledId1:Int, tileId2:Int):Entity {
		return new Entity()
		.add(new Position(coordinates.x, coordinates.y))
		.add(new Visible(TileType.Button))
		.add(new Button(false, switched.map(function (coords) return new Position(coords.x, coords.y)), tiledId1, tileId2));
	}

	public static function rollingBallAt(coordinates:Coordinates):Entity {
		return new Entity()
		.add(new Position(coordinates.x, coordinates.y))
		.add(new Visible(TileType.RollingBall))
		.add(new Collectible([new Health(0, 100, 2)]))
		.add(new Movement(Vehicle.Foot, 1.5))
		.add(new LinearWalker(-1, 0));
	}
}
