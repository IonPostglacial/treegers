package tmx;

import Type;


class XmlDef {
	public static function fillObject<T>(xml:Xml, c:Class<T>, object:T) {
		for (field in Type.getInstanceFields(c)) {
			var currentFieldValue = Reflect.field(object, field);
			var newFieldValue:Dynamic = null;
			var rawValue = xml.get(field.toLowerCase());
			if (rawValue == null) {
				continue;
			}
			switch (Type.typeof(currentFieldValue)) {
			case ValueType.TBool:
				newFieldValue = rawValue == "1";
			case ValueType.TInt:
				newFieldValue = Std.parseInt(rawValue);
			case ValueType.TFloat:
				newFieldValue = Std.parseFloat(rawValue);
			case ValueType.TClass(c):
				if (c == String) {
					newFieldValue = rawValue;
				}
			default: // pass
			}
			if (newFieldValue != null) {
				Reflect.setField(object, field, newFieldValue);
			}
		}
	}
}
