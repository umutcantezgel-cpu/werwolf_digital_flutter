// BOLLWERK · Prüfmauer Ringe 1–6 für Varianten einer Welle (A-5 Teil 1; A-8 §1.2 und Nachtrag M6).
// Port von planung/bollwerk/proben/fabrik_ringe.py, mit Schema 1.1 und den Regeln aus Kern 1.1 (E-G2-01).
//
// Aufruf: dart run tool/bollwerk/varianten.dart --welle <w> [--ring <1|2|3|5|6>] [--json <aus>]
//                [--gegen <jsonl>…] [<jsonl>…]
//   ohne Dateien: alle /home/user/bw-varianten/<w>/*.jsonl außer Füllstücken (FUELL-*).
//   --gegen:      schon angenommene Einheiten (Vorrat), gegen die Ring 6 Dubletten prüft.
//   --ring <n>:   nur diesen Ring melden (Form 1, Regeln 2, Kanon 3, Erreichbarkeit 5, Neuheit 6).
// Ring 0 (Werkzeug-Audit) läuft vorher über werkzeug_audit.sh, Ring 7 über die Richter, Ring 8 ist die
// Stichprobe durch Opus. Letzte Zeile „VARIANTEN <n> · ring1 grün <a> · … · alle Ringe 1–6 grün <k>“;
// Exit 0, wenn das Werkzeug lief (auch bei roten Varianten), Exit 2 bei Bedienfehlern.
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';

import 'fuellstoff.dart' show dreiGramme, gewalt, platzhalter, sperrliste;

const artenSchicht = {'abstecher', 'folgeentscheidung', 'text', 'gag', 'aktion', 'element', 'ort'};
const folgenSchicht = {'zeit-', 'zeit+', 'marke', 'folge_abstecher', 'zusatz', 'helfer', 'gag'};
const lichter = {'Handy-Licht', 'Stirnlampe', 'Raumlicht'};

/// Weißliste der Zusatzfunde nach Lichtung L-4 (E-G1-12): 10 sichere plus `spur_handykorb`.
const weissliste = {
  'b_baran_rufe', 'b_hana_wachs', 'b_serkan_tor', 'b_pawel_schneider', 'spur_wachs_boden', //
  'spur_steckdose_verschmort', 'spur_laterne_unberuehrt', 'spur_torte', 'lacher_ruestung', 'lacher_kamin',
  'spur_handykorb',
};

const bild = [
  'flasche', 'flaschen', 'stielglas', 'stielgläser', 'fass', 'fässer', 'notlaterne', 'kerzenständer', 'anzünden',
  'flamme', 'flammen', 'streichholz', 'feuerzeug', 'kerze', 'kerzen', //
];
const hinaus = ['hinausgehen', 'nach draußen', 'ins freie', 'schlosshof', 'parkplatz', 'außentor öffnen', 'hoftür öffnen'];
final tatzeit = RegExp(r'\b(23[:.]5\d|00[:.]0\d|00[:.]1[0-5])\b');
final loesungsnah = RegExp(r'\b(täter\w*|schuldig\w*|mörder\w*|überführ\w*|alibi\w*|verdächtig\w*|tatwaffe|tatzeit)\b', caseSensitive: false);
final neueSpur = RegExp(
    r'\b(kratzer|kratzspur\w*|abdr(u|ü)ck\w*|fußspur\w*|fussspur\w*|fleck\w*|faser\w*|schleifspur\w*|fingerabdr\w*|spuren?)\b',
    caseSensitive: false);

/// Kern 1.1: Stufen- und Kartentexte nennen keine Minuten- oder Pluszahlen (die Zeit rechnet der Kern,
/// Personen geben nie ein Plus – K-06/K-07).
final zahlRegel = RegExp(r'(\+\s?\d)|(\b(\d+|eine|einer|zwei|drei|vier|fünf|zehn)\s+(nacht)?minuten?\b)', caseSensitive: false);

List<String> woerter(String s) => RegExp(r'[A-Za-zÄÖÜäöüß-]+').allMatches(s).map((m) => m.group(0)!).toList();

List<String> saetze(String s) => s.trim().split(RegExp(r'(?<=[.!?…])\s+')).where((x) => x.isNotEmpty).toList();

/// Alle Spielertexte einer Variante (Titel, Text, Stufen, Optionen, Pose, Klang).
List<String> texte(Map<String, Object?> v) {
  final out = <String>[];
  for (final k in ['titel', 'text']) {
    if (v[k] is String) out.add(v[k] as String);
  }
  final st = v['stufen'];
  if (st is Map) {
    for (final k in ['erfolg', 'teil', 'pech']) {
      if (st[k] is String) out.add(st[k] as String);
    }
  }
  final op = v['optionen'];
  if (op is List) {
    for (final o in op) {
      if (o is Map) {
        for (final k in ['titel', 'text']) {
          if (o[k] is String) out.add(o[k] as String);
        }
      }
    }
  }
  final a = v['aktion'];
  if (a is Map) {
    for (final k in ['pose', 'klang']) {
      if (a[k] is String) out.add(a[k] as String);
    }
  }
  return out;
}

class KanonIndex {
  final Set<String> ids = {};
  final Set<String> raeume = {};
  final Map<String, String> orte = {};
  final Set<String> pflicht = {};
  final Map<String, Set<String>> nachbarn = {};
  final List<String> namen = [];

  KanonIndex(String bw) {
    Map<String, Object?> lies(String n) =>
        jsonDecode(File('$bw/content/party/schlosskeller/$n').readAsStringSync()) as Map<String, Object?>;
    final r = lies('raeume.json');
    for (final x in r['rooms'] as List) {
      final m = x as Map;
      raeume.add(m['id'] as String);
      namen.add(m['id'] as String);
      if (m['anzeigename'] is String) namen.add(m['anzeigename'] as String);
    }
    for (final x in r['orte'] as List) {
      final m = x as Map;
      orte[m['id'] as String] = m['raum'] as String;
      namen.add(m['name'] as String);
    }
    for (final t in r['tueren'] as List) {
      final m = t as Map;
      final a = m['von'] as String, b = m['nach'] as String;
      if (b == 'draussen') continue;
      nachbarn.putIfAbsent(a, () => {}).add(b);
      nachbarn.putIfAbsent(b, () => {}).add(a);
    }
    final f = lies('figuren.json');
    for (final x in f['figuren'] as List) {
      final m = x as Map;
      ids.add(m['id'] as String);
      namen.add(m['name'] as String);
    }
    final g = lies('gegenstaende.json');
    for (final x in g['gegenstaende'] as List) {
      final m = x as Map;
      ids.add(m['id'] as String);
      for (final sp in (m['spuren'] as List? ?? const [])) {
        if (sp is Map && sp['id'] is String) ids.add(sp['id'] as String);
      }
    }
    final s = lies('setting.json');
    for (final x in s['lacher'] as List? ?? const []) {
      ids.add((x as Map)['id'] as String);
    }
    final b = lies('beobachtungen.json');
    for (final x in b['beobachtungen'] as List) {
      ids.add((x as Map)['id'] as String);
    }
    final e = lies('entscheidungen.json');
    for (final x in e['entscheidungen'] as List) {
      pflicht.add((x as Map)['id'] as String);
    }
    ids
      ..addAll(raeume)
      ..addAll(orte.keys)
      ..addAll({'schneider', 'detektiv', 'spur_handykorb'});
    namen.sort((a, b) => b.length.compareTo(a.length));
  }

  bool erreichbar(String von, String nach) => von == nach || (nachbarn[von]?.contains(nach) ?? false);
}

List<String> ring1(Map<String, Object?> v) {
  final f = <String>[];
  for (final k in ['kennung', 'slot', 'art', 'raum', 'titel', 'text', 'wurf', 'folge', 'zeit_s']) {
    if (!v.containsKey(k)) f.add('fehlt:$k');
  }
  final art = v['art'];
  if (!artenSchicht.contains(art)) f.add('art:$art');
  final n = woerter('${v['text'] ?? ''}').length;
  if (n < 8 || n > 40) f.add('textlaenge:$n');
  if (woerter('${v['titel'] ?? ''}').length > 6) f.add('titel>6');
  final folge = v['folge'];
  if (folge is! String || !folgenSchicht.contains(folge)) f.add('folge:$folge');
  if (v['wurf'] is! bool) f.add('wurf');
  final st = v['stufen'];
  if (v['wurf'] == true && !(st is Map && ['erfolg', 'teil', 'pech'].every((k) => st[k] is String && (st[k] as String).trim().isNotEmpty))) {
    f.add('stufen');
  }
  if (v['wurf'] == false && st != null) f.add('stufen_ohne_wurf');
  if (st is Map) {
    for (final k in ['erfolg', 'teil', 'pech']) {
      if (st[k] is String && woerter(st[k] as String).length > 25) f.add('stufe>$k');
    }
    if (st['pech'] is String && !(st['pech'] as String).toLowerCase().contains('marke')) f.add('pech_ohne_marke');
  }
  final a = v['aktion'];
  if (const {'abstecher', 'folgeentscheidung', 'gag', 'aktion'}.contains(art)) {
    if (a is! Map || a['art'] is! String || a['pose'] is! String || a['weg'] is! List || (a['weg'] as List).isEmpty) {
      f.add('aktion');
    }
  }
  if (a is Map) {
    final d = a['dauer_s'];
    if (d is! num || d < 4 || d > 12) f.add('dauer_s:$d');
    if (a['licht'] != null && !lichter.contains(a['licht'])) f.add('licht:${a['licht']}');
    if (a['pose'] is String && woerter(a['pose'] as String).length > 8) f.add('pose>8');
  }
  final z = v['zeit_s'];
  if (z is! num || z < 4 || z > 30) f.add('zeit_s:$z');
  final op = v['optionen'];
  if (art == 'folgeentscheidung') {
    if (op is! List || op.length < 2 || op.length > 3) {
      f.add('optionen');
    } else {
      final fs = <String>{};
      for (final o in op) {
        if (o is! Map || o['titel'] is! String || o['folge'] is! String || !folgenSchicht.contains(o['folge'])) {
          f.add('option_form');
        } else if (!fs.add(o['folge'] as String)) {
          f.add('optionen_gleiche_folge');
        }
      }
    }
  } else if (op != null) {
    f.add('optionen_ohne_folgeentscheidung');
  }
  if (v['zusatz'] != null && v['zusatz'] is! String) f.add('zusatz');
  if (texte(v).any((t) => platzhalter.any((p) => t.contains(p)) || RegExp(r'\b(usw|xxx)\b', caseSensitive: false).hasMatch(t))) {
    f.add('platzhalter');
  }
  return f;
}

List<String> ring2(Map<String, Object?> v, Textpruefer tp) {
  final f = <String>[];
  final ts = texte(v);
  final alle = ts.join(' ').toLowerCase();
  final w = woerter(alle).map((x) => x.toLowerCase()).toSet();
  for (final t in ts) {
    for (final b in tp.pruefe(TextQuelle(ort: '${v['kennung']}', text: t, vorlesen: false))) {
      f.add('textregel:${b.regel}');
    }
  }
  for (final x in [...sperrliste.map((s) => s.toLowerCase()), ...gewalt, ...bild]) {
    if (w.contains(x) || ((x.contains('-') || x.contains(' ')) && alle.contains(x))) f.add('sperre:$x');
  }
  for (final x in gewalt) {
    if (RegExp('(^|[^a-zäöüß])$x').hasMatch(alle) && !f.contains('sperre:$x')) f.add('gewalt:$x');
  }
  for (final x in hinaus) {
    if (alle.contains(x)) f.add('hinaus:$x');
  }
  // Siezen je Text einzeln: „Ihr“/„Sie“ am Satz- oder Textanfang, nach Doppelpunkt oder Anführung ist Anrede der Runde.
  final ent = RegExp(r'(^|[.!?…:]\s+|[„"]\s*)(Sie|Ihr\w*)\b');
  if (ts.any((t) => RegExp(r'\b(Sie|Ihnen|Ihr(e|en|er|em)?)\b').hasMatch(t.replaceAll(ent, ' ')))) {
    f.add('siezen');
  }
  if (alle.contains('pfeife') && !alle.contains('seifenblase')) f.add('pfeife_ohne_seifenblasen');
  if (alle.contains('schneider') && RegExp(r'\b(steht auf|stirbt|tot|fällt|läuft|rennt|springt)\b').hasMatch(alle)) f.add('schneider');
  if (RegExp(r'\b(rauch\w*|qualm\w*)\b').hasMatch(alle) && !alle.contains('kamin')) f.add('rauch_ohne_kamin');
  final ls = [for (final t in ts) for (final s in saetze(t)) woerter(s).length];
  if (ls.isNotEmpty) {
    final mx = ls.reduce((a, b) => a > b ? a : b);
    if (mx > 25) f.add('satz>25:$mx');
    final mittel = ls.fold(0, (a, b) => a + b) / ls.length;
    if (mittel > 14) f.add('satzmittel:${mittel.toStringAsFixed(1)}');
  }
  for (final t in ts) {
    final m = zahlRegel.firstMatch(t);
    if (m != null) f.add('zahl:${m.group(0)}');
  }
  return f;
}

List<String> ring3(Map<String, Object?> v, KanonIndex k) {
  final f = <String>[];
  final raum = v['raum'];
  if (!k.raeume.contains(raum)) f.add('raum:$raum');
  final ort = v['ort'];
  if (ort != null && !k.orte.containsKey(ort)) f.add('ort:$ort');
  if (ort == 'wc') f.add('ort_wc_gesperrt');
  if (k.orte[ort] != null && k.orte[ort] != raum) f.add('ort_raum');
  for (final x in (v['kanonbezug'] as List? ?? const [])) {
    final s = '$x';
    if (s.startsWith('fakt:')) {
      f.add('fakt_glied');
    } else if (!k.ids.contains(s) && !k.pflicht.contains(s)) {
      f.add('kennung:$s');
    }
  }
  final a = v['aktion'];
  if (a is Map && a['weg'] is List) {
    for (final o in a['weg'] as List) {
      final r = k.orte[o] ?? (k.raeume.contains(o) ? o as String : null);
      if (r == null) {
        f.add('weg:$o');
      } else if (raum is String && !k.erreichbar(raum, r)) {
        f.add('weg_fern:$o');
      }
    }
    final weg = a['weg'] as List;
    if (ort != null && weg.isNotEmpty && weg.last != ort) f.add('weg_endet_nicht_am_ort');
  }
  final z = v['zusatz'];
  if (z != null && !weissliste.contains(z)) f.add('zusatz_nicht_weissliste:$z');
  if (v['folge'] == 'zusatz' && z == null) f.add('zusatz_fehlt');
  if (v['art'] == 'folgeentscheidung' && !k.pflicht.contains(v['nach'])) f.add('nach:${v['nach']}');
  final alle = texte(v).join(' ');
  if (tatzeit.hasMatch(alle)) f.add('tatzeit');
  if (loesungsnah.hasMatch(alle)) f.add('loesungsnah:${loesungsnah.firstMatch(alle)!.group(0)}');
  final sp = neueSpur.firstMatch(alle);
  if (sp != null && z == null) f.add('neue_spur:${sp.group(0)}');
  return f;
}

List<String> ring5(Map<String, Object?> v) {
  final f = <String>[];
  final r = v['runde'];
  if (r != null && r is! int) f.add('runde:$r');
  if (r is int && (r < 1 || r > 3)) f.add('runde:$r');
  if (const {'abstecher', 'folgeentscheidung', 'gag'}.contains(v['art']) && v['raum'] == null) f.add('unerreichbar');
  return f;
}

String signatur(Map<String, Object?> v) => jsonEncode([
      v['art'],
      v['raum'],
      v['ort'],
      (v['aktion'] as Map?)?['art'],
      v['folge'],
      v['zusatz'],
      v['wurf'],
      [for (final o in (v['optionen'] as List? ?? const [])) (o as Map)['folge']],
    ]);

List<Map<String, Object?>> lade(List<String> dateien) {
  final out = <Map<String, Object?>>[];
  for (final p in dateien) {
    var nr = 0;
    for (final z in File(p).readAsLinesSync()) {
      nr++;
      if (z.trim().isEmpty) continue;
      try {
        final j = jsonDecode(z);
        if (j is Map) {
          out.add({...j.cast<String, Object?>(), '_quelle': '$p:$nr'});
        } else {
          out.add({'kennung': '$p:$nr', '_kaputt': 'kein Objekt'});
        }
      } on FormatException catch (e) {
        out.add({'kennung': '$p:$nr', '_kaputt': e.message});
      }
    }
  }
  return out;
}

String _wurzel() => File(Platform.script.toFilePath()).parent.parent.parent.path;

void main(List<String> args) {
  String? arg(String n) {
    final i = args.indexOf(n);
    return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
  }

  final welle = arg('--welle');
  if (welle == null) {
    stdout.writeln('Aufruf: dart run tool/bollwerk/varianten.dart --welle <w> [--ring <n>] [--json <aus>] [--gegen <jsonl>…] [<jsonl>…]');
    exit(2);
  }
  final nurRing = arg('--ring');
  final aus = arg('--json');
  final gegen = <String>[];
  final dateien = <String>[];
  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == '--welle' || a == '--ring' || a == '--json') {
      i++;
    } else if (a == '--gegen') {
      gegen.add(args[++i]);
    } else {
      dateien.add(a);
    }
  }
  if (dateien.isEmpty) {
    final d = Directory('/home/user/bw-varianten/$welle');
    if (d.existsSync()) {
      dateien.addAll([
        for (final f in d.listSync().whereType<File>())
          if (f.path.endsWith('.jsonl') && !f.uri.pathSegments.last.startsWith('FUELL-')) f.path,
      ]..sort());
    }
  }
  final bw = _wurzel();
  final k = KanonIndex(bw);
  final tp = Textpruefer(jsonDecode(File('$bw/content/party/textregeln.json').readAsStringSync()) as Map<String, Object?>);
  final vs = lade(dateien);
  final alt = lade(gegen);
  final altGramme = [for (final v in alt) dreiGramme(texte(v).join(' '), k.namen)];
  final erg = <Map<String, Object?>>[];
  final gramme = <Set<String>>[];
  final gesehen = <String, String>{};
  for (final v in vs) {
    final r = <String, Object?>{'kennung': v['kennung'], 'slot': v['slot'], 'art': v['art'], 'quelle': v['_quelle']};
    if (v.containsKey('_kaputt')) {
      r.addAll({'ring1': ['json'], 'ring2': <String>[], 'ring3': <String>[], 'ring5': <String>[], 'ring6': <String>[]});
      erg.add(r);
      gramme.add({});
      continue;
    }
    r['ring1'] = ring1(v);
    r['ring2'] = ring2(v, tp);
    r['ring3'] = ring3(v, k);
    r['ring5'] = ring5(v);
    final g = dreiGramme(texte(v).join(' '), k.namen);
    final dup = <String>[];
    for (var j = 0; j < gramme.length; j++) {
      final u = g.union(gramme[j]).length;
      if (u > 0 && g.intersection(gramme[j]).length / u >= 0.25) dup.add('dublette:${erg[j]['kennung']}');
    }
    for (var j = 0; j < alt.length; j++) {
      final u = g.union(altGramme[j]).length;
      if (u > 0 && g.intersection(altGramme[j]).length / u >= 0.25) dup.add('dublette_vorrat:${alt[j]['kennung']}');
    }
    final sig = '${v['slot']}|${signatur(v)}';
    if (gesehen.containsKey(sig) && v['art'] != 'text') {
      dup.add('tupel_wie:${gesehen[sig]}');
    } else {
      gesehen[sig] = '${v['kennung']}';
    }
    r['ring6'] = dup;
    gramme.add(g);
    erg.add(r);
  }
  const ringe = ['ring1', 'ring2', 'ring3', 'ring5', 'ring6'];
  final stat = {for (final ring in ringe) ring: erg.where((r) => (r[ring] as List).isEmpty).length};
  final durch = [for (final r in erg) if (ringe.every((x) => (r[x] as List).isEmpty)) r['kennung']];
  for (final r in erg) {
    final rot = [
      for (final x in ringe)
        if ((nurRing == null || x == 'ring$nurRing') && (r[x] as List).isNotEmpty) '$x ${(r[x] as List).join(',')}',
    ];
    if (rot.isNotEmpty) stdout.writeln('${r['kennung']} · ${rot.join(' · ')}');
  }
  if (aus != null) {
    File(aus).writeAsStringSync(const JsonEncoder.withIndent(' ').convert({'welle': welle, 'stat': stat, 'durch': durch, 'einzeln': erg}));
  }
  stdout.writeln('VARIANTEN ${erg.length} · ${stat.entries.map((e) => '${e.key} grün ${e.value}').join(' · ')} · alle Ringe 1–6 grün ${durch.length}');
}
