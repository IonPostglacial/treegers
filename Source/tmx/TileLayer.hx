package tmx;

import haxe.ds.Vector;
import haxe.io.Bytes;

import lime.utils.Int32Array;
import openfl.utils.ByteArray;
import openfl.utils.CompressionAlgorithm;

import geometry.Coordinates;
import geometry.HexagonalMap;


class TileLayer extends Layer {
	public var data(default, null):Vector<Int>;
	public var tiles(default,null):haxe.Constraints.IMap<Coordinates, Int>;

	static inline var ENCODING_CSV = "csv";
	static inline var ENCODING_BASE64 = "base64";
	static inline var COMPRESSION_GZIP = "gzip";
	static inline var COMPRESSION_ZLIB = "zlib";

	public function new(map) {
		super(map);
	}

	override function loadFromXml(xml:Xml) {
		super.loadFromXml(xml);
		var dataElements = xml.elementsNamed("data");
		for (dataElement in dataElements) {
			var rawData = StringTools.trim(dataElement.firstChild().nodeValue);
			if (dataElement.get("encoding") == ENCODING_BASE64) {
				var decodedData = haxe.crypto.Base64.decode(rawData);
				var dataBytes = ByteArray.fromBytes(decodedData);
				if (dataElement.get("compression") == COMPRESSION_ZLIB) {
					dataBytes.uncompress(CompressionAlgorithm.ZLIB);
				} else {
					dataBytes.uncompress(CompressionAlgorithm.DEFLATE);
				}
				var uncompressedData = Int32Array.fromBytes(dataBytes.toArrayBuffer());

				data = new Vector(uncompressedData.length);
				for (i in 0...uncompressedData.length) {
					data[i] = uncompressedData[i];
				}
			} else {
				trace("oops !"); return;
			}
		}
		switch(map.orientation) {
		case Orientation.Hexagonal:
			tiles = HexagonalMap.fromVector(data, map.width, map.height);
		default:
			tiles = new Map<Coordinates, Int>(); // Implement it
		}
	}
}
