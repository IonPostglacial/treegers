package tmx;

import haxe.io.Int32Array;

import grid.Map2D;
import grid.hex.CompactMap as HexMap;
import grid.ortho.CompactMap as OrthoMap;


class TileLayer extends Layer {
	public var data(default, null):Array<Int>;
	public var tiles(default,null):Map2D<Int>;

	static inline var ENCODING_CSV = "csv";
	static inline var ENCODING_BASE64 = "base64";
	static inline var COMPRESSION_GZIP = "gzip";
	static inline var COMPRESSION_ZLIB = "zlib";

	function new(map) {
		super(map);
	}

	public static inline function fromXml(xml, map) {
		var tileLayer = new TileLayer(map);
		tileLayer.loadFromXml(xml);
		return tileLayer;
	}

	override function loadFromXml(xml:Xml) {
		super.loadFromXml(xml);
		var dataElements = xml.elementsNamed("data");
		for (dataElement in dataElements) {
			var rawData = StringTools.trim(dataElement.firstChild().nodeValue);
			if (dataElement.get("encoding") == ENCODING_BASE64) {
				var decodedData = haxe.crypto.Base64.decode(rawData);
				var uncompressedData:Int32Array;
				switch (dataElement.get("compression")) {
				case null:
					uncompressedData = Int32Array.fromBytes(decodedData);
				case COMPRESSION_ZLIB:
					var dataBytes = haxe.zip.Uncompress.run(decodedData);
					uncompressedData = Int32Array.fromBytes(dataBytes);
				default:
					uncompressedData = new Int32Array(0);
					trace("unsupported data format");
				}
				data = new Array();
				for (i in 0...uncompressedData.length) {
					data.push(uncompressedData[i]);
				}
			} else {
				trace("oops !"); return;
			}
		}
		switch(orientation) {
		case Orientation.Hexagonal:
			tiles = HexMap.fromArray(data, width, height);
		default:
			tiles = OrthoMap.fromArray(data, width, height);
		}
	}
}
