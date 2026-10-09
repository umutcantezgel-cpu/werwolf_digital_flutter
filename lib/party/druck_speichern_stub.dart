import 'dart:typed_data';

/// Ohne Browser gibt es keinen Download.
bool dateiAnbieten(String name, Uint8List bytes, {String typ = 'application/pdf'}) => false;
