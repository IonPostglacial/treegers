package game.components;

import game.actions.Action;

class Controled
{
	public var oldPosition:hex.Position;
	public var orders:Array<Action>;
	public var currentOrder(get,never):Action;

	public function new()
	{
		this.oldPosition = null;
		this.orders = [];
	}

	public function get_currentOrder()
	{
		return orders[orders.length - 1];
	}
}
