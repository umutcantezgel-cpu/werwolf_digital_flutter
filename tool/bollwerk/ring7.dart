// BOLLWERK · Ring 7 (Qualität, F5): Richterstapel bauen und Urteile auswerten (A-5 Teil 1, A-8 §1.2,
// A-8 Teil 2 F5 und Nachtrag M6 „Annahme mit fünf Richtern“).
//
//   dart run tool/bollwerk/ring7.dart stapel --welle <w> --ringe <ringe.json> --fuell <FUELL.jsonl> [--n-fuell 20]
//     Nimmt alle Varianten, die Ringe 1–6 bestehen (Feld `durch`), mischt per Seed 20 Füllstücke
//     (10 offensichtliche, 10 subtile) aus dem Füllstück-Vorrat ein und schreibt
//       /home/user/bw-varianten/<w>/ring7/stapel.jsonl   (nur Spielfelder, Nummer P001…, keine Kennung)
//       /home/user/bw-logs/ring7-<w>/loesung.json        (Nummer → Kennung bzw. Füllstück; nie im Stapel)
//     Seed = erste 8 Hex von sha256("<w>|<Inhalts-Hash>"), Inhalts-Hash = sha256 der Merge-Eingaben
//     (sortierte kanonische Zeilen aller Stapel-Varianten und des Füllstück-Vorrats).
//   dart run tool/bollwerk/ring7.dart auswerten --welle <w> --urteile <json>… [--loesung <pfad>] [--json <aus>]
//     Angenommen: ≥ 2 von 3 Stimmen ≥ 7 und Wirkung „ja“; bei Spreizung > 2 entscheidet allein der Median
//     aller fünf Stimmen (zwei Zusatzrichter Kanon, Ton); fehlen sie, steht die Einheit auf „zusatzrunde“.
//     F5: ≥ 18/20 Füllstücke abgelehnt und davon ≥ 8/10 subtile, sonst ist die Welle ungültig.
//     Letzte Zeile „RING7 <w> · angenommen <a> von <n> · Füllstücke abgelehnt <f>/20 (subtil <s>/10) · GÜLTIG|UNGÜLTIG“.
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';

import 'lib/py_random.dart' show sha256Hex;

const spielfelder = ['art', 'raum', 'ort', 'runde', 'nach', 'titel', 'text', 'aktion', 'wurf', 'stufen', 'folge', 'optionen', 'zusatz'];

String kanonisch(Object? o) {
  if (o is Map) {
    final k = o.keys.map((e) => '$e').toList()..sort();
    return '{${k.map((x) => '${jsonEncode(x)}:${kanonisch(o[x])}').join(',')}}';
  }
  if (o is List) return '[${o.map(kanonisch).join(',')}]';
  return jsonEncode(o);
}

List<Map<String, Object?>> ladeJsonl(String p) => [
      for (final z in File(p).readAsLinesSync())
        if (z.trim().isNotEmpty) (jsonDecode(z) as Map).cast<String, Object?>(),
    ];

List<T> mische<T>(List<T> l, Rng r) {
  final a = [...l];
  for (var i = a.length - 1; i > 0; i--) {
    final j = r.nextInt(i + 1);
    final t = a[i];
    a[i] = a[j];
    a[j] = t;
  }
  return a;
}

void stapel(String welle, String ringe, String fuell, int nFuell) {
  final r = jsonDecode(File(ringe).readAsStringSync()) as Map<String, Object?>;
  final durch = (r['durch'] as List).map((e) => '$e').toSet();
  final quellen = <String, Map<String, Object?>>{};
  for (final e in (r['einzeln'] as List)) {
    final m = e as Map;
    if (durch.contains(m['kennung'])) {
      final q = '${m['quelle']}';
      final datei = q.substring(0, q.lastIndexOf(':'));
      final nr = int.parse(q.substring(q.lastIndexOf(':') + 1));
      final v = (jsonDecode(File(datei).readAsLinesSync()[nr - 1]) as Map).cast<String, Object?>();
      quellen['${m['kennung']}'] = v;
    }
  }
  final fs = ladeJsonl(fuell);
  final eingaben = [...quellen.values.map(kanonisch), ...fs.map(kanonisch)]..sort();
  final inhalt = sha256Hex(eingaben.join('\n'));
  final seed = sha256Hex('$welle|$inhalt').substring(0, 8);
  final rng = Rng(Rng.hashString('ring7:$seed'));
  final offen = mische(fs.where((f) => f['fuell'] == 'offensichtlich').toList(), rng).take(nFuell ~/ 2);
  final subtil = mische(fs.where((f) => f['fuell'] == 'subtil').toList(), rng).take(nFuell - nFuell ~/ 2);
  final eintraege = <(String, Map<String, Object?>)>[
    for (final e in quellen.entries) (e.key, e.value),
    for (final f in [...offen, ...subtil]) ('FUELL:${f['fuell']}:${f['kennung']}', f),
  ];
  final gemischt = mische(eintraege, rng);
  final aus = Directory('/home/user/bw-varianten/$welle/ring7')..createSync(recursive: true);
  final log = Directory('/home/user/bw-logs/ring7-$welle')..createSync(recursive: true);
  final zeilen = StringBuffer();
  final loesung = <String, String>{};
  for (var i = 0; i < gemischt.length; i++) {
    final nr = 'P${(i + 1).toString().padLeft(3, '0')}';
    final v = gemischt[i].$2;
    zeilen.writeln(jsonEncode({'nr': nr, for (final k in spielfelder) if (v.containsKey(k)) k: v[k]}));
    loesung[nr] = gemischt[i].$1;
  }
  File('${aus.path}/stapel.jsonl').writeAsStringSync(zeilen.toString());
  File('${log.path}/loesung.json').writeAsStringSync(const JsonEncoder.withIndent(' ').convert(
      {'welle': welle, 'inhalt_sha256': inhalt, 'seed': seed, 'n': gemischt.length, 'loesung': loesung}));
  stdout.writeln('STAPEL $welle · ${gemischt.length} Bausteine (${quellen.length} Varianten + ${offen.length + subtil.length} Füllstücke) '
      '· Seed $seed · Inhalt $inhalt · ${aus.path}/stapel.jsonl');
}

double median(List<int> l) {
  final s = [...l]..sort();
  final m = s.length ~/ 2;
  return s.length.isOdd ? s[m].toDouble() : (s[m - 1] + s[m]) / 2;
}

void auswerten(String welle, List<String> urteile, String loesungPfad, String? aus) {
  final l = jsonDecode(File(loesungPfad).readAsStringSync()) as Map<String, Object?>;
  final loesung = (l['loesung'] as Map).cast<String, String>();
  // Stimmen je Nummer: (Richter, Linse, Punkte, Wirkung)
  final stimmen = <String, List<(String, String, int, bool)>>{};
  final richter = <String>[];
  for (final p in urteile) {
    final j = jsonDecode(File(p).readAsStringSync()) as Map<String, Object?>;
    final name = '${j['richter']}';
    richter.add(name);
    for (final u in j['urteile'] as List) {
      final m = u as Map;
      final pk = (m['punkte'] as num).toInt();
      final w = m['wirkung'] is bool ? m['wirkung'] as bool : '${m['wirkung']}'.toLowerCase() != 'nein';
      stimmen.putIfAbsent('${m['nr']}', () => []).add((name, '${j['linse']}', pk, w));
    }
  }
  final ergebnis = <String, Map<String, Object?>>{};
  var angenommen = 0, fuellAb = 0, fuellN = 0, subtilAb = 0, subtilN = 0, zusatz = 0, fehlend = 0;
  for (final nr in loesung.keys) {
    final s = stimmen[nr] ?? const [];
    // Wirkung „nein“ ist eine Ablehnung dieser Stimme (A-8 §1.2)
    final pk = [for (final x in s) x.$4 ? x.$3 : 0];
    String status;
    if (pk.length < 3) {
      status = 'unvollständig';
      fehlend++;
    } else {
      final spreizung = pk.reduce((a, b) => a > b ? a : b) - pk.reduce((a, b) => a < b ? a : b);
      if (spreizung > 2 && pk.length < 5) {
        status = 'zusatzrunde';
        zusatz++;
      } else if (spreizung > 2) {
        status = median(pk) >= 7 ? 'angenommen' : 'abgelehnt';
      } else {
        status = pk.where((p) => p >= 7).length >= 2 ? 'angenommen' : 'abgelehnt';
      }
    }
    final wer = loesung[nr]!;
    if (wer.startsWith('FUELL:')) {
      fuellN++;
      if (status != 'angenommen') fuellAb++;
      if (wer.startsWith('FUELL:subtil')) {
        subtilN++;
        if (status != 'angenommen') subtilAb++;
      }
    } else if (status == 'angenommen') {
      angenommen++;
    }
    ergebnis[nr] = {'kennung': wer, 'status': status, 'stimmen': [for (final x in s) {'richter': x.$1, 'linse': x.$2, 'punkte': x.$3, 'wirkung': x.$4}]};
  }
  final gueltig = fuellN >= 20 && fuellAb >= 18 && subtilAb >= 8 && zusatz == 0 && fehlend == 0;
  final n = loesung.length - fuellN;
  if (aus != null) {
    File(aus).writeAsStringSync(const JsonEncoder.withIndent(' ').convert({
      'welle': welle,
      'richter': richter,
      'inhalt_sha256': l['inhalt_sha256'],
      'seed': l['seed'],
      'angenommen': angenommen,
      'varianten': n,
      'fuell_abgelehnt': fuellAb,
      'fuell_n': fuellN,
      'subtil_abgelehnt': subtilAb,
      'zusatzrunde': [for (final e in ergebnis.entries) if (e.value['status'] == 'zusatzrunde') e.key],
      'gueltig': gueltig,
      'einzeln': ergebnis,
    }));
  }
  stdout.writeln('RING7 $welle · angenommen $angenommen von $n · Füllstücke abgelehnt $fuellAb/$fuellN (subtil $subtilAb/$subtilN)'
      '${zusatz > 0 ? ' · Zusatzrunde $zusatz' : ''}${fehlend > 0 ? ' · unvollständig $fehlend' : ''} · ${gueltig ? 'GÜLTIG' : 'UNGÜLTIG'}');
}

void main(List<String> args) {
  String? arg(String n) {
    final i = args.indexOf(n);
    return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
  }

  final welle = arg('--welle');
  if (args.isEmpty || welle == null) {
    stdout.writeln('Aufruf: ring7.dart stapel --welle <w> --ringe <json> --fuell <jsonl> | auswerten --welle <w> --urteile <json>…');
    exit(2);
  }
  if (args.first == 'stapel') {
    stapel(welle, arg('--ringe')!, arg('--fuell')!, int.parse(arg('--n-fuell') ?? '20'));
  } else if (args.first == 'auswerten') {
    final urteile = <String>[];
    for (var i = args.indexOf('--urteile') + 1; i < args.length && !args[i].startsWith('--'); i++) {
      urteile.add(args[i]);
    }
    auswerten(welle, urteile, arg('--loesung') ?? '/home/user/bw-logs/ring7-$welle/loesung.json', arg('--json'));
  } else {
    exit(2);
  }
}
