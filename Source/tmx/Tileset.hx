package tmx;


@:publicFields
class Tileset {
	var firstGid:Int = 0;
	var source:String = "";
	var name:String = "<unnamed>";
	var tileWidth:Int = 0;
	var tileHeight:Int = 0;
	var spacing:Int = 0;
	var margin:Int = 0;
	var tileCount:Int = 0;
	var columns:Int = 0;
	var properties(default,null):Map<String, Dynamic> = new Map();
	var image:openfl.display.BitmapData;
	var terrains:Map<Int, Array<Int>> = new Map();
	var animationFramesIds:Map<Int, Array<Int>> = new Map();
	var animationFramesDurations:Map<Int, Array<Int>> = new Map();
	var terrainsNumberByTile = 0;

	function new(orientation:Orientation) {
		terrainsNumberByTile = orientation.adjacentTilesNumber();
	}

	function loadFromXml(xml:Xml) {
		ObjectExt.fromMap(xml, Tileset, this);
		var imageElements = xml.elementsNamed('image');
		for (imageElement in imageElements) {
			var imagePath = imageElement.get("source");
			image = openfl.Assets.getBitmapData("assets/" + imagePath);
		}
		var tileElements = xml.elementsNamed('tile');
		for (tileElement in tileElements) {
			var tileId = Std.parseInt(tileElement.get("id"));
			var rawTerrain = tileElement.get("terrain");
			if (rawTerrain != null) {
				var tileTerrain = rawTerrain.split(",").map(function (s) {
					var n = Std.parseInt(s);
					if (n == null) {
						return 0;
					} else {
						return n + 1;
					}
				});
				this.terrains.set(tileId, tileTerrain);
			}
			var animations = tileElement.elementsNamed('animation');
			var frameIds = [];
			var frameDurations = [];
			for (animation in animations) {
				var frames = animation.elementsNamed('frame');
				for (frame in frames) {
					frameIds.push(Std.parseInt(frame.get("tileid")));
					frameDurations.push(Std.parseInt(frame.get("duration")));
				}
			}
			if (frameIds.length > 0) {
				this.animationFramesIds.set(tileId, frameIds);
				this.animationFramesDurations.set(tileId, frameDurations);
			}
		}
	}
}
