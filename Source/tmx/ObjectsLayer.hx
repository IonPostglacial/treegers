package tmx;

import geometry.CoordinatesSystem;

using tmx.XmlDef;


class ObjectsLayer extends Layer {
	public var objects(default,null):Array<TileObject> = [];
	var coordinates:CoordinatesSystem;

	public function new(map) {
		super(map);
		this.coordinates = map.coordinates;
	}

	override function loadFromXml(xml:Xml) {
		super.loadFromXml(xml);
		var objectElements = xml.elementsNamed("object");
		for (objectElement in objectElements) {
			var object = new TileObject();
			objectElement.fillObject(TileObject, object);
			object.coords = this.coordinates.fromPixel(new geometry.Vector2D(object.x + object.width / 2, object.y - object.height / 2));
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
