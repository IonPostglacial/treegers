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
	public static function gruntAt(id:Int, coordinates:Coordinates):Entity {
		return new Entity()
		.add(new Position(coordinates.x, coordinates.y))
		.add(new Health(100, 100, 2))
		.add(new Visible(id))
		.add(new Movement(Vehicle.Foot, 0.5))
		.add(new Controled());
	}

	public static function buttonAt(id:Int, coordinates:Coordinates, switched:Array<tmx.TileObject>, tiledId1:Int, tileId2:Int):Entity {
		return new Entity()
		.add(new Position(coordinates.x, coordinates.y))
		.add(new Visible(id))
		.add(new Button(false, switched, tiledId1, tileId2));
	}

	public static function rollingBallAt(id:Int, coordinates:Coordinates):Entity {
		return new Entity()
		.add(new Position(coordinates.x, coordinates.y))
		.add(new Visible(id))
		.add(new Collectible([new Health(0, 100, 2)]))
		.add(new Movement(Vehicle.Foot, 0.5))
		.add(new LinearWalker(-1, 0));
	}
}
