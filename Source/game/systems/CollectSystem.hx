package game.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;

import game.Stage;
import game.components.Collector;
import game.nodes.CollectibleNode;
import game.nodes.CollectorNode;
import game.nodes.MovingNode;

class CollectSystem extends System {
	var engine:Engine;
	var stage:Stage;
	var collectibles:NodeList<CollectibleNode>;
	var collectors:NodeList<CollectorNode>;
	var movers:NodeList<MovingNode>;

	public function new(stage:Stage) {
		this.stage = stage;
		super();
	}

	override public function update(deltaTime:Float) {
		for (collector in collectors) {
			collector.collector.expirationTime -= deltaTime;
			if (collector.collector.expirationTime <= 0) {
				for (component in collector.collector.backup) {
					collector.entity.add(component);
				}
				collector.entity.remove(Collector);
			}
		}
		for (collectible in collectibles) {
			for (mover in movers) {
				if (mover.entity != collectible.entity && mover.position.equals(collectible.position)) {
					switch (collectible.collectible.effectDuration) {
					case Some(time):
						var backup = [];
						for (component in collectible.collectible.components) {
							var oldComponent = mover.entity.get(Type.getClass(component));
							if (oldComponent != null) {
								backup.push(oldComponent);
							}
						}
						mover.entity.add(new Collector(backup, time));
					default: // Nothing to do
					}
					for (component in collectible.collectible.components) {
						mover.entity.add(component);
					}
					engine.removeEntity(collectible.entity);
					break;
				}
			}
		}
	}

	override public function addToEngine(engine:Engine) {
		this.engine = engine;
		collectibles = engine.getNodeList(CollectibleNode);
		collectors = engine.getNodeList(CollectorNode);
		movers = engine.getNodeList(MovingNode);
		super.addToEngine(engine);
	}
}
