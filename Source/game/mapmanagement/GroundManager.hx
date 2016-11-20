package game.mapmanagement;

class GroundManager {
	public var grids(default,null):Array<GroundGrid> = [];
	var tileObjectsListeners:Array<TileObjectListener> = [];

	public function new(map:tmx.TiledMap) {
		for (vehicle in Type.allEnums(Vehicle)) {
			var obstacles = new GroundGrid(map, vehicle);
			this.addTileObjectsListeners(obstacles);
			this.grids.push(obstacles);
		}
	}

	public inline function forVehicle(vehicle:Vehicle):GroundGrid {
		return this.grids[Type.enumIndex(vehicle)];
	}

	public function setObjectStatus(tileObject:tmx.TileObject, active:Bool) {
		tileObject.active = active;
		for (listener in tileObjectsListeners) {
			listener.tileObjectStatusChanged(tileObject, active);
		}
	}

	public inline function addTileObjectsListeners(listener:TileObjectListener) {
		this.tileObjectsListeners.push(listener);
	}
}
