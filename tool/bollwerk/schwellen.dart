// BOLLWERK · Schwellen maschinell aus Master-Prompt §6 (Abschnitt 0; A-9 §1 SCHWELLEN-NACHTRAG).
// Aufruf:
//   dart run tool/bollwerk/schwellen.dart --aus planung/bollwerk/MASTER-PROMPT.md [--schreibe <json>]
//       liest die Tabellen in „## 6. ZIELFORMEL“, nummeriert je Z-Zeile alle Schwellen (k = 1, 2, …)
//       mit Richtung ≥/≤ und Wert; gibt sha256 von Abschnitt 6 und des JSON aus.
//   dart run tool/bollwerk/schwellen.dart --pruefe <schwellen.json> <SCHWELLEN-NACHTRAG.tsv>
//       je Schwelle gilt der strengere Wert; rot, wenn eine Nachtragszeile lockert oder einen
//       unbekannten Schlüssel nennt.
// Erkannt werden „≥ x“, „≤ x“, Bänder „a–b“ (→ ≥ a und ≤ b) und Zählschwellen „: 0“ bzw. „0 <Wort>“ (→ ≤ 0).
import 'dart:convert';
import 'dart:io';

import 'lib/py_random.dart' show sha256Hex;

class Schwelle {
  final String schluessel;
  final String richtung; // '>=', '<=', '>', '<' oder 'abs<='
  final double wert;
  final String einheit;
  final String kontext;
  Schwelle(this.schluessel, this.richtung, this.wert, this.einheit, this.kontext);
  Map<String, Object> toJson() => {'schluessel': schluessel, 'richtung': richtung, 'wert': wert, 'einheit': einheit, 'kontext': kontext};
}

double _zahl(String s) => double.parse(s.replaceAll('.', '').replaceAll(',', '.'));

String abschnitt6(String prompt) {
  final a = prompt.indexOf('## 6. ZIELFORMEL');
  final b = prompt.indexOf('\n## 7.', a);
  if (a < 0 || b < 0) throw StateError('Abschnitt 6 nicht gefunden');
  return prompt.substring(a, b);
}

List<Schwelle> lies(String text) {
  final aus = <Schwelle>[];
  const zahl = r'(\d+(?:\.\d{3})*(?:,\d+)?)';
  final muster = RegExp(
      '(?<bruch>$zahl\\s*(?:/|von)\\s*$zahl)'
      '|(?<band>$zahl\\s*[–-]\\s*$zahl)\\s*(?<be>%|min|s|×)?'
      '|(?<op>[≥≤<>]|±)\\s*$zahl(?:\\s*(?:/|von)\\s*(?<nenner>\\d+))?\\s*(?<oe>%|×|min|s|px|dp|m|:1)?'
      '|(?<voll>\\b100\\s*%)'
      '|(?<null>(?::|=)\\s*0\\b(?![,.]\\d)|\\b0(?:-mal)?\\s+(?=[A-Za-zÄÖÜäöü„]))');
  for (final zeile in text.split('\n')) {
    if (!zeile.startsWith('| Z-')) continue;
    final zellen = zeile.split('|').map((z) => z.trim()).toList();
    if (zellen.length < 6) continue;
    final nr = zellen[1];
    final schwelle = zellen[4].replaceAll(RegExp(r'`[^`]*`'), ' ');
    var k = 0;
    for (final m in muster.allMatches(schwelle)) {
      final vor = schwelle.substring((m.start - 14).clamp(0, schwelle.length), m.start);
      final kontext = schwelle.substring((m.start - 30).clamp(0, schwelle.length), (m.end + 10).clamp(0, schwelle.length)).trim();
      // Besetzungsangaben und Partienzahlen sind keine Schwellen.
      if (RegExp(r'(Besetzung|Party \(|Seeds?|Partien|je Form ×|Blindprobe:)\s*$').hasMatch(vor)) continue;
      if (m.namedGroup('bruch') != null) {
        final teile = RegExp(zahl).allMatches(m.namedGroup('bruch')!).map((x) => _zahl(x.group(1)!)).toList();
        aus.add(Schwelle('$nr#${++k}', '>=', teile[0], '/${_text(teile[1])}', kontext));
      } else if (m.namedGroup('band') != null) {
        final teile = RegExp(zahl).allMatches(m.namedGroup('band')!).map((x) => _zahl(x.group(1)!)).toList();
        final e = m.namedGroup('be') ?? '';
        aus.add(Schwelle('$nr#${++k}', '>=', teile[0], e, kontext));
        aus.add(Schwelle('$nr#${++k}', '<=', teile[1], e, kontext));
      } else if (m.namedGroup('op') != null) {
        final w = _zahl(RegExp(zahl).firstMatch(m.group(0)!.substring(1))!.group(1)!);
        var op = m.namedGroup('op')!;
        // „kein … ≥ x“ heißt: alles unter x
        if (RegExp(r'\bkein\w*\s+\w+\s*$').hasMatch(vor)) op = op == '≥' ? '<' : (op == '≤' ? '>' : op);
        final richtung = {'≥': '>=', '≤': '<=', '>': '>', '<': '<', '±': 'abs<='}[op]!;
        final nenner = m.namedGroup('nenner');
        aus.add(Schwelle('$nr#${++k}', richtung, w, nenner != null ? '/$nenner' : (m.namedGroup('oe') ?? ''), kontext));
      } else if (m.namedGroup('voll') != null) {
        aus.add(Schwelle('$nr#${++k}', '>=', 100, '%', kontext));
      } else {
        aus.add(Schwelle('$nr#${++k}', '<=', 0, '', kontext));
      }
    }
  }
  return aus;
}

String _text(double w) => w == w.roundToDouble() ? w.toInt().toString() : w.toString();

int pruefe(String jsonPfad, String nachtragPfad) {
  final basis = {
    for (final s in (jsonDecode(File(jsonPfad).readAsStringSync()) as Map)['schwellen'] as List) (s as Map)['schluessel'] as String: s,
  };
  final f = File(nachtragPfad);
  if (!f.existsSync()) {
    stdout.writeln('Schwellen-Nachtrag fehlt: $nachtragPfad');
    return 1;
  }
  final zeilen = f.readAsLinesSync().where((z) => z.trim().isNotEmpty).toList();
  if (zeilen.isEmpty || zeilen.first != 'Schlüssel\tRichtung\tneuer Wert\tS-<n>') {
    stdout.writeln('Kopfzeile des Nachtrags falsch');
    return 1;
  }
  var rot = 0;
  for (final z in zeilen.skip(1)) {
    final t = z.split('\t');
    final b = t.length == 4 ? basis[t[0]] : null;
    if (b == null || t[1] != b['richtung'] || !RegExp(r'^S-\d+$').hasMatch(t[3])) {
      stdout.writeln('Nachtrag unbekannt oder unvollständig: $z');
      rot++;
      continue;
    }
    final neu = double.parse(t[2].replaceAll(',', '.'));
    final alt = (b['wert'] as num).toDouble();
    final r = b['richtung'] as String;
    final strenger = r.startsWith('>') ? neu >= alt : neu <= alt;
    if (!strenger) {
      stdout.writeln('Nachtrag lockert ${t[0]}: $alt → $neu');
      rot++;
    }
  }
  stdout.writeln('Schwellen: ${basis.length} · Nachträge ${zeilen.length - 1} · ${rot == 0 ? 'grün' : 'rot ($rot)'}');
  return rot == 0 ? 0 : 1;
}

void main(List<String> args) {
  final pi = args.indexOf('--pruefe');
  if (pi >= 0) exit(pruefe(args[pi + 1], args[pi + 2]));
  final ai = args.indexOf('--aus');
  if (ai < 0) {
    stdout.writeln('Aufruf: schwellen.dart --aus <MASTER-PROMPT.md> [--schreibe <json>] | --pruefe <json> <tsv>');
    exit(2);
  }
  final a6 = abschnitt6(File(args[ai + 1]).readAsStringSync());
  final liste = lies(a6);
  final zeilen = {for (final s in liste) s.schluessel.split('#').first};
  final json = const JsonEncoder.withIndent(' ').convert({
    'quelle': 'Master-Prompt §6',
    'sha256_abschnitt6': sha256Hex(a6),
    'schwellen': [for (final s in liste) s.toJson()],
  });
  final si = args.indexOf('--schreibe');
  if (si >= 0) File(args[si + 1]).writeAsStringSync('$json\n');
  stdout.writeln(si >= 0 ? json.split('\n').take(4).join('\n') : json);
  stdout.writeln('Schwellen ${liste.length} in ${zeilen.length} Z-Zeilen · sha256 §6 ${sha256Hex(a6)} · sha256 json ${sha256Hex('$json\n')}');
}
