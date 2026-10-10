// BOLLWERK · Auftragsvorrat (A-6 §4). Schablonen mit Parametern; ausgegebene Slots stehen in
// planung/bollwerk/vorrat/AUSGEGEBEN.tsv (nur anhängen). FLUG.md bekommt die Zeile beim Agentenstart
// (agentId erst aus dem Startergebnis, A-6 §5).
//
// Aufruf: dart run tool/bollwerk/vorrat.dart naechste --typ <T|C|B|U> --n <k> [--schablone <ABST|FOLGE|GAG|TEXT|ORT|…>]
//                                             [--ausgeben] [--vorlauf]
//         dart run tool/bollwerk/vorrat.dart stand
//   naechste: die nächsten k freien Slots in fester Reihenfolge; mit --ausgeben werden sie angehängt.
//   --vorlauf: nur Schablonen, deren Pfade vor B-02 erlaubt sind (content/runden/, tool/bollwerk/, Urteile).
//   stand:    freie Slots je Schablone und Typ; „Vorrat <typ> < 1 h“ meldet Nachschubbedarf.
import 'dart:io';

const raeume = ['thekensaal', 'west_saal', 'ost_saal', 'turmgang', 'vorratsraum', 'durchgang', 'windfang'];
const pflicht = ['e1_1', 'e1_2', 'e1_3', 'e2_1', 'e2_2', 'e2_3', 'e3_1', 'e3_2', 'e3_3'];
const stufen = ['erfolg', 'teil', 'pech'];

/// Agentenstunden je Slot (Fabrikprobe: Bauer Median 405–509 s, Richter 338–420 s).
const stundenJeSlot = {'T': 0.15, 'U': 0.12, 'B': 0.25, 'C': 0.5};

class Slot {
  final String kennung;
  final String schablone;
  final String typ;
  final bool vorlauf;
  final Map<String, Object> parameter;
  const Slot(this.kennung, this.schablone, this.typ, this.vorlauf, this.parameter);
  String get zeile => '$kennung\t$schablone\t$typ\t${parameter.entries.map((e) => '${e.key}=${e.value}').join(',')}';
}

/// Alle Slots des Vorrats in Ausgabereihenfolge (Mischung der Achsen X1, X4, X3, X2 je Runde).
List<Slot> vorrat(List<String> orte) {
  final out = <Slot>[];
  // X1 Abstecher: 7 Räume × 3 Runden, je 12–15 Varianten
  for (final r in [1, 2, 3]) {
    for (final raum in raeume) {
      out.add(Slot('ABST-$raum-$r', 'ABST', 'T', true, {'raum': raum, 'runde': r, 'varianten': 15}));
    }
  }
  // X1 Folgeentscheidungen: je Pflichtentscheidung
  for (final e in pflicht) {
    out.add(Slot('FOLGE-$e', 'FOLGE', 'T', true, {'nach': e, 'varianten': 12}));
  }
  // X4 Gags: je Raum fortlaufende Stapel, bis +397 gedeckt sind (PLAN §1)
  for (var k = 1; k <= 4; k++) {
    for (final raum in raeume) {
      out.add(Slot(k == 1 && raum == 'ost_saal' ? 'GAG-ost_saal' : 'GAG-$raum-$k', 'GAG', 'T', true, {'raum': raum, 'stapel': k, 'varianten': 15}));
    }
  }
  // X3 Teilorte: je Raum Stapel zu 12 (Koordinaten prüft Opus am Raumgraph)
  for (var k = 1; k <= 2; k++) {
    for (final raum in raeume) {
      out.add(Slot('ORT-$raum-$k', 'ORT', 'T', true, {'raum': raum, 'stapel': k, 'varianten': 12}));
    }
  }
  // X2 Erzähltexte je Ort und Würfelstufe
  for (final o in orte) {
    for (final s in stufen) {
      out.add(Slot('TEXT-$o-$s', 'TEXT', 'T', true, {'ort': o, 'stufe': s, 'varianten': 10}));
    }
  }
  // Nach B-02: Posen, Aktionsarten, Requisiten (Code), Tests, Mutanten
  for (var i = 1; i <= 45; i++) {
    out.add(Slot('AKTION-${i.toString().padLeft(2, '0')}', 'AKTION', 'C', false, {'stufe': 3}));
  }
  for (var i = 1; i <= 40; i++) {
    out.add(Slot('MUT-${i.toString().padLeft(2, '0')}', 'MUT', 'C', true, {'pfad': 'tool/bollwerk/mutanten/'}));
  }
  return out;
}

List<String> ladeOrte(String bw) {
  final t = File('$bw/content/party/schlosskeller/raeume.json').readAsStringSync();
  final ids = <String>[];
  final orte = t.substring(t.indexOf('"orte"'));
  for (final m in RegExp(r'"id"\s*:\s*"([a-z_]+)"').allMatches(orte.substring(0, orte.indexOf(']')))) {
    if (m.group(1) != 'wc') ids.add(m.group(1)!);
  }
  return ids;
}

String _wurzel() => File(Platform.script.toFilePath()).parent.parent.parent.path;

void main(List<String> args) {
  String? arg(String n) {
    final i = args.indexOf(n);
    return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
  }

  final bw = _wurzel();
  final datei = File('$bw/planung/bollwerk/vorrat/AUSGEGEBEN.tsv');
  final ausgegeben = <String>{
    if (datei.existsSync())
      for (final z in datei.readAsLinesSync())
        if (z.isNotEmpty && !z.startsWith('#')) z.split('\t').first,
  };
  final alle = vorrat(ladeOrte(bw));
  final cmd = args.isEmpty ? '' : args.first;
  if (cmd == 'stand') {
    final frei = <String, int>{};
    for (final s in alle.where((s) => !ausgegeben.contains(s.kennung))) {
      frei['${s.typ} ${s.schablone}'] = (frei['${s.typ} ${s.schablone}'] ?? 0) + 1;
    }
    for (final e in frei.entries) {
      stdout.writeln('${e.key}: ${e.value} frei');
    }
    for (final typ in stundenJeSlot.keys) {
      final h = alle.where((s) => s.typ == typ && !ausgegeben.contains(s.kennung)).length * stundenJeSlot[typ]!;
      stdout.writeln('Vorrat $typ: ${h.toStringAsFixed(1)} Agentenstunden${h < 1 ? ' · NACHSCHUB nötig (< 1 h)' : ''}');
    }
    stdout.writeln('ausgegeben ${ausgegeben.length} von ${alle.length}');
    return;
  }
  if (cmd != 'naechste') {
    stdout.writeln('Aufruf: dart run tool/bollwerk/vorrat.dart naechste --typ <T|C|B|U> --n <k> [--schablone <S>] [--ausgeben] [--vorlauf] | stand');
    exit(2);
  }
  final typ = arg('--typ') ?? 'T';
  final n = int.parse(arg('--n') ?? '6');
  final schablone = arg('--schablone');
  final nurVorlauf = args.contains('--vorlauf');
  final wahl = alle
      .where((s) =>
          s.typ == typ &&
          !ausgegeben.contains(s.kennung) &&
          (schablone == null || s.schablone == schablone) &&
          (!nurVorlauf || s.vorlauf))
      .take(n)
      .toList();
  for (final s in wahl) {
    stdout.writeln(s.zeile);
  }
  if (args.contains('--ausgeben') && wahl.isNotEmpty) {
    datei.parent.createSync(recursive: true);
    if (!datei.existsSync()) datei.writeAsStringSync('# Kennung\tSchablone\tTyp\tParameter (nur anhängen)\n');
    datei.writeAsStringSync(wahl.map((s) => '${s.zeile}\n').join(), mode: FileMode.append);
  }
  if (wahl.isEmpty) stdout.writeln('VORRAT LEER · $typ${schablone != null ? ' $schablone' : ''}');
}
