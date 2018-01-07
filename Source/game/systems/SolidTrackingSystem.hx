package game.systems;

import ash.core.Engine;
import ash.core.System;

import game.map.WorldMap;
import game.nodes.SolidNode;


class SolidTrackingSystem extends System {
	var worldMap:WorldMap;

	public function new(worldMap) {
		super();
		this.worldMap = worldMap;
	}

	override public function addToEngine(engine:Engine) {
		var obstacles = engine.getNodeList(SolidNode);
		for (obstacle in obstacles) {
			this.worldMap.obstacles.push(obstacle);
		}
		obstacles.nodeAdded.add(function (obstacle) {
			this.worldMap.obstacles.push(obstacle);
		});
		obstacles.nodeRemoved.add(function (node:SolidNode) {
			this.worldMap.obstacles.remove(node);
		});
		super.addToEngine(engine);
	}
}
