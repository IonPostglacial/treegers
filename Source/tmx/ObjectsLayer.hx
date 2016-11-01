package tmx;

using tmx.XmlDef;


class ObjectsLayer extends Layer {
	public var objects(default,null):Array<TileObject> = [];

	public function new(map) {
		super(map);
	}

	override function loadFromXml(xml:Xml) {
		super.loadFromXml(xml);
		var objectElements = xml.elementsNamed("object");
		for (objectElement in objectElements) {
			var object = new TileObject();
			object.id = Std.parseInt(objectElement.defget("id", "0"));
			object.gid = Std.parseInt(objectElement.defget("gid", "0"));
			object.x = Std.parseInt(objectElement.defget("x", "0"));
			object.y = Std.parseInt(objectElement.defget("y", "0"));
			object.width = Std.parseInt(objectElement.defget("width", "0"));
			object.height = Std.parseInt(objectElement.defget("height", "0"));
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
