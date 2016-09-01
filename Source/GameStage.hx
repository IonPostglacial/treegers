package;

import openfl.display.Sprite;

import ash.tick.ITickProvider;
import ash.tick.FrameTickProvider;
import ash.core.Engine;
import ash.core.Entity;

import systems.GraphicsSystem;
import systems.OrderSystem;

import drawing.Shape;
import hex.Hexagon;
import hex.Position;
import components.Controled;
import components.EyeCandy;
import components.Speed;
import orders.Move;

class GameStage
{
	public var grid = new hex.Grid(14, 11, Conf.HEX_RADIUS);
	public var grunt:Entity;
	var scene:Sprite;
    var engine = new Engine();
    var tickProvider:ITickProvider;

    public function new(scene:Sprite, width:Float, height:Float)
    {
		this.scene = scene;
        prepare(scene, width, height);
    }

    public function start():Void
    {
        tickProvider = new FrameTickProvider(scene);
        tickProvider.add(engine.update);
        tickProvider.start();
    }

    function prepare(scene:Sprite, width:Float, height:Float):Void
    {
		engine.addSystem(new OrderSystem(this), 1);
        engine.addSystem(new GraphicsSystem(this, scene, grid), 2);

		var hex = new Sprite();
		hex.graphics.beginFill(0xFF0000);
		Shape.hexagon(hex.graphics, new Hexagon(0, 0, Conf.HEX_RADIUS));

		var controled = new Controled();
		controled.orders.push(new Move([new hex.Position(0, 3), new hex.Position(0, 2), new hex.Position(0, 1)]));

		grunt = new Entity()
        .add(new Position(0, 0))
		.add(new EyeCandy(hex))
		.add(new Speed(1))
		.add(controled);
		engine.addEntity(grunt);
    }
}
