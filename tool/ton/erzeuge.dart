/// Erzeugt alle Klänge und Musikstücke nach assets/burgstadt/ton/ (Auftrag A-603a).
///
/// Aufruf aus tool/ton:  dart run erzeuge.dart [zielordner]
/// Standard-Zielordner: ../../assets/burgstadt/ton
///
/// Ablauf je Datei: Synthese, bei Schleifen Schleifenpunkt in ruhiger Stelle setzen,
/// Gleichanteil entfernen, kurze Ein-/Ausblendung, Normalisierung auf −1 dBFS,
/// 16 Bit PCM mono 22 050 Hz. Die Ausgabe ist deterministisch.
library;

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'geraeusche.dart';
import 'klangwerk.dart';
import 'musik.dart';
import 'umgebung.dart';

/// Ein Eintrag der Klangliste: Dateiname ohne Endung, Erzeuger und Beschreibung.
class Eintrag {
  const Eintrag(
    this.name,
    this.erzeuge, {
    required this.beschreibung,
    this.schleife = false,
    this.ausblendSek = 0.03,
    this.suchfenster,
  });

  final String name;
  final Float64List Function() erzeuge;
  final String beschreibung;

  /// Schleife (`*_schleife` oder Musik): Anfang und Ende werden nahtlos zusammengeführt.
  final bool schleife;

  /// Länge der Ausblendung am Ende eines Einzelklangs in Sekunden.
  final double ausblendSek;

  /// Für Schleifen: Suchbereich um den Anfang in Sekunden (null = ganze Schleife).
  final double? suchfenster;
}

/// Alle Dateien der Liste (Auftrag A-603a, Punkt 6).
final List<Eintrag> eintraege = [
  Eintrag('uhrturm_schlag', uhrturmSchlag,
      beschreibung: 'Stadtuhr schlägt: tiefe Bronzeglocke mit Klöppelanschlag, 4 s Ausklang',
      ausblendSek: 0.15),
  Eintrag('uhrturm_viertel', uhrturmViertel,
      beschreibung: 'Viertelschlag: zwei hellere Glocken im Abstand von 0,9 s', ausblendSek: 0.2),
  Eintrag('wind_schleife', windSchleife,
      beschreibung: 'Schleife · Wind über die Mauer: gefiltertes Rauschen mit langsamen Böen',
      schleife: true),
  Eintrag('nebel_brummen_schleife', nebelBrummenSchleife,
      beschreibung:
          'Schleife · Nebel: sehr ruhige tiefe Fläche (41 Hz, Schwebung). Auf −1 dBFS normalisiert, '
          'im Spiel leise mischen',
      schleife: true),
  for (final v in [1, 2, 3, 4])
    Eintrag('schritt_pflaster_$v', () => schrittPflaster(v),
        beschreibung: 'Schritt auf Kopfsteinpflaster, Variante $v: Stein auf Stein mit drei Resonanzen'),
  for (final v in [1, 2, 3, 4])
    Eintrag('schritt_holz_$v', () => schrittHolz(v),
        beschreibung: 'Schritt auf Holzdielen, Variante $v: dumpfer Balken mit zwei Moden'),
  for (final v in [1, 2, 3, 4])
    Eintrag('schritt_stein_$v', () => schrittStein(v),
        beschreibung: 'Schritt auf Steinstufen, Variante $v: hart, hell, kurz klingend'),
  for (final v in [1, 2, 3, 4])
    Eintrag('schritt_schnee_$v', () => schrittSchnee(v),
        beschreibung: 'Schritt im Schnee, Variante $v: dicht gestreute Körner, weicher Körper'),
  Eintrag('tuer_eiche_auf', tuerEicheAuf,
      beschreibung: 'Eichentür öffnet sich: Knarren mit steigender Tonhöhe, Holzdumpf, Riegelklick'),
  Eintrag('tuer_eiche_zu', tuerEicheZu,
      beschreibung: 'Eichentür fällt ins Schloss: tiefer Körper, Riegelschnappen, kurzes Knarren'),
  Eintrag('tuer_eisen', tuerEisen,
      beschreibung: 'Eisentür: metallisches Dröhnen mit Plattenmoden, Schleifen, harter Anschlag'),
  Eintrag('truhe_auf', truheAuf,
      beschreibung: 'Holztruhe öffnet sich: Knarren, Riegelklirren, hohler Nachhall'),
  Eintrag('ruestung_klappern', ruestungKlappern,
      beschreibung: 'Rüstung klappert leise: Stoffrascheln und einzelne metallische Klirrer'),
  Eintrag('schluessel_klimpern', schluesselKlimpern,
      beschreibung: 'Schlüsselbund klimpert: viele kurze helle Klirrer'),
  Eintrag('fledermaus_flattern', fledermausFlattern,
      beschreibung: 'Fledermäuse: Flügelschläge als Hüllkurve auf Rauschen, kurze Chirps'),
  Eintrag('hund_fern', hundFern,
      beschreibung: 'Hund in der Ferne: zwei gedämpfte Kläffer, tiefpassgefiltert, mit Hall'),
  Eintrag('eule', eule, beschreibung: 'Eule ruft zweimal: weicher Ton mit leicht fallender Tonhöhe'),
  Eintrag('kaminglut_schleife', kaminGlutSchleife,
      beschreibung: 'Schleife · Kaminglut: dunkles Glühen mit zufälligen Knacksern', schleife: true),
  Eintrag('kessel_brodeln_schleife', kesselBrodelnSchleife,
      beschreibung: 'Schleife · Punschkessel brodelt: Blubbern über warmem Sieden', schleife: true),
  Eintrag('papier_rascheln', papierRascheln,
      beschreibung: 'Papier raschelt: kurze Körner aus gefiltertem Rauschen'),
  Eintrag('hinweis_gefunden', hinweisGefunden,
      beschreibung: 'Hinweis gefunden: kurzes, warmes Glöckchen-Arpeggio (D5, F5, A5, D6)'),
  Eintrag('fallakte_heften', fallakteHeften,
      beschreibung: 'Fallakte heften: Papierstapel, Klammerklick, kurzes Blättern'),
  Eintrag('teilen_senden', teilenSenden,
      beschreibung: 'Teilen oder Senden: Wisch mit wandernder Mitte und zwei kurze Pings'),
  Eintrag('ui_klick', uiKlick, beschreibung: 'Bedienklick: kurzer heller Tick', ausblendSek: 0.01),
  Eintrag('ui_zurueck', uiZurueck,
      beschreibung: 'Zurück: fallender Doppelton', ausblendSek: 0.05),
  Eintrag('detektivblick_an', detektivblickAn,
      beschreibung: 'Detektivblick an: steigendes Schimmern mit Tremolo und Hall'),
  Eintrag('detektivblick_aus', detektivblickAus,
      beschreibung: 'Detektivblick aus: fallendes Schimmern mit Hall'),
  Eintrag('schreck', schreck,
      beschreibung: 'Schreck: kurzer Streicher-Stich mit Reibung (Sekunde gegen Prim), Tremolo, Anstieg'),
  Eintrag('handylicht_klick', handylichtKlick,
      beschreibung: 'Handylicht an oder aus: mechanischer Klick mit kleinem Kontaktton', ausblendSek: 0.01),
  Eintrag('musik_gewoelbe_schleife', musikGewoelbeSchleife,
      beschreibung: 'Schleife, 60 s · Musik Gewölbe: Zither über Streicher-Teppich, D-Moll',
      schleife: true,
      suchfenster: 0.05),
  Eintrag('musik_gassen_schleife', musikGassenSchleife,
      beschreibung: 'Schleife, 60 s · Musik Gassen: Klarinetten-artige Melodie über Pizzicato, E-phrygisch',
      schleife: true,
      suchfenster: 0.05),
  Eintrag('musik_morgengrauen', musikMorgengrauen,
      beschreibung: 'Schleife, 60 s · Musik Morgengrauen: Flöten-artige Melodie, D-lydisch, Glocken',
      schleife: true,
      suchfenster: 0.05),
];

/// Sucht den Schleifenpunkt mit dem kleinsten Sprung (und möglichst kleiner Auslenkung)
/// und rotiert die Schleife dorthin. Im Suchfenster [fenster] um den Anfang, sonst überall.
Float64List schleifenpunktSuchen(Float64List x, double? fenster) {
  final n = x.length;
  var spitze = 0.0;
  for (final v in x) {
    spitze = math.max(spitze, v.abs());
  }
  final skala = spitze > 0 ? 1 / spitze : 1.0;
  final halb = fenster == null ? n : sekunden(fenster);
  final kandidaten = fenster == null
      ? Iterable<int>.generate(n)
      : Iterable<int>.generate(2 * halb + 1, (k) => (k - halb) % n);
  var bestR = 0;
  var bestKosten = double.infinity;
  for (final r in kandidaten) {
    final aktuell = x[r] * skala;
    final vorher = x[(r - 1 + n) % n] * skala;
    final kosten = (aktuell - vorher).abs() + 0.5 * aktuell.abs();
    if (kosten < bestKosten) {
      bestKosten = kosten;
      bestR = r;
    }
  }
  final out = Float64List(n);
  for (var i = 0; i < n; i++) {
    out[i] = x[(bestR + i) % n];
  }
  return out;
}

/// Vollständige Nachbearbeitung eines Eintrags bis zum Signal, das als WAV geschrieben wird.
Float64List nachbearbeiten(Eintrag e) {
  var x = e.erzeuge();
  if (e.schleife) {
    x = schleifenpunktSuchen(x, e.suchfenster);
  }
  gleichanteilEntfernen(x);
  einblenden(x, 0.002);
  ausblenden(x, e.schleife ? 0.002 : e.ausblendSek);
  gleichanteilEntfernen(x);
  normalisiere(x);
  return x;
}

/// Alle Dateien als WAV-Bytes, Schlüssel = Dateiname ohne Endung.
Map<String, Uint8List> erzeugeWavs() {
  final out = <String, Uint8List>{};
  for (final e in eintraege) {
    out[e.name] = wavBytes(nachbearbeiten(e));
  }
  return out;
}

String _laengeText(double sek) => '${sek.toStringAsFixed(2).replaceAll('.', ',')} s';

String _liste(List<(Eintrag, double, int)> zeilen, int gesamtBytes) {
  final b = StringBuffer()
    ..writeln('# Klangliste · Burgstadt Schartenfels')
    ..writeln()
    ..writeln('Alle Dateien: WAV, PCM 16 Bit, mono, 22 050 Hz, Spitze −1 dBFS. '
        'Einzelklänge sind kurz ein- und ausgeblendet, Schleifen (`*_schleife` und Musik) '
        'schließen ohne Sprung am Ende.')
    ..writeln('Erzeugt prozedural mit `tool/ton` (`dart run erzeuge.dart`), deterministisch, ohne Samples.')
    ..writeln()
    ..writeln('| Datei | Länge | Beschreibung | Lizenz |')
    ..writeln('|---|---|---|---|');
  for (final (e, sek, _) in zeilen) {
    b.writeln('| `${e.name}.wav` | ${_laengeText(sek)} | ${e.beschreibung} | eigenes Werk |');
  }
  final mb = (gesamtBytes / 1000000).toStringAsFixed(2).replaceAll('.', ',');
  b
    ..writeln()
    ..writeln('Gesamtgröße aller Dateien: $mb MB (${zeilen.length} Dateien).');
  return b.toString();
}

void main(List<String> args) {
  final ziel = Directory(args.isNotEmpty ? args.first : '../../assets/burgstadt/ton');
  ziel.createSync(recursive: true);
  final zeilen = <(Eintrag, double, int)>[];
  var gesamt = 0;
  for (final e in eintraege) {
    final x = nachbearbeiten(e);
    final bytes = wavBytes(x);
    File('${ziel.path}/${e.name}.wav').writeAsBytesSync(bytes);
    zeilen.add((e, x.length / abtastrate, bytes.length));
    gesamt += bytes.length;
  }
  File('${ziel.path}/LISTE.md').writeAsStringSync(_liste(zeilen, gesamt));
  stdout.writeln('${zeilen.length} Dateien nach ${ziel.path} geschrieben.');
  stdout.writeln('Gesamtgröße: $gesamt Byte (${(gesamt / 1000000).toStringAsFixed(2)} MB).');
}
