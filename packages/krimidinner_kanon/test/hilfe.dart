// Testhilfe: liest den echten Kanon über dart:io (nur in Tests, nie in lib/).
import 'dart:io';

import 'package:krimidinner_kanon/krimidinner_kanon.dart';

const kanonPfad = 'krimidinner/spuk-im-gewoelbe/10_kanon';

/// Sucht den Kanonordner vom Arbeitsverzeichnis aufwärts.
Directory findeKanonOrdner() {
  var dir = Directory.current.absolute;
  while (true) {
    final kandidat = Directory('${dir.path}/$kanonPfad');
    if (kandidat.existsSync()) return kandidat;
    final eltern = dir.parent;
    if (eltern.path == dir.path) {
      throw StateError(
        'Kein Ordner $kanonPfad oberhalb von ${Directory.current.path}.',
      );
    }
    dir = eltern;
  }
}

/// Alle Dateien des Kanonordners (ohne Unterordner) als Name → Inhalt.
Map<String, String> kanonDateien() => {
  for (final f in findeKanonOrdner().listSync().whereType<File>())
    f.uri.pathSegments.last: f.readAsStringSync(),
};

KrimiKanon? _kanon;

/// Der echte Kanon, einmal gelesen.
KrimiKanon get echterKanon => _kanon ??= KrimiKanon.ausText(kanonDateien());

Gewoelbe? _gewoelbe;

/// Zugriffsschicht auf den echten Kanon.
Gewoelbe get gewoelbe => _gewoelbe ??= Gewoelbe(echterKanon);

/// Text für Vergleiche: Leerraum zusammengezogen, getrimmt.
String normal(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();

/// HTML-Entitäten zurück in Zeichen (für Inhaltsprüfungen am Druck-HTML).
String ohneHtml(String html) => html
    .replaceAll(RegExp(r'<br>'), ' ')
    .replaceAll(RegExp(r'<[^>]+>'), ' ')
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&#39;', "'")
    .replaceAll('&amp;', '&');
