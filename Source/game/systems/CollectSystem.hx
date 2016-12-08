package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.core.System;

import game.components.Collectible;
import game.components.Collector;
import game.nodes.MovingNode;
import game.components.Position;


class CollectibleNode extends Node<CollectibleNode> {
	public var collectible:Collectible;
	public var position:Position;
}

class CollectorNode extends Node<CollectorNode> {
	public var collector:Collector;
	public var position:Position;
}

class CollectSystem extends System {
	var engine:Engine;
	var collectibles:NodeList<CollectibleNode>;
	var collectors:NodeList<CollectorNode>;
	var movers:NodeList<MovingNode>;

	public function new() {
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
					if (collectible.collectible.effectDuration != null) {
						var backup = [];
						for (component in collectible.collectible.components) {
							var oldComponent = mover.entity.get(Type.getClass(component));
							if (oldComponent != null) {
								backup.push(oldComponent);
							}
						}
						mover.entity.add(new Collector(backup, collectible.collectible.effectDuration));
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
