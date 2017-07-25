package game.systems;

import ash.core.System;
import openfl.display.Sprite;
import game.map.TargetObject;
import grid.ICoordinateSystem;


class TargetsRenderingSystem extends System implements ITargetListListener {
	var targetSprites:Sprite = new Sprite();
	var targetBlinkElapsedTime:Float = 0;
	var targetBlinkPeriod:Float = 1;
	var coordinates:ICoordinateSystem;
	var hoverWidth:Int;
	var hoverHeight:Int;

	public function new(coordinates:ICoordinateSystem, hoverWidth:Int, hoverHeight:Int) {
		super();
		openfl.Lib.current.addChild(this.targetSprites);
		this.coordinates = coordinates;
		this.hoverWidth = hoverWidth;
		this.hoverHeight = hoverHeight;
	}

	function createTargetSprites(targets:Iterable<TargetObject>) {
		for (target in targets) {
			var targetPixPosition = this.coordinates.toPixel(target.x, target.y);
			var targetSprite = new Sprite();
			targetSprite.graphics.lineStyle(2, 0x0077ff);
			targetSprite.graphics.drawRoundRect(0, 0, hoverWidth, hoverHeight, hoverWidth);
			targetSprite.x = targetPixPosition.x;
			targetSprite.y = targetPixPosition.y;
			this.targetSprites.addChild(targetSprite);
		}
	}

	override function update(deltaTime:Float) {
		if (this.targetSprites.numChildren > 0) {
			this.targetBlinkElapsedTime += deltaTime;
			if (this.targetBlinkElapsedTime >= this.targetBlinkPeriod) {
				this.targetBlinkElapsedTime -= this.targetBlinkPeriod;
			}
			this.targetSprites.alpha = this.targetBlinkElapsedTime / this.targetBlinkPeriod;
		}
	}

	public function targetListChanged(targets:Iterable<TargetObject>):Void {
		this.targetSprites.removeChildren();
		createTargetSprites(targets);
	}
}
