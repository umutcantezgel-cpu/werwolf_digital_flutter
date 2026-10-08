import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

/// Erzeugt die Figurenkarten der Stadtbewohner B01–B44 aus `bewohner.json` neu und schreibt sie
/// in `data/figuren/karten.json`. BW bleibt unverändert; bei R01–R20 dürfen sich nur Breite
/// (innerhalb der Statur-Klasse) und Kopfgröße ändern ([rollenVariante]).
///
/// Je Bewohner werden [_varianten] freie Varianten gebrannt; gewählt wird die, deren größte
/// Ähnlichkeit zu allen anderen Figuren am kleinsten ist (Maß der Sichtprüfer, siehe
/// [vergleiche]). Drei Durchgänge, damit auch frühe Figuren gegen spätere geprüft werden.
/// Deterministisch. `dart run bin/bewohnerkarten.dart`
const _varianten = 32, _rollenVarianten = 16;

Map<String, dynamic> _lies(String pfad) => jsonDecode(File(pfad).readAsStringSync()) as Map<String, dynamic>;

void main() {
  const kartenPfad = 'data/figuren/karten.json';
  final daten = _lies(kartenPfad);
  final alt = [for (final k in daten['karten'] as List) k as Map<String, dynamic>];
  final bewohner = [
    for (final b in _lies('../burgstadt_core/data/stadt/bewohner.json')['bewohner'] as List) b as Map<String, dynamic>,
  ];
  final baker = FigurBaker({
    ...kTeileBasis,
    ...teileAusJson(_lies('data/figuren/teile_koepfe.json')),
    ...teileAusJson(_lies('data/figuren/teile_kleidung.json')),
  });
  final statur = {
    for (final f in _lies('data/figuren/rollen.json')['figuren'] as List)
      (f as Map<String, dynamic>)['id'] as String: f['statur'] as String? ?? 'normal',
  };
  final bewohnerNach = {for (final b in bewohner) b['id'] as String: b};

  // Kandidaten je Figur einmal brennen: BW fest, Rollen [_rollenVarianten], Bewohner [_varianten]
  final uhr = Stopwatch()..start();
  final ids = <String>[];
  final kandidaten = <List<(Figurenkarte, Figurenbild)>>[];
  // Nur Varianten, die die Sprite-Prüfung in Stehen und Gehen bestehen (sonst null)
  (Figurenkarte, Figurenbild)? mit(Figurenkarte k) =>
      pruefeFigur(baker.backe(k, animationen: ['stehen', 'gehen'])).isEmpty ? (k, Figurenbild.backe(baker, k)) : null;
  List<(Figurenkarte, Figurenbild)> gueltig(Iterable<(Figurenkarte, Figurenbild)?> l, String id) {
    final out = [for (final x in l) ?x];
    if (out.isEmpty) throw StateError('$id: keine Variante besteht die Sprite-Prüfung');
    return out;
  }

  // Karten, wie sie in der Datei stehen (für Rollen: Variante 0 = genau dieses Objekt)
  final ausDatei = [for (final j in alt) Figurenkarte.ausJson(j)];
  for (var i = 0; i < alt.length; i++) {
    final id = ausDatei[i].id;
    ids.add(id);
    if (RegExp(r'^B\d').hasMatch(id)) {
      kandidaten.add(gueltig([for (var v = 0; v < _varianten; v++) mit(bewohnerKarte(bewohnerNach[id]!, v))], id));
    } else if (id.startsWith('R')) {
      kandidaten.add(gueltig([for (var v = 0; v < _rollenVarianten; v++) mit(rollenVariante(ausDatei[i], statur[id]!, v))], id));
    } else {
      kandidaten.add(gueltig([mit(ausDatei[i])], id));
    }
  }
  stdout.writeln('${ids.length} Figuren, ${kandidaten.fold<int>(0, (n, l) => n + l.length)} gültige Kandidaten (${uhr.elapsed.inSeconds} s)');

  final wahl = List<int?>.generate(ids.length, (i) => kandidaten[i].length == 1 ? 0 : null);
  for (var durchgang = 0; durchgang < 4; durchgang++) {
    var geaendert = 0;
    for (var i = 0; i < ids.length; i++) {
      if (kandidaten[i].length == 1) continue;
      var besteV = 0;
      var besteWert = double.infinity;
      for (var v = 0; v < kandidaten[i].length; v++) {
        final bild = kandidaten[i][v].$2;
        var schlimmste = -double.infinity;
        for (var j = 0; j < ids.length; j++) {
          final w = wahl[j];
          if (j == i || w == null) continue;
          schlimmste = math.max(schlimmste, vergleiche(bild, kandidaten[j][w].$2).wert);
        }
        // kleine Vorliebe für die Fassung aus der Datei (Rollen: Kanon-Werte)
        if (identical(kandidaten[i][v].$1, ausDatei[i])) schlimmste -= 0.01;
        if (schlimmste < besteWert) {
          besteWert = schlimmste;
          besteV = v;
        }
      }
      if (wahl[i] != besteV) geaendert++;
      wahl[i] = besteV;
    }
    stdout.writeln('Durchgang ${durchgang + 1}: $geaendert Wahlen geändert');
    if (geaendert == 0) break;
  }

  final karten = [for (var i = 0; i < ids.length; i++) kandidaten[i][wahl[i]!].$1];
  final bilder = [for (var i = 0; i < ids.length; i++) kandidaten[i][wahl[i]!].$2];
  final zeilen = [
    for (var i = 0; i < ids.length; i++) identical(karten[i], ausDatei[i]) ? jsonEncode(alt[i]) : jsonEncode(karteAlsJson(karten[i])),
  ];
  File(kartenPfad).writeAsStringSync('{"version":1,"karten":[\n${zeilen.join(',\n')}\n]}\n');

  // Bericht: ähnlichste Paare über alle Figuren
  final paare = <(double, String)>[];
  var verwechselbar = 0;
  for (var i = 0; i < karten.length; i++) {
    for (var j = i + 1; j < karten.length; j++) {
      final a = vergleiche(bilder[i], bilder[j]);
      if (a.verwechselbar) verwechselbar++;
      paare.add((a.wert, '${karten[i].id} ≈ ${karten[j].id}: $a${a.verwechselbar ? ' VERWECHSELBAR' : ''}'));
    }
  }
  paare.sort((a, b) => b.$1.compareTo(a.$1));
  stdout.writeln('Ähnlichste Paare:');
  for (final p in paare.take(8)) {
    stdout.writeln('  ${p.$2}');
  }
  stdout.writeln('Verwechselbare Paare (IoU ≥ 0,84 und Farbabstand ≤ 46): $verwechselbar');
}
