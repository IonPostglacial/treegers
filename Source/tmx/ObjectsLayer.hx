package tmx;

import grid.ICoordinateSystem;


class ObjectsLayer extends Layer {
	public var objects(default,null):Array<TileObject> = [];
	var coordinates:ICoordinateSystem;

	public function new(map) {
		super(map);
		this.coordinates = map.coordinateSystem;
	}

	override function loadFromXml(xml:Xml) {
		super.loadFromXml(xml);
		var objectElements = xml.elementsNamed("object");
		for (objectElement in objectElements) {
			var object = new TileObject();
			ObjectExt.fromMap(objectElement, TileObject, object);
			var objectCoords = this.coordinates.fromPixel(object.x + object.width / 2, object.y - object.height / 2);
			object.coordX = objectCoords.x;
			object.coordY = objectCoords.y;
			for (element in objectElement.elements()) {
				if (element.nodeName == "properties") {
					for (propertyElement in element.elements()) {
						object.properties.set(propertyElement.get("name"), propertyElement.get("value"));
					}
				}
			}
			this.objects.push(object);
		}
	}
}
