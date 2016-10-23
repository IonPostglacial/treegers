package tmx;

class XmlDef {
	public static function defget(xml:Xml, attributeName:String, defaultValue:String):String {
		var value = xml.get(attributeName);
		return if (value == null) {
			defaultValue;
		} else {
			value;
		}
	}
}
