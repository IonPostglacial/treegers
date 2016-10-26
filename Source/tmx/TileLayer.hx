package tmx;

import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.Int32Array;

import openfl.utils.ByteArray;
import openfl.utils.CompressionAlgorithm;

import geometry.Coordinates;
import geometry.Map2D;
import geometry.HexagonalMap;
import geometry.OrthogonalMap;


class TileLayer extends Layer {
	public var data(default, null):Vector<Int>;
	public var tiles(default,null):Map2D<Int>;

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
				}
				var uncompressedData = Int32Array.fromBytes(dataBytes);

				data = new Vector(uncompressedData.length);
				for (i in 0...uncompressedData.length) {
					data[i] = uncompressedData[i];
				}
			} else {
				trace("oops !"); return;
			}
		}
		switch(orientation) {
		case Orientation.Hexagonal:
			tiles = HexagonalMap.fromVector(data, width, height);
		default:
			tiles = OrthogonalMap.fromVector(data, width, height);
		}
	}
}
