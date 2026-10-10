import 'package:flutter/services.dart';
import 'package:krimidinner_kanon/krimidinner_kanon.dart' show KrimiKanon, istKanonDatei;

/// Ordner des Kanons „Spuk im Gewölbe“ im Asset-Bündel (siehe pubspec.yaml).
const kanonOrdner = 'krimidinner/spuk-im-gewoelbe/10_kanon/';

/// Lädt den Kanon (im Test ersetzbar).
typedef KanonLader = Future<KrimiKanon> Function();

Future<KrimiKanon>? _geladen;

/// Liest alle `K*.md` direkt im Kanonordner (ohne Unterordner) und baut daraus
/// den Kanon. Das Ergebnis bleibt für die Laufzeit der App zwischengespeichert;
/// nach einem Fehler wird beim nächsten Aufruf neu gelesen.
Future<KrimiKanon> ladeGewoelbeKanon() =>
    _geladen ??= _lade(rootBundle).catchError((Object fehler, StackTrace stapel) {
      _geladen = null;
      Error.throwWithStackTrace(fehler, stapel);
    });

Future<KrimiKanon> _lade(AssetBundle bundle) async {
  final manifest = await AssetManifest.loadFromAssetBundle(bundle);
  final pfade = manifest.listAssets().where((pfad) {
    if (!pfad.startsWith(kanonOrdner)) return false;
    final name = pfad.substring(kanonOrdner.length);
    return !name.contains('/') && istKanonDatei(name);
  }).toList()
    ..sort();
  final inhalte = <String, String>{
    for (final pfad in pfade) pfad.substring(kanonOrdner.length): await bundle.loadString(pfad),
  };
  if (inhalte.isEmpty) throw StateError('Im Asset-Bündel fehlt der Kanon unter $kanonOrdner.');
  return KrimiKanon.ausText(inhalte);
}
