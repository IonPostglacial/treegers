package graph;

interface Pathfindable<T> {
	public function neighborsOf(position:T):Iterable<T>;
	public function distanceBetween(start:T, goal:T):Int;
}
