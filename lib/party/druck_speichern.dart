import 'dart:typed_data';

import 'druck_speichern_stub.dart' if (dart.library.js_interop) 'druck_speichern_web.dart' as umsetzung;

/// Bietet eine Datei zum Speichern an (Browser: Download). `false`, wenn das
/// auf diesem Gerät nicht geht.
bool dateiAnbieten(String name, Uint8List bytes, {String typ = 'application/pdf'}) => umsetzung.dateiAnbieten(name, bytes, typ: typ);
