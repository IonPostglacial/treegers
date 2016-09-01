package game.components;

import game.orders.Order;

class Controled
{
	public var oldPosition:hex.Position;
	public var orders:Array<Order>;
	public var currentOrder(get,never):Order;

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
