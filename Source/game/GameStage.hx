package game;

import haxe.ds.HashMap;

import openfl.display.Sprite;

import ash.tick.ITickProvider;
import ash.tick.FrameTickProvider;
import ash.core.Engine;
import ash.core.Entity;

import game.systems.ActionSystem;
import game.systems.ControledSystem;
import game.systems.EyeCandySystem;
import game.systems.ControledEyeCandySystem;
import game.systems.MovingEyeCandySystem;
import game.systems.HealthSystem;
import game.systems.LinearMovementSystem;
import game.systems.PathMovementSystem;
import game.systems.PaceSystem;

import drawing.Shape;
import hex.Hexagon;
import hex.Position;
import hex.HexaMap;
import game.components.Controled;
import game.components.EyeCandy;
import game.components.Health;
import game.components.LinearWalker;
import game.components.Pace;


class GameStage {
	public var grid:hex.Grid;

	var scene:Sprite;
	var engine = new Engine();
	var tickProvider:ITickProvider;
	var tiles:HexaMap<Tile.Type>;

	public function new(scene:Sprite, width:Int, height:Int) {
		this.scene = scene;
		this.grid = new hex.Grid(width, height, Conf.HEX_RADIUS);
		this.tiles = new HexaMap<Tile.Type>(width, height, Tile.Type.Ground);
		this.tiles.set(3, 2, Tile.Type.Pikes);
		prepare(scene, width, height);
	}

	public function tileAt(position:Position) {
		return tiles.get(position.x, position.y);
	}

	public function start() {
		tickProvider = new FrameTickProvider(scene);
		tickProvider.add(engine.update);
		tickProvider.start();
	}

	function prepare(scene:Sprite, width:Float, height:Float):Void {
		engine.addSystem(new ActionSystem(this), 1);
		engine.addSystem(new ControledSystem(this), 1);
		engine.addSystem(new HealthSystem(this), 1);
		engine.addSystem(new LinearMovementSystem(this), 1);
		engine.addSystem(new PathMovementSystem(this), 1);
		engine.addSystem(new PaceSystem(this), 1);
		engine.addSystem(new EyeCandySystem(this), 2);
		engine.addSystem(new ControledEyeCandySystem(this), 3);
		engine.addSystem(new MovingEyeCandySystem(this), 3);

		var gruntSprite = new Sprite();
		gruntSprite.graphics.beginFill(0xBB5555);
		Shape.hexagon(gruntSprite.graphics, new Hexagon(0, 0, Conf.HEX_RADIUS));

		var ballSprite = new Sprite();
		ballSprite.graphics.beginFill(0x777777);
		Shape.hexagon(ballSprite.graphics, new Hexagon(0, 0, Conf.HEX_RADIUS));

		var grunt = new Entity()
		.add(new Position(0, 0))
		.add(new Health(100, 100, 2))
		.add(new EyeCandy(gruntSprite))
		.add(new Pace(1))
		.add(new Controled());

		var rollingBall = new Entity()
		.add(new Position(3, 3))
		.add(new EyeCandy(ballSprite))
		.add(new Pace(1))
		.add(new LinearWalker(1, 0));

		engine.addEntity(grunt);
		engine.addEntity(rollingBall);
	}
}
