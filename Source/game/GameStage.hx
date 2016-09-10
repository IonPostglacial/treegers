package game;

import openfl.display.Sprite;

import ash.tick.ITickProvider;
import ash.tick.FrameTickProvider;
import ash.core.Engine;
import ash.core.Entity;

import game.systems.ActionSystem;
import game.systems.GraphicsSystem;
import game.systems.ControledSystem;

import drawing.Shape;
import hex.Hexagon;
import hex.Position;
import game.components.Controled;
import game.components.EyeCandy;
import game.components.Speed;
import game.actions.Move;

class GameStage {
	public var grid:hex.Grid;

	var scene:Sprite;
    var engine = new Engine();
    var tickProvider:ITickProvider;

    public function new(scene:Sprite, width:Int, height:Int) {
		this.scene = scene;
		this.grid = new hex.Grid(width, height, Conf.HEX_RADIUS);
        prepare(scene, width, height);
    }

    public function start() {
        tickProvider = new FrameTickProvider(scene);
        tickProvider.add(engine.update);
        tickProvider.start();
    }

    function prepare(scene:Sprite, width:Float, height:Float):Void {
		engine.addSystem(new ActionSystem(this), 1);
		engine.addSystem(new ControledSystem(this), 1);
        engine.addSystem(new GraphicsSystem(this), 2);

		var hex = new Sprite();
		hex.graphics.beginFill(0xBB5555);
		Shape.hexagon(hex.graphics, new Hexagon(0, 0, Conf.HEX_RADIUS));

		var grunt = new Entity()
        .add(new Position(0, 0))
		.add(new EyeCandy(hex))
		.add(new Speed(1))
		.add(new Controled());
		engine.addEntity(grunt);
    }
}
