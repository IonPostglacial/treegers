package systems;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import openfl.display.Sprite;

import components.EyeCandy;
import components.Controled;
import drawing.Shape;
import hex.Position;

import openfl.events.MouseEvent;

class MovingNode extends Node<MovingNode>
{
	public var controled:Controled;
	public var eyeCandy:EyeCandy;
	public var position:Position;
}

class GraphicsSystem extends ListIteratingSystem<MovingNode>
{
	var scene(default, null):Sprite;
	var game:GameStage;
	var overlay = new Sprite();
	var goal = new hex.Position(3, 6); // dummy

	public function new(game:GameStage, scene:Sprite, grid:hex.Grid)
	{
		this.game = game;
		this.scene = scene;
		scene.addChild(overlay);
		var path = graph.Path.find(grid, new hex.Position(0, 0), goal);

		scene.addEventListener(MouseEvent.MOUSE_MOVE, function(e)
		{
			var mousePosition = drawing.Shape.pointToPosition(new openfl.geom.Point(e.localX, e.localY), grid.radius);
			if (mousePosition.equals(goal))
				return;
			goal = mousePosition;
			path = graph.Path.find(grid, game.grunt.get(hex.Position), goal);
			drawPath(path);
		});
		drawBackground();
		drawPath(path);
		super(MovingNode, updateNode, addNode, removeNode);
	}

	function updateNode(node:MovingNode, deltaTime:Float)
	{
		if (node.controled.oldPosition != null && node.position.equals(node.controled.oldPosition))
			return;
		var pixPosition = Shape.positionToPoint(node.position, Conf.HEX_RADIUS);
		node.eyeCandy.sprite.x = pixPosition.x;
		node.eyeCandy.sprite.y = pixPosition.y;
		// tests
		var path = graph.Path.find(game.grid, game.grunt.get(hex.Position), goal);
		drawPath(path);
	}

	function addNode(node:MovingNode)
	{
		this.scene.addChild(node.eyeCandy.sprite);
	}

	function removeNode(node:MovingNode)
	{
		this.scene.removeChild(node.eyeCandy.sprite);
	}

	function drawBackground()
	{
		scene.graphics.beginFill(0xbd7207);
		scene.graphics.drawRect(0, 0, 800, 600);
		scene.graphics.endFill();

		scene.graphics.lineStyle(2, 0xffa200);
		drawing.Shape.hexagonGrid(scene.graphics, game.grid);
	}

	function drawPath(path:Iterable<hex.Position>)
	{
		overlay.graphics.clear();
		overlay.graphics.beginFill(0xffcb40);
		for (point in path)
		{
			var point = drawing.Shape.positionToPoint(point, game.grid.radius);
			drawing.Shape.hexagon(overlay.graphics, new hex.Hexagon(point.x, point.y, game.grid.radius));
		}
		overlay.graphics.endFill();
	}
}
