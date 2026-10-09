import 'dart:js_interop';
import 'dart:typed_data';

/// Download im Browser über einen Blob-Link (nur `dart:js_interop`, ohne Paket).
bool dateiAnbieten(String name, Uint8List bytes, {String typ = 'application/pdf'}) {
  final blob = _Blob([bytes.toJS].toJS, _BlobOptionen(type: typ.toJS));
  final url = _createObjectURL(blob);
  final a = _dokument.createElement('a'.toJS) as _Link;
  a.href = url;
  a.download = name.toJS;
  _dokument.body.appendChild(a);
  a.click();
  a.remove();
  _revokeObjectURL(url);
  return true;
}

@JS('Blob')
extension type _Blob._(JSObject _) implements JSObject {
  external factory _Blob(JSArray<JSAny> teile, _BlobOptionen optionen);
}

extension type _BlobOptionen._(JSObject _) implements JSObject {
  external factory _BlobOptionen({JSString type});
}

@JS('URL.createObjectURL')
external JSString _createObjectURL(_Blob blob);

@JS('URL.revokeObjectURL')
external void _revokeObjectURL(JSString url);

@JS('document')
external _Dokument get _dokument;

extension type _Dokument._(JSObject _) implements JSObject {
  external JSObject createElement(JSString tag);
  external _Element get body;
}

extension type _Element._(JSObject _) implements JSObject {
  external void appendChild(JSObject kind);
}

extension type _Link._(JSObject _) implements JSObject {
  external set href(JSString wert);
  external set download(JSString wert);
  external void click();
  external void remove();
}
