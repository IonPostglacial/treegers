package game.systems;

import openfl.display.Sprite;

import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.core.System;

import game.components.IGaugeableComponent;
import game.components.Health;
import game.components.Mana;
import game.components.Visible;
import game.components.Position;

using Lambda;


typedef WithVisible = {
	public var visible:Visible;
}

class VisiblyHealthyNode extends Node<VisiblyHealthyNode> {
	public var health:Health;
	public var position:Position;
	public var visible:Visible;
}

class VisiblyManaedNode extends Node<VisiblyManaedNode> {
	public var mana:Mana;
	public var position:Position;
	public var visible:Visible;
}

class VisibleWithGaugeSystem extends System {
	var tileWidth:Int;
	var healthies:NodeList<VisiblyHealthyNode>;
	var mages:NodeList<VisiblyManaedNode>;

	static var HEALTH_COLOR = 0x00FF00;
	static var TOOLED_COLOR = 0x0000FF;
	static var GAUGE_LHEIGHT = 1;
	static var GAUGE_HEIGHT = 5;

	public function new(tileWidth:Int) {
		this.tileWidth = tileWidth;
		super();
	}

	override public function update(deltaTime:Float) {
		for (healthy in healthies) {
			updateHealthyNode(healthy, deltaTime);
		}
		for (manaOwner in mages) {
			updateManaedNode(manaOwner, deltaTime);
		}
	}

	override public function addToEngine(engine:Engine) {
		this.healthies = engine.getNodeList(VisiblyHealthyNode);
		this.mages = engine.getNodeList(VisiblyManaedNode);
		this.healthies.foreach(creatingGauge("health", HEALTH_COLOR, 2 * GAUGE_HEIGHT, true));
		this.healthies.nodeAdded.add(creatingGauge("health", HEALTH_COLOR, 2 * GAUGE_HEIGHT, true));
		this.healthies.nodeRemoved.add(function (node:VisiblyHealthyNode) {
			node.visible.sprite.removeChild(node.visible.sprite.getChildByName("health"));
		});
		this.mages.foreach(creatingGauge("mana", TOOLED_COLOR, GAUGE_HEIGHT, false));
		this.mages.nodeAdded.add(creatingGauge("mana", TOOLED_COLOR, GAUGE_HEIGHT, false));
		this.mages.nodeRemoved.add(function (node:VisiblyManaedNode) {
			node.visible.sprite.removeChild(node.visible.sprite.getChildByName("mana"));
		});
		super.addToEngine(engine);
	}

	inline function creatingGauge<T:WithVisible>(gaugeName:String, color:Int, offset:Int, visible:Bool) {
		return function(node:T):Bool {
			var gauge = new Sprite();
			gauge.graphics.beginFill(0x000000);
			gauge.graphics.drawRect(0, 0, this.tileWidth, GAUGE_HEIGHT);
			gauge.graphics.endFill();
			gauge.graphics.beginFill(color);
			gauge.graphics.drawRect(GAUGE_LHEIGHT, GAUGE_LHEIGHT, this.tileWidth - 2 * GAUGE_LHEIGHT, GAUGE_HEIGHT - 2 * GAUGE_LHEIGHT);
			gauge.graphics.endFill();
			gauge.name = gaugeName;
			gauge.visible = visible;

			gauge.y -= offset;
			node.visible.sprite.addChild(gauge);
			return true;
		}
	}

	inline function updateGauge(sprite:Sprite, gaugeName:String, gaugeable:IGaugeableComponent, color:Int) {
		if (gaugeable.changedThisRound) {
			var gauge = cast(sprite.getChildByName(gaugeName), Sprite);
			var newWidth = Math.floor(this.tileWidth * (gaugeable.level / gaugeable.max));
			gauge.graphics.beginFill(color);
			gauge.graphics.drawRect(GAUGE_LHEIGHT, GAUGE_LHEIGHT, this.tileWidth - 2 * GAUGE_LHEIGHT, GAUGE_HEIGHT - 2 * GAUGE_LHEIGHT);
			gauge.graphics.beginFill(0x000000);
			gauge.graphics.drawRect(newWidth, 0, this.tileWidth - newWidth, GAUGE_HEIGHT);
			gauge.graphics.endFill();
			gauge.visible = true;
		}
	}

	function updateHealthyNode(node:VisiblyHealthyNode, deltaTime:Float) {
		this.updateGauge(node.visible.sprite, "health", node.health, HEALTH_COLOR);
	}

	function updateManaedNode(node:VisiblyManaedNode, deltaTime:Float) {
		if (node.mana.changedThisRound && node.mana.level >= node.mana.max) {
			var gauge = node.visible.sprite.getChildByName("mana");
			gauge.visible = false; // we hide the mana gauge when it's full
		} else {
			this.updateGauge(node.visible.sprite, "mana", node.mana, TOOLED_COLOR);
		}
	}
}
