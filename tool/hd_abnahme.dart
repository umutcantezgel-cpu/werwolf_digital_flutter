// Burgstadt HD · Abnahme HZ-01 … HZ-14 (ZIELFORMEL, Definition of Done).
//
// Rechnet nach, was heute messbar ist: die Layout-Prüfsumme, die Spieltexte gegen die Basis des
// Nachtlaufs, die Erkundungsbots aus einem Protokoll (--log), das Nachtlauf-Ergebnis (nur lesen)
// und den Figurenstand. Alles übrige ist OFFEN, mit dem fehlenden Werkzeug oder Beleg, und zählt als
// nicht erfüllt. Nur wenn alle 14 Kriterien erfüllt sind, gibt das Werkzeug „HD-ZIEL ERREICHT“ aus.
//
// Aufruf (Repo-Wurzel):
//   dart run tool/hd_abnahme.dart [--log <datei>]   Abnahme; Ergebnis auch in hd/belege/hd_abnahme.txt
//   dart run tool/hd_abnahme.dart --figurenstand    druckt nur den Figurenstand
//   dart run tool/hd_abnahme.dart --selbsttest      prüft die Berechnung des Figurenstands
// Startet keinen Testlauf und schreibt nichts nach nachtlauf/.
import 'dart:io';

import 'lib/figurenstand.dart';

late final String wurzel;
final ergebnisse = <(String, bool, String)>[];
String? figurenstandHeute; // null, wenn er nicht ermittelbar ist
String? logPfad;

void kriterium(String id, bool ok, String beleg) => ergebnisse.add((id, ok, beleg));

ProcessResult _lauf(String programm, List<String> args) =>
    Process.runSync(programm, args, workingDirectory: wurzel);

String _git(List<String> args) => (_lauf('git', args).stdout as String).trim();

String? _stand() {
  try {
    return figurenstand(wurzel);
  } catch (_) {
    return null;
  }
}

List<String> _dateien() {
  try {
    return figurenDateien(wurzel);
  } catch (_) {
    return <String>[];
  }
}

// Belegpfade (relativ zur Repo-Wurzel). Die Messungen und Sichtprüfungen schreiben genau dorthin.
const belegSkalierung = 'hd/belege/skalierung.txt'; // HZ-01
const belegPalette = 'hd/belege/palette_migration.txt'; // HZ-02
const belegFlimmer = 'hd/belege/flimmer.txt'; // HZ-03
const belegTexturen = 'hd/belege/texturen.txt'; // HZ-04
const belegBau = 'hd/belege/bau.txt'; // HZ-05
const belegSonderbauten = 'hd/belege/sonderbauten.md'; // HZ-06
const belegRaeume = 'hd/belege/raeume.txt'; // HZ-07
const belegLicht = 'hd/belege/licht.txt'; // HZ-08
const belegFiguren = 'hd/belege/figuren.txt'; // HZ-09
const belegPortraets = 'hd/belege/portraets.txt'; // HZ-10
const belegUi = 'hd/belege/ui.txt'; // HZ-11
const belegLeistung = 'hd/belege/leistung.txt'; // HZ-12
const abschlussBericht = 'hd/ABSCHLUSSBERICHT.md'; // HZ-14
const nachtlaufErgebnis = 'nachtlauf/belege/abnahme.txt'; // HZ-13 (d), nur lesen
const a605Ordner = 'nachtlauf/auftraege/A-605';

const _karten = 'packages/pixel_engine/data/figuren/karten.json';
const _rollen = 'packages/pixel_engine/data/figuren/rollen.json';

/// Spieltexte und Kanon, wie die Konstante `textPfade` in tool/abnahme.dart.
const textPfade = [
  'packages/burgstadt_core/data',
  'packages/burgstadt_spiel/data/texte',
  'packages/pixel_engine/data/figuren',
  'nachtlauf/kanon',
  'krimidinner/spuk-im-gewoelbe/10_kanon',
];

const tuerenMinimum = 134;
const nachtlaufGrenze = 12;

/// Zählt die A-605-Berichte, die den Figurenstand [stand] nennen und „Paare: 0 · Verstöße: 0“ melden.
int _a605Bestaetigt(String? stand) {
  final ordner = Directory('$wurzel/$a605Ordner');
  if (stand == null || !ordner.existsSync()) {
    return 0;
  }
  var n = 0;
  for (final f in ordner.listSync().whereType<File>()) {
    final t = f.readAsStringSync();
    final nennt = [
      for (final m in RegExp(r'Figurenstand[^\n0-9a-f]*([0-9a-f]{10})(?![0-9a-f])').allMatches(t)) m[1],
    ].contains(stand);
    if (nennt && RegExp(r'ERGEBNIS · Paare: 0 · Verstöße: 0').hasMatch(t)) {
      n++;
    }
  }
  return n;
}

/// Kriterien, deren Messung noch nicht gebaut ist. Ein vorhandener Beleg erfüllt sie nicht: eine
/// Datei beweist keine Messung. Sie bleiben OFFEN, auch wenn der Beleg schon da ist.
void _ausstehend(String id, String beleg, String messung) {
  final da = File('$wurzel/$beleg').existsSync();
  kriterium(
    id,
    false,
    da
        ? 'Beleg vorhanden, Auswertung noch nicht eingebaut: $beleg (Messung: $messung)'
        : 'Beleg fehlt: $beleg (Messung: $messung)',
  );
}

// HZ-01 Auflösung. ZIELFORMEL: spiel_test mit den 18 Größen aus K-011 (Schwellen, Obergrenze),
// Belegfotos „scharf“ mit pixel_pruef; Puffergrößen von „mittel“ und „sparsam“ gleich dem Ausgang.
void _hz01() => _ausstehend(
      'HZ-01',
      belegSkalierung,
      '18/18 Größen exakt, Obergrenze greift, Puffer wie Ausgang, Block- und Palettentest 100 %',
    );

// HZ-02 Palette und Licht v2. ZIELFORMEL: pixel_test v2 mit 160 Farben, Wächter Name → RGB 100 %,
// beide Migrationsbelege RGB-gleich zum Ausgang, Lichttabelle ≥ 12/12/6, Banding-Sprung ≤ 1 Stufe.
void _hz02() => _ausstehend(
      'HZ-02',
      belegPalette,
      '160 Farben, Wächter 100 %, Migrationsbelege RGB-gleich, Lichttabelle ≥ 12/12/6, Banding ≤ 1 Stufe',
    );

// HZ-03 Dichte und Flimmern. ZIELFORMEL: UV-Dichte-Test (alle Welt-Meshes 64 ± 1 %, Figuren bei
// „scharf“ 64) und flimmer.dart gegen die alte Mip-Formel (Flimmerwert ≤ 50 % des Ausgangs).
void _hz03() => _ausstehend(
      'HZ-03',
      belegFlimmer,
      'Welt-Meshes 64 ± 1 %, Figuren 64, Flimmerwert ≤ 50 % des Ausgangs',
    );

// HZ-04 95 Texturen. ZIELFORMEL: texturen_test v2, Kontaktbögen Mip 0 und 1, 3 Sichtprüfer; 95/95
// bestehen, 0 offene Befunde zu Rauschen, Moiré oder Stilbruch.
void _hz04() => _ausstehend(
      'HZ-04',
      belegTexturen,
      '95/95 bestehen, 0 Befunde zu Rauschen, Moiré, Stilbruch in 3 Sichtprüfungen',
    );

// HZ-05 Gebäude. ZIELFORMEL: bau_test, Kontaktbögen; 26 Bauteile, 20/20 Profile, 160/160 Häuser
// mit mindestens 8 Bauteilarten.
void _hz05() => _ausstehend(
      'HZ-05',
      belegBau,
      '26 Bauteile, 20/20 Profile, 160/160 Häuser mit ≥ 8 Bauteilarten',
    );

// HZ-06 Neun Sonderbauten. ZIELFORMEL: Checklisten (P3-PRUEF-02) und Sichtprüfer; mindestens 6
// Elemente je Bau, 9/9.
void _hz06() => _ausstehend(
      'HZ-06',
      belegSonderbauten,
      '9 Sonderbauten mit ≥ 6 Elementen, 9/9 in der Checkliste',
    );

// HZ-07 Innenräume. ZIELFORMEL: formen_test, raum_test über baueWelt(), formbasierter Kanon-Test;
// Rückfall 0, alle 59 Innen-Bereiche mit ≥ 4 Deko-Formen und Wandaufbau, 3 Außenbereiche mit ≥ 4
// Deko-Formen, 0 Verstöße gegen Positiv- und Verbotsliste, Sichturteil Median ≥ 4 von 5.
void _hz07() => _ausstehend(
      'HZ-07',
      belegRaeume,
      'Rückfall 0, 59 Innen-Bereiche mit ≥ 4 Deko-Formen, 3 Außenbereiche, 0 Kanon-Verstöße',
    );

// HZ-08 Licht und Atmosphäre. ZIELFORMEL: Renderer-Test, Flacker-Metrik, Himmelsmessung,
// Uhrturm-Test; Flackern an ≥ 90 % der Kerzen- und Ofenquellen, Himmel-Einzelpixel ≤ 2 %, Himmel
// hochkant ≤ 40 %, Zeiger gleich Spielzeit.
void _hz08() => _ausstehend(
      'HZ-08',
      belegLicht,
      'Flackern ≥ 90 %, Himmel-Einzelpixel ≤ 2 %, hochkant ≤ 40 %, Uhrturm-Zeiger gleich Spielzeit',
    );

// HZ-09 Figuren HD. ZIELFORMEL: sprite_pruef v2 und Tests (66/66 fehlerfrei, Augen ≥ 2×2 bei 64),
// 3 Sichtprüfer im A-605-Format mit der Zeile „Figurenstand <hash>“. Der Figurenstand wird hier
// berechnet; mindestens zwei Berichte müssen ihn mit „Paare: 0 · Verstöße: 0“ nennen.
void _hz09() {
  final stand = figurenstandHeute;
  _ausstehend(
    'HZ-09',
    belegFiguren,
    '66/66 fehlerfrei, Augen ≥ 2×2 bei 64; Figurenstand ${stand ?? 'nicht ermittelt'}, '
        'Sichtprüfer am Stand: ${_a605Bestaetigt(stand)} (Grenze 2)',
  );
}

// HZ-10 Porträts HD. ZIELFORMEL: portraet_test v2 und Belegfotos; 66/66, Unterschied ≥ 3 % der
// Gesichtspixel, 0 Verstöße gegen K9 §8, Gespräch und Fallakte belegt.
void _hz10() => _ausstehend(
      'HZ-10',
      belegPortraets,
      '66/66 Porträts, Unterschied ≥ 3 % der Gesichtspixel, 0 Verstöße K9 §8',
    );

// HZ-11 Oberfläche. ZIELFORMEL: ui_test und stadtkarte_test v2, 3 Sichtprüfer; 0 Überlappungen und
// 0 abgeschnittene Blasen in 1.000 Lagen, 0 Kollisionen von Beschriftung und Linie, 9/9 belegt.
void _hz11() => _ausstehend(
      'HZ-11',
      belegUi,
      '0 Überlappungen und 0 abgeschnittene Blasen in 1.000 Lagen, 9/9 Bildschirme belegt',
    );

// HZ-12 Leistung. ZIELFORMEL: szenen_mess (VM), geraete.js (gelieferte Bilder/s), qualitaet_test,
// leistung.dart; Kosten je Weltpixel ≥ 35 % unter Ausgang, Desktop „scharf“ ≥ 30 Bilder/s,
// „auto“ nie unter 30, Nachladespitze ×4 ≤ 50 ms, Speicherwachstum ≤ 10 %, Budget je Ansicht.
void _hz12() => _ausstehend(
      'HZ-12',
      belegLeistung,
      'Kosten je Weltpixel ≥ 35 % unter Ausgang, Desktop scharf ≥ 30 Bilder/s, Nachladespitze ×4 ≤ 50 ms',
    );

// HZ-13 Spiel unverändert. ZIELFORMEL: (a) Layout-Prüfsumme gleich Ausgang, (b) textPfade ohne
// Diff, (c) Erkundungsbots 134/134 Türen und 0 Steckenbleiber, (d) Nachtlauf-Abnahme mit mindestens
// 12 erfüllten Z-Kriterien; Z-03 zählt nur, wenn der Figurenstand in mindestens zwei A-605-Berichten
// mit „Paare: 0 · Verstöße: 0“ steht. Die Teile (a) bis (d) rechnet diese Funktion selbst nach.
void _hz13() {
  var ok = true;
  final teile = <String>[];

  // (a) Layout-Prüfsumme, ohne eigenes Schreiben (--pruefe)
  final lay = _lauf(Platform.resolvedExecutable, ['run', 'tool/layout_pruefsumme.dart', '--pruefe']);
  final layAusgabe = (lay.stdout as String).trim();
  final layOk = lay.exitCode == 0 && layAusgabe.split('\n').contains('LAYOUT GLEICH');
  ok = ok && layOk;
  teile.add(layOk
      ? '(a) LAYOUT GLEICH'
      : '(a) Layout nicht gleich: ${layAusgabe.isEmpty ? 'keine Ausgabe' : layAusgabe.split('\n').last} (exit ${lay.exitCode})');

  // (b) Spieltexte ohne Unterschied zur Basis des Nachtlaufs
  final basis = _lauf('git', ['merge-base', 'HEAD', 'origin/nachtlauf/burgstadt']);
  final basisHash = (basis.stdout as String).trim();
  if (basis.exitCode == 0 && basisHash.isNotEmpty) {
    final textOk = _lauf('git', ['diff', '--quiet', basisHash, '--', ...textPfade]).exitCode == 0;
    ok = ok && textOk;
    teile.add('(b) textPfade ${textOk ? 'ohne Diff' : 'MIT Diff'} gegen ${basisHash.substring(0, 7)}');
  } else {
    ok = false;
    teile.add('(b) Basis origin/nachtlauf/burgstadt fehlt');
  }

  // (c) Erkundungsbots aus einem Protokoll von tool/alle_tests.sh
  final lp = logPfad;
  if (lp == null) {
    ok = false;
    teile.add('(c) Protokoll fehlt (Option --log)');
  } else if (!File(lp).existsSync()) {
    ok = false;
    teile.add('(c) Protokoll nicht gefunden: $lp');
  } else {
    final t = File(lp).readAsStringSync();
    final tueren = RegExp(r'^Türen (\d+)/(\d+) erreicht', multiLine: true).firstMatch(t);
    final stecken = RegExp(r'^Steckenbleiber: (\d+)', multiLine: true).firstMatch(t)?[1];
    final botsOk = tueren != null &&
        tueren[1] == tueren[2] &&
        int.parse(tueren[1]!) >= tuerenMinimum &&
        stecken == '0';
    ok = ok && botsOk;
    teile.add('(c) Türen ${tueren?[1] ?? '?'}/${tueren?[2] ?? '?'} erreicht, Steckenbleiber ${stecken ?? '?'} '
        '(Grenze $tuerenMinimum/$tuerenMinimum, 0)');
  }

  // (d) Nachtlauf-Abnahme: nur lesen, nie schreiben
  final erg = File('$wurzel/$nachtlaufErgebnis');
  if (!erg.existsSync()) {
    ok = false;
    teile.add('(d) Beleg fehlt: $nachtlaufErgebnis');
  } else {
    final zeilen = erg.readAsStringSync().split('\n');
    final stand = RegExp(r'Stand ([0-9a-f]+)').firstMatch(zeilen.first)?[1] ?? '?';
    final erfuellt = [
      for (final z in zeilen) RegExp(r'^(Z-\d\d) · erfüllt ·').firstMatch(z)?[1],
    ].whereType<String>().toList();
    final z03Bestaetigt = _a605Bestaetigt(figurenstandHeute);
    final z03Gilt = z03Bestaetigt >= 2;
    final zaehl = erfuellt.where((z) => z != 'Z-03' || z03Gilt).length;
    final nachtOk = zaehl >= nachtlaufGrenze;
    ok = ok && nachtOk;
    final z03Hinweis = erfuellt.contains('Z-03')
        ? (z03Gilt ? ', Z-03 zählt' : ', Z-03 zählt nicht: Figurenstand in $z03Bestaetigt von 2 A-605-Berichten')
        : '';
    teile.add('(d) Nachtlauf-Stand $stand: $zaehl erfüllte Z-Kriterien (Grenze $nachtlaufGrenze)$z03Hinweis');
  }

  kriterium('HZ-13', ok, teile.join(' · '));
}

// HZ-14 Belege und Übergabe. ZIELFORMEL: Galerie, alle_tests.sh voll, hd/ABSCHLUSSBERICHT.md.
// Heute geprüft: die Datei existiert und jeder Bildverweis `](…png)` zeigt auf eine vorhandene Datei.
// Die Zahlen der ZIELFORMEL (Paare je HZ, Viertel, Fall-Orte) prüft diese Stelle noch nicht.
void _hz14() {
  final f = File('$wurzel/$abschlussBericht');
  if (!f.existsSync()) {
    kriterium('HZ-14', false, 'Beleg fehlt: $abschlussBericht');
    return;
  }
  final bilder = [for (final m in RegExp(r'\]\(([^)\s]+\.png)\)').allMatches(f.readAsStringSync())) m[1]!];
  final kaputt = [for (final b in bilder) if (!File('${f.parent.path}/$b').existsSync()) b];
  final ok = bilder.isNotEmpty && kaputt.isEmpty;
  kriterium(
    'HZ-14',
    ok,
    '${bilder.length} Bildverweise, ${kaputt.isEmpty ? 'alle vorhanden' : 'fehlend: ${kaputt.join(', ')}'}; '
        'Paare je HZ, Viertel und Fall-Orte noch nicht geprüft',
  );
}

/// Selbsttest des Figurenstands: zweimal berechnet gleich, 10 Hex-Zeichen, karten.json und rollen.json erfasst.
bool _selbsttest() {
  final a = _stand();
  final b = _stand();
  final dateien = _dateien();
  final pruefungen = <(String, bool)>[
    ('Figurenstand zweimal berechnet, gleicher Wert${a == null ? '' : ' ($a)'}', a != null && a == b),
    ('Figurenstand hat 10 Hex-Zeichen', a != null && RegExp(r'^[0-9a-f]{10}$').hasMatch(a)),
    (
      'karten.json und rollen.json erfasst (${dateien.length} Dateien)',
      dateien.contains(_karten) && dateien.contains(_rollen),
    ),
  ];
  for (final (name, gut) in pruefungen) {
    stdout.writeln('SELBSTTEST · ${gut ? 'OK' : 'FEHLER'} · $name');
  }
  if (a != null) {
    stdout.writeln('Figurenstand heute: $a');
  }
  final alleGut = pruefungen.every((p) => p.$2);
  stdout.writeln(alleGut ? 'SELBSTTEST OK' : 'SELBSTTEST FEHLER');
  return alleGut;
}

void main(List<String> args) {
  wurzel = File.fromUri(Platform.script).parent.parent.path;
  const aufruf = 'Aufruf (Repo-Wurzel): dart run tool/hd_abnahme.dart [--log <datei>] | --figurenstand | --selbsttest';

  if (args.length == 1 && args.first == '--figurenstand') {
    final s = _stand();
    if (s == null) {
      stderr.writeln('Figurenstand nicht ermittelbar (git ls-files / hash-object).');
      exitCode = 2;
      return;
    }
    stdout.writeln(s);
    return;
  }
  if (args.length == 1 && args.first == '--selbsttest') {
    exitCode = _selbsttest() ? 0 : 1;
    return;
  }
  if (args.isNotEmpty && !(args.length == 2 && args.first == '--log')) {
    stderr.writeln(aufruf);
    exitCode = 64;
    return;
  }
  if (args.length == 2) {
    final p = args[1];
    logPfad = File(p).isAbsolute ? p : '$wurzel/$p';
  }

  figurenstandHeute = _stand();
  final head = _git(['rev-parse', '--short=12', 'HEAD']);
  final sauber = _git(['status', '--porcelain']).isEmpty;

  _hz01();
  _hz02();
  _hz03();
  _hz04();
  _hz05();
  _hz06();
  _hz07();
  _hz08();
  _hz09();
  _hz10();
  _hz11();
  _hz12();
  _hz13();
  _hz14();

  final erfuellt = ergebnisse.where((e) => e.$2).length;
  final out = StringBuffer()
    ..writeln('HD-Abnahme · Stand $head${sauber ? '' : ' (+ nicht eingecheckte Änderungen)'} · '
        '${DateTime.now().toIso8601String().substring(0, 16)}');
  for (final (id, ok, beleg) in ergebnisse) {
    out.writeln('$id · ${ok ? 'erfüllt' : 'OFFEN'} · $beleg');
  }
  out.writeln('HD-ABNAHME · $erfuellt von 14 erfüllt');
  if (erfuellt == 14) {
    out.writeln('HD-ZIEL ERREICHT');
  }
  stdout.write(out);

  final ziel = File('$wurzel/hd/belege/hd_abnahme.txt');
  ziel.parent.createSync(recursive: true);
  ziel.writeAsStringSync(out.toString());
  exitCode = erfuellt == 14 ? 0 : 1;
}
