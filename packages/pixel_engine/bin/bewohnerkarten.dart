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
/// Deterministisch. `dart run bin/bewohnerkarten.dart [--neu B01,B02,…]`
///
/// `--neu`: Für die genannten Bewohner ist die Karte aus der Datei kein Kandidat, etwa nach einer
/// Änderung von Name, Geschlecht oder Frisur in `bewohner.json`; sonst könnte die alte Karte gewinnen.
const _varianten = 32, _farbVarianten = 64, _rollenVarianten = 24;

const _bewohnerPfad = '../burgstadt_core/data/stadt/bewohner.json', _rollenPfad = 'data/figuren/rollen.json';

Map<String, dynamic> _lies(String pfad) => jsonDecode(File(pfad).readAsStringSync()) as Map<String, dynamic>;

void main(List<String> args) {
  final i = args.indexOf('--neu');
  final neu = i >= 0 && i + 1 < args.length ? args[i + 1].split(',').toSet() : const <String>{};
  const kartenPfad = 'data/figuren/karten.json';
  final daten = _lies(kartenPfad);
  final alt = [for (final k in daten['karten'] as List) k as Map<String, dynamic>];
  final bewohnerDatei = _lies(_bewohnerPfad);
  final bewohner = [for (final b in bewohnerDatei['bewohner'] as List) b as Map<String, dynamic>];
  final baker = FigurBaker({
    ...kTeileBasis,
    ...teileAusJson(_lies('data/figuren/teile_koepfe.json')),
    ...teileAusJson(_lies('data/figuren/teile_kleidung.json')),
  });
  final rollenDaten = {
    for (final f in _lies(_rollenPfad)['figuren'] as List) (f as Map<String, dynamic>)['id'] as String: f,
  };
  final statur = {for (final e in rollenDaten.entries) e.key: e.value['statur'] as String? ?? 'normal'};
  bool hoseErfunden(String id) =>
      ((rollenDaten[id]?['erfunden'] as List?) ?? const []).any((e) => (e as String).startsWith('Hose'));
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

  // Umgefärbte Bewohner-Kandidaten → ihre Kleiderfarben (werden bei Wahl zurückgeschrieben)
  final umgefaerbt = Map<Figurenkarte, Map<String, (String, int)>>.identity();
  // Karten, wie sie in der Datei stehen (für Rollen: Variante 0 = genau dieses Objekt)
  final ausDatei = [for (final j in alt) Figurenkarte.ausJson(j)];
  for (var i = 0; i < alt.length; i++) {
    final id = ausDatei[i].id;
    ids.add(id);
    if (RegExp(r'^B\d').hasMatch(id)) {
      final b = bewohnerNach[id]!;
      // Die Karte aus der Datei ist Kandidat 0 (mit kleiner Vorliebe): Was geprüft ist, bleibt,
      // solange es kein Paar bildet.
      final liste = <(Figurenkarte, Figurenbild)?>[
        if (kopfbedeckungLesbar(ausDatei[i]) && !neu.contains(id)) mit(ausDatei[i]),
        for (var v = 0; v < _varianten; v++) mit(bewohnerKarte(b, v)),
      ];
      for (var v = 0; v < _farbVarianten; v++) {
        final f = umfaerbung(b, v);
        final k = mit(bewohnerKarte(b, v, farben: f));
        if (k != null) umgefaerbt[k.$1] = f;
        liste.add(k);
      }
      kandidaten.add(gueltig(liste, id));
    } else if (id.startsWith('R')) {
      final hosen = hoseErfunden(id) ? rollenHosen((rollenDaten[id]!['unterteil'] as Map)['typ'] as String) : null;
      kandidaten.add(gueltig([for (var v = 0; v < _rollenVarianten; v++) mit(rollenVariante(ausDatei[i], statur[id]!, v, hosen: hosen))], id));
    } else {
      kandidaten.add(gueltig([mit(ausDatei[i])], id));
    }
  }
  stdout.writeln('${ids.length} Figuren, ${kandidaten.fold<int>(0, (n, l) => n + l.length)} gültige Kandidaten (${uhr.elapsed.inSeconds} s)');

  final wahl = List<int?>.generate(ids.length, (i) => kandidaten[i].length == 1 ? 0 : null);
  for (var durchgang = 0; durchgang < 10; durchgang++) {
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
          final a = vergleiche(bild, kandidaten[j][w].$2);
          // Grenzüberschreitungen zählen weit stärker als bloße Ähnlichkeit
          schlimmste = math.max(schlimmste, a.wert + (a.verwechselbar ? 1.0 : 0.0));
        }
        // kleine Vorliebe für die Fassung aus der Datei (Rollen: Kanon-Werte) und für die
        // Kleiderfarben des Datensatzes (Bewohner)
        if (identical(kandidaten[i][v].$1, ausDatei[i])) schlimmste -= 0.01;
        if (umgefaerbt.containsKey(kandidaten[i][v].$1)) schlimmste += 0.03;
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
  // Geänderte (erfundene) Hosenfarben der Rollen in rollen.json zurückschreiben
  var rollenText = File(_rollenPfad).readAsStringSync();
  for (var i = 0; i < ids.length; i++) {
    if (!ids[i].startsWith('R')) continue;
    final neu = karten[i].materialien['hose'], alt = ausDatei[i].materialien['hose'];
    if (neu == null || alt == null || (neu.rampe == alt.rampe && neu.stufe == alt.stufe)) continue;
    final start = rollenText.indexOf('"id": "${ids[i]}"');
    final u = rollenText.indexOf('"unterteil":', start);
    final ende = rollenText.indexOf('}', u) + 1;
    final typ = (rollenDaten[ids[i]]!['unterteil'] as Map)['typ'];
    rollenText = '${rollenText.substring(0, u)}"unterteil": { "typ": "$typ", "rampe": ${neu.rampe}, "stufe": ${neu.stufe} }${rollenText.substring(ende)}';
    stdout.writeln('${ids[i]}: Hose (erfunden) → [${neu.rampe},${neu.stufe}]');
  }
  File(_rollenPfad).writeAsStringSync(rollenText);
  // Gewählte Umfärbungen in bewohner.json zurückschreiben (Daten und Figuren bleiben gleich)
  var neuGefaerbt = 0;
  for (var i = 0; i < ids.length; i++) {
    final f = umgefaerbt[karten[i]];
    if (f == null) continue;
    neuGefaerbt++;
    for (final k in (bewohnerNach[ids[i]]!['aussehen'] as Map)['kleidung'] as List) {
      final x = f[(k as Map)['teil']]!;
      k['rampe'] = x.$1;
      k['stufe'] = x.$2;
    }
  }
  File(_bewohnerPfad).writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(bewohnerDatei)}\n');
  stdout.writeln('Umgefärbt (Datensatz angepasst): $neuGefaerbt Bewohner');
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
