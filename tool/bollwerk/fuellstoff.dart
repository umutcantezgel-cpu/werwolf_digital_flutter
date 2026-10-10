// BOLLWERK · Füllstoffprüfung (L5; Z-10, Z-28; A-8 Teil 2 und Nachtrag M6).
// Aufruf: dart run tool/bollwerk/fuellstoff.dart [--regeln|--alle] [--datei <pfad>]
//   ohne Schalter: F1 (Schema, Inhaltsprüfer), F3 (statische Wirkung), F4 (Dubletten) über alle
//                  Einheiten unter content/runden/; F2 und F6 brauchen den Simulator der Schicht.
//   --regeln:      Z-28 – nur die Inhaltslisten (Textregeln, Sperrliste, Gewalt, Platzhalter).
//   --alle:        Z-10 – zusätzlich F5 aus den Ring-7-Protokollen unter belege/gremium/.
// Letzte Zeile „L5 <modus> GRÜN · <n> Einheiten“, „… ROT · …“ oder „… OFFEN · …“ (rot).
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';

/// Sperrliste (A-2 A4.6): Namen und Begriffe aus anderen Fällen und alten Ständen.
const sperrliste = [
  'Merle', 'Lüddecke', 'Rojda', 'Adnan', 'Kunibert', 'Burgwart', 'Speisekammer', 'Wehrgang', 'Torhaus',
  'Hofebene', 'Turm-Fuß', 'Eisentür', 'Bienenwachs', 'benommen', 'Apfel-Zimt-Punsch', 'Ayran', //
];

/// Liste `gewalt` (A-2 A4.6).
const gewalt = ['blut', 'blutig', 'blutet', 'wunde', 'verletzt', 'verletzung', 'schmerz'];

/// Platzhalter führen zur Ablehnung (A-2 A4.9).
const platzhalter = ['usw.', 'analog', 'weitere folgen', 'etc.', 'TODO', 'Lorem'];

const arten = {'abstecher', 'folgeentscheidung', 'text', 'gag', 'aktion', 'element', 'ort'};
const folgen = {'zeit+', 'zeit-', 'marke', 'folge_abstecher', 'zusatz', 'helfer', 'gag'};

class Befund {
  final String kennung;
  final String regel;
  final String text;
  Befund(this.kennung, this.regel, this.text);
  @override
  String toString() => '$kennung · $regel · $text';
}

String _wurzel() => File(Platform.script.toFilePath()).parent.parent.parent.path;

List<Map<String, Object?>> ladeEinheiten(String bw, String? nurDatei) {
  final aus = <Map<String, Object?>>[];
  final d = Directory('$bw/content/runden');
  if (!d.existsSync()) return aus;
  for (final f in d.listSync(recursive: true).whereType<File>()) {
    if (nurDatei != null && !f.path.endsWith(nurDatei)) continue;
    final rel = f.path.substring(bw.length + 1);
    if (f.path.endsWith('.jsonl')) {
      var nr = 0;
      for (final z in f.readAsLinesSync()) {
        nr++;
        if (z.trim().isEmpty) continue;
        final j = jsonDecode(z) as Map<String, Object?>;
        aus.add({...j, '_quelle': '$rel:$nr'});
      }
    } else if (f.path.endsWith('.json')) {
      final j = jsonDecode(f.readAsStringSync());
      final liste = j is List ? j : ((j as Map)['einheiten'] as List? ?? const []);
      var nr = 0;
      for (final e in liste) {
        aus.add({...(e as Map).cast<String, Object?>(), '_quelle': '$rel#${nr++}'});
      }
    }
  }
  return aus;
}

/// Alle Spielertexte einer Einheit mit Ort.
List<(String, String)> texte(Map<String, Object?> e) {
  final k = e['kennung'] ?? e['_quelle'];
  return [
    for (final f in ['titel', 'text'])
      if (e[f] is String) ('$k.$f', e[f] as String),
    if (e['stufen'] is Map)
      for (final s in (e['stufen'] as Map).entries)
        if (s.value is String) ('$k.stufen.${s.key}', s.value as String),
  ];
}

List<Befund> regeln(Textpruefer tp, Map<String, Object?> e) {
  final b = <Befund>[];
  final k = '${e['kennung'] ?? e['_quelle']}';
  for (final (ort, t) in texte(e)) {
    for (final f in tp.pruefe(TextQuelle(ort: ort, text: t, vorlesen: true))) {
      b.add(Befund(k, 'F1 Textregel ${f.regel}', f.auszug));
    }
    final klein = t.toLowerCase();
    for (final s in sperrliste) {
      if (RegExp('(^|[^a-zäöüß])${RegExp.escape(s.toLowerCase())}').hasMatch(klein)) b.add(Befund(k, 'F1 Sperrliste', s));
    }
    for (final g in gewalt) {
      if (RegExp('(^|[^a-zäöüß])$g').hasMatch(klein)) b.add(Befund(k, 'F1 Gewalt', g));
    }
    for (final p in platzhalter) {
      if (t.contains(p)) b.add(Befund(k, 'F1 Platzhalter', p));
    }
  }
  return b;
}

List<Befund> schema(Map<String, Object?> e) {
  final b = <Befund>[];
  final k = '${e['kennung'] ?? e['_quelle']}';
  for (final f in ['kennung', 'slot', 'art', 'titel', 'text']) {
    if (e[f] == null || (e[f] is String && (e[f] as String).trim().isEmpty)) b.add(Befund(k, 'F1 Schema', 'Feld $f fehlt'));
  }
  if (e['art'] is String && !arten.contains(e['art'])) b.add(Befund(k, 'F1 Schema', 'art ${e['art']}'));
  final titel = e['titel'];
  if (titel is String && titel.split(RegExp(r'\s+')).length > 6) b.add(Befund(k, 'F1 Schema', 'Titel > 6 Wörter'));
  final text = e['text'];
  if (text is String) {
    final n = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    if (n < 8 || n > 40) b.add(Befund(k, 'F1 Schema', 'Text $n Wörter (8–40)'));
  }
  final a = e['aktion'];
  if (a is Map) {
    final d = a['dauer_s'];
    if (d is! num || d < 4 || d > 12) b.add(Befund(k, 'F1 Schema', 'aktion.dauer_s $d (4–12)'));
  }
  final z = e['zeit_s'];
  if (z is num && z > 30) b.add(Befund(k, 'F6 Zeit', 'zeit_s $z > 30'));
  // F3 statisch: ein Wurf braucht drei Stufentexte, jede Einheit eine spürbare Folge
  if (e['wurf'] == true) {
    final s = e['stufen'];
    if (s is! Map || !['erfolg', 'teil', 'pech'].every((x) => s[x] is String && (s[x] as String).isNotEmpty)) {
      b.add(Befund(k, 'F3 Wirkung', 'Wurf ohne drei Stufentexte'));
    }
  }
  final folge = e['folge'];
  if ((e['art'] == 'abstecher' || e['art'] == 'folgeentscheidung') &&
      (folge is! String || !folgen.any((f) => folge.startsWith(f.replaceAll(RegExp(r'[+-]$'), ''))))) {
    b.add(Befund(k, 'F3 Wirkung', 'keine spürbare Folge ($folge)'));
  }
  if ((e['kanonbezug'] as List? ?? const []).any((x) => '$x'.startsWith('fakt:'))) {
    b.add(Befund(k, 'F1 Kanon', 'fakt:-Glied in einer Schicht-Einheit (K-04 Kettensperre, C2)'));
  }
  return b;
}

/// Wort-3-Gramme nach Platzhaltern für Kanon-Namen (A-8 Nachtrag M6).
Set<String> dreiGramme(String text, List<String> namen) {
  var t = text.toLowerCase();
  for (final n in namen) {
    t = t.replaceAll(n.toLowerCase(), ' <name> ');
  }
  final w = t.split(RegExp(r'[^a-zäöüß<>]+')).where((x) => x.isNotEmpty).toList();
  return {for (var i = 0; i + 2 < w.length; i++) '${w[i]} ${w[i + 1]} ${w[i + 2]}'};
}

List<Befund> dubletten(List<Map<String, Object?>> es, List<String> namen) {
  final b = <Befund>[];
  final g = [for (final e in es) dreiGramme('${e['titel'] ?? ''} ${e['text'] ?? ''}', namen)];
  for (var i = 0; i < es.length; i++) {
    for (var j = i + 1; j < es.length; j++) {
      final u = g[i].union(g[j]).length;
      if (u == 0) continue;
      final jac = g[i].intersection(g[j]).length / u;
      if (jac >= 0.25) b.add(Befund('${es[j]['kennung']}', 'F4 Dublette', '~ ${es[i]['kennung']} (Jaccard ${jac.toStringAsFixed(2)})'));
    }
  }
  return b;
}

void main(List<String> args) {
  final bw = _wurzel();
  final modus = args.contains('--regeln') ? 'regeln' : (args.contains('--alle') ? 'alle' : 'schicht');
  final di = args.indexOf('--datei');
  final es = ladeEinheiten(bw, di >= 0 ? args[di + 1] : null);
  final tp = Textpruefer(jsonDecode(File('$bw/content/party/textregeln.json').readAsStringSync()) as Map<String, Object?>);
  final kanon = Kanon.lade((p) => jsonDecode(File('$bw/content/party/schlosskeller/$p').readAsStringSync()) as Map<String, Object?>);
  final namen = [
    for (final f in kanon.figuren) ...[f['id'] as String, if (f['name'] is String) f['name'] as String],
    for (final r in (kanon.json['raeume.json']!['rooms'] as List)) ...[
      (r as Map)['id'] as String,
      if (r['anzeigename'] is String) r['anzeigename'] as String,
    ],
    for (final o in (kanon.json['raeume.json']!['orte'] as List)) (o as Map)['name'] as String,
  ]..sort((a, b) => b.length.compareTo(a.length));
  final befunde = <Befund>[];
  for (final e in es) {
    befunde.addAll(regeln(tp, e));
    if (modus != 'regeln') befunde.addAll(schema(e));
  }
  if (modus != 'regeln') befunde.addAll(dubletten(es, namen));
  for (final b in befunde.take(200)) {
    stdout.writeln(b);
  }
  final offen = <String>[];
  if (modus != 'regeln' && es.isNotEmpty) offen.add('F2/F6 Simulator-Anbindung der Schicht');
  if (modus == 'alle') offen.add('F5 Ring-7-Protokolle (belege/gremium/)');
  final kopf = 'L5 $modus';
  if (befunde.isNotEmpty) {
    stdout.writeln('$kopf ROT · ${befunde.length} Befunde · ${es.length} Einheiten');
    exit(1);
  }
  if (offen.isNotEmpty) {
    stdout.writeln('$kopf OFFEN · ${offen.join(', ')} · ${es.length} Einheiten');
    exit(1);
  }
  stdout.writeln('$kopf GRÜN · ${es.length} Einheiten');
}
