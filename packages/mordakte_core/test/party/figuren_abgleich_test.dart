// F-02: Quellabgleich – jedes Element des Quellmaterials steht im Kanon oder ist begründet verworfen.
import 'dart:io';

import 'package:crypto/crypto.dart' show sha256;
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

void main() {
  final ordner = '$repoWurzel/content/party/schlosskeller';
  final abgleich = leseJson('$ordner/quellabgleich.json');
  final eintraege = (abgleich['eintraege'] as List).cast<Map<String, Object?>>();
  final planung = '$repoWurzel/planung/finalisierung-schlosskeller';
  final entscheidungen = RegExp(r'^## (E-\d{3})', multiLine: true)
      .allMatches(File('$planung/ENTSCHEIDUNGSLOG.md').readAsStringSync())
      .map((m) => m.group(1)!)
      .toSet();
  final brueche = RegExp(r'^\| ([BVA]-\d\d) \|', multiLine: true)
      .allMatches(File('$planung/BRUCHLISTE.md').readAsStringSync())
      .map((m) => m.group(1)!)
      .toSet();
  const status = {'übernommen', 'angepasst', 'verworfen', 'spaeter', 'ausserhalb'};

  Object? aufloesen(String ziel) {
    final teile = ziel.split('#');
    final datei = teile.first;
    final f = File('$ordner/$datei');
    if (!f.existsSync()) return null;
    if (teile.length == 1) return true;
    if (!datei.endsWith('.json')) return null;
    Object? o = leseJson(f.path);
    for (final t in teile[1].split('.')) {
      if (o is Map) {
        if (o.containsKey(t)) {
          o = o[t];
          continue;
        }
        Object? gefunden;
        if (datei == 'figuren.json' && (t == 'detektiv' || t == 'opfer')) gefunden = o[t];
        for (final v in o.values) {
          if (gefunden != null) break;
          if (v is List) {
            for (final x in v) {
              if (x is Map && x['id'] == t) gefunden = x;
            }
          }
        }
        o = gefunden;
      } else if (o is List) {
        o = o.cast<Object?>().firstWhere((x) => x is Map && x['id'] == t, orElse: () => null);
      } else {
        return null;
      }
      if (o == null) return null;
    }
    return o;
  }

  test('jedes Ziel zeigt auf eine vorhandene Kanon-Stelle', () {
    final fehler = <String>[];
    for (final e in eintraege) {
      for (final z in (e['ziel'] as List).cast<String>()) {
        if (aufloesen(z) == null) fehler.add('${e['id']}: Ziel $z fehlt');
      }
    }
    expect(fehler, isEmpty, reason: fehler.join('\n'));
  });

  test('jeder Status ist gültig, jede Abweichung begründet, jeder Grund existiert', () {
    final fehler = <String>[];
    for (final e in eintraege) {
      final s = e['status'] as String;
      final gruende = (e['grund'] as List).cast<String>();
      if (!status.contains(s)) fehler.add('${e['id']}: Status $s');
      if (s != 'übernommen' && gruende.isEmpty) fehler.add('${e['id']}: $s ohne Grund');
      if (s == 'übernommen' && (e['ziel'] as List).isEmpty) fehler.add('${e['id']}: übernommen ohne Ziel');
      for (final g in gruende) {
        if (!entscheidungen.contains(g) && !brueche.contains(g)) fehler.add('${e['id']}: Grund $g unbekannt');
      }
    }
    expect(fehler, isEmpty, reason: fehler.join('\n'));
  });

  test('jede Person ist aus JSON und Figurenliste abgeglichen, alle Quellteile vertreten', () {
    for (final p in kanon.personen) {
      expect(eintraege.where((e) => e['quelle'] == 'J' && (e['element'] as String).startsWith('$p.')), isNotEmpty, reason: 'JSON: $p');
      expect(eintraege.where((e) => e['quelle'] == 'L' && (e['element'] as String).startsWith('$p:')), isNotEmpty, reason: 'Liste: $p');
    }
    expect({for (final e in eintraege) e['quelle']}, {'S', 'M', 'R', 'L', 'J', 'T'});
  });

  test('keine wörtlichen Chat-Passagen in den Kurzbezeichnungen', () {
    for (final e in eintraege) {
      expect((e['element'] as String).length, lessThanOrEqualTo(100), reason: '${e['id']}');
    }
  });

  test('Abgleich ist aktuell zum lokalen Rohchat (nur wenn er lokal vorhanden ist)', () {
    final chat = File('$repoWurzel/quellen/schlosskeller-teamchat.txt');
    if (!chat.existsSync()) {
      markTestSkipped('Rohchat nicht lokal vorhanden (bleibt außerhalb des Repos)');
      return;
    }
    expect(sha256.convert(chat.readAsBytesSync()).toString(), abgleich['quelleSha256']);
  });
}
