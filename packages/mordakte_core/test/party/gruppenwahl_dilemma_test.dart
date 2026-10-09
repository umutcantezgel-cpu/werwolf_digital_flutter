// F-08 und G-1: Dilemma-Regeln der Gruppenwahl (Kosten und Nutzen je Option, Täterfassung, Sabotage netto −1).
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

/// Eine Wahl aus gruppenwahl.json.
typedef Wahl = Map<String, Object?>;

const _runden = [1, 2, 3];
const _kostenArten = {'geheimnis', 'freund', 'ziel'};
const _nutzenB = {'ziel', 'freund'};

/// Wert entlang eines Pfads (z. B. `a`, `kosten`, `art`); null, wenn ein Glied fehlt.
Object? _wert(Map<String, Object?>? w, List<String> pfad) {
  Object? x = w;
  for (final k in pfad) {
    if (x is! Map) return null;
    x = x[k];
  }
  return x;
}

/// Die Wahl einer Rolle in einer Runde, sonst null.
Wahl? _wahl(List<Wahl> wahlen, Object? rolle, int runde) {
  for (final w in wahlen) {
    if (w['rolle'] == rolle && w['runde'] == runde) return w;
  }
  return null;
}

/// Option A kostet Geheimnis, Freund oder Ziel und nützt der Gruppe.
List<String> verstoesseOptionA(List<Wahl> wahlen) {
  final f = <String>[];
  for (final w in wahlen) {
    final kosten = _wert(w, ['a', 'kosten', 'art']);
    final nutzen = _wert(w, ['a', 'nutzen', 'art']);
    if (!_kostenArten.contains(kosten)) f.add('${w['id']}: Option A kostet „$kosten“');
    if (nutzen != 'gruppe') f.add('${w['id']}: Option A nützt „$nutzen“');
  }
  return f;
}

/// Option B kostet die Gruppe und nützt Ziel oder Freund.
List<String> verstoesseOptionB(List<Wahl> wahlen) {
  final f = <String>[];
  for (final w in wahlen) {
    final kosten = _wert(w, ['b', 'kosten', 'art']);
    final nutzen = _wert(w, ['b', 'nutzen', 'art']);
    if (kosten != 'gruppe') f.add('${w['id']}: Option B kostet „$kosten“');
    if (!_nutzenB.contains(nutzen)) f.add('${w['id']}: Option B nützt „$nutzen“');
  }
  return f;
}

/// Die Täterfassung (Sabotage) gibt es genau bei den Kernrollen, in allen drei Runden.
List<String> verstoesseSabotage(List<Wahl> wahlen, Set<String> kern) {
  final f = <String>[];
  for (final w in wahlen) {
    final id = w['id'];
    if (!kern.contains(w['rolle'])) {
      if (w['bTaeter'] != null) f.add('$id: Täterfassung bei Nicht-Kernrolle „${w['rolle']}“');
      continue;
    }
    if (w['bTaeter'] is! Map) {
      f.add('$id: Täterfassung fehlt');
      continue;
    }
    if (_wert(w, ['bTaeter', 'art']) != 'sabotage') f.add('$id: Täterfassung ist nicht Sabotage');
    if (_wert(w, ['bTaeter', 'kosten', 'art']) != 'gruppe') f.add('$id: Sabotage kostet nicht die Gruppe');
    if (_wert(w, ['bTaeter', 'nutzen', 'art']) != 'tarnung') f.add('$id: Sabotage nützt nicht die Tarnung');
  }
  for (final r in kern) {
    for (final n in _runden) {
      if (_wert(_wahl(wahlen, r, n), ['bTaeter']) is! Map) f.add('$r in Runde $n: keine Täterfassung');
    }
  }
  return f;
}

/// Jede Option hat in jeder Runde Kosten; Option A kostet nie die Gruppe.
List<String> verstoesseKostenlos(List<Wahl> wahlen) {
  final f = <String>[];
  for (final r in {for (final w in wahlen) w['rolle'] as String}) {
    final runden = [for (final n in _runden) _wahl(wahlen, r, n)];
    for (final teil in const ['a', 'b', 'bTaeter']) {
      if (runden.every((w) => _wert(w, [teil]) == null)) continue; // Option gibt es für diese Rolle nicht
      for (var i = 0; i < _runden.length; i++) {
        final art = _wert(runden[i], [teil, 'kosten', 'art']);
        if (art is! String || art.isEmpty) f.add('$r.$teil in Runde ${_runden[i]}: kostenlos');
      }
    }
    if (runden.any((w) => _wert(w, ['a', 'kosten', 'art']) == 'gruppe')) f.add('$r: Option A kostet die Gruppe');
  }
  return f;
}

/// Bei Quelle Loyalität zeigen Kosten (A) und Nutzen (B) auf loyalitaet.zu der Figur.
List<String> verstoesseLoyalitaetsBezug(List<Wahl> wahlen, Map<String, Wahl> figuren) {
  final f = <String>[];
  for (final w in wahlen) {
    if (w['quelle'] != 'loyalitaet') continue;
    final zu = _wert(figuren[w['rolle']], ['loyalitaet', 'zu']);
    if (zu == null) {
      f.add('${w['id']}: ${w['rolle']} hat im Kanon keine Loyalität');
      continue;
    }
    for (final pfad in const [['a', 'kosten', 'bezug'], ['b', 'nutzen', 'bezug']]) {
      final bezug = _wert(w, pfad);
      if (bezug != zu) f.add('${w['id']}: ${pfad.join('.')} zeigt auf „$bezug“, erwartet „$zu“');
    }
  }
  return f;
}

/// Bei Quelle Geheimnis zeigen die Kosten (A) auf das Nebendelikt der Figur, sonst auf persoenlichesZiel.
List<String> verstoesseGeheimnisBezug(List<Wahl> wahlen, List<Wahl> nebendelikte) {
  final f = <String>[];
  for (final w in wahlen) {
    if (w['quelle'] != 'geheimnis') continue;
    final nd = [for (final n in nebendelikte) if (n['person'] == w['rolle']) n['id']];
    if (nd.length > 1) f.add('${w['rolle']}: mehrere Nebendelikte');
    final erwartet = nd.isEmpty ? 'persoenlichesZiel' : nd.first;
    final bezug = _wert(w, ['a', 'kosten', 'bezug']);
    if (bezug != erwartet) f.add('${w['id']}: A-Kosten zeigt auf „$bezug“, erwartet „$erwartet“');
  }
  return f;
}

/// Gruppenwahl aus einem Kanon, dessen gruppenwahl.json [aendern] verändert (nur für Rot-Proben).
Gruppenwahl _gwMit(void Function(List<Wahl> wahlen) aendern) {
  final k = Kanon.lade((p) {
    final j = leseJson('$repoWurzel/content/party/schlosskeller/$p');
    if (p == 'gruppenwahl.json') aendern((j['wahlen'] as List).cast<Wahl>());
    return j;
  });
  return Gruppenwahl(k);
}

Wahl _eine(List<Wahl> wahlen, String id) => wahlen.firstWhere((w) => w['id'] == id);

bool _meldet(List<String> verstoesse, String praefix) => verstoesse.any((v) => v.startsWith(praefix));

void main() {
  late Gruppenwahl gw;
  late Map<String, Wahl> figuren;
  late List<Wahl> nebendelikte;
  setUpAll(() {
    gw = Gruppenwahl(kanon);
    figuren = {for (final f in kanon.figuren) f['id'] as String: f};
    nebendelikte = (kanon.gegenstaendeJson['nebendelikte'] as List).cast<Wahl>();
  });

  test('60 Wahlen: jede der 20 Rollen hat genau eine Wahl je Runde 1 bis 3', () {
    final wahlen = gw.wahlen;
    expect(wahlen, hasLength(60));
    expect({for (final w in wahlen) w['rolle']}, {for (final f in kanon.figuren) f['id']});
    for (final f in kanon.figuren) {
      expect([for (final w in wahlen) if (w['rolle'] == f['id']) w['runde']], unorderedEquals(_runden), reason: '${f['id']}');
    }
  });

  test('jede Wahl hat als Quelle Geheimnis oder Loyalität', () {
    for (final w in gw.wahlen) {
      expect(w['quelle'], isIn(['geheimnis', 'loyalitaet']), reason: '${w['id']}');
    }
  });

  test('Option A kostet Geheimnis, Freund oder Ziel und nützt der Gruppe (alle 60 Wahlen)', () {
    final v = verstoesseOptionA(gw.wahlen);
    expect(v, isEmpty, reason: v.join('\n'));
  });

  test('Option B kostet die Gruppe und nützt Ziel oder Freund (alle 60 Wahlen)', () {
    final v = verstoesseOptionB(gw.wahlen);
    expect(v, isEmpty, reason: v.join('\n'));
  });

  test('Sabotage gibt es genau bei den Kernrollen, in allen drei Runden', () {
    final v = verstoesseSabotage(gw.wahlen, kanon.kernverdaechtige.toSet());
    expect(v, isEmpty, reason: v.join('\n'));
  });

  test('die Kernrollen sind Ahmet, Fatma, Olli und Can', () {
    expect(kanon.kernverdaechtige, unorderedEquals(['ahmet', 'fatma', 'olli', 'can']));
  });

  test('keine Option ist für eine Rolle in einer Runde kostenlos, und A kostet nie die Gruppe', () {
    final v = verstoesseKostenlos(gw.wahlen);
    expect(v, isEmpty, reason: v.join('\n'));
  });

  test('Loyalitäts-Wahlen zeigen bei Kosten A und Nutzen B auf loyalitaet.zu der Figur', () {
    expect(gw.wahlen.where((w) => w['quelle'] == 'loyalitaet'), isNotEmpty);
    final v = verstoesseLoyalitaetsBezug(gw.wahlen, figuren);
    expect(v, isEmpty, reason: v.join('\n'));
  });

  test('Geheimnis-Wahlen zeigen bei Kosten A auf das Nebendelikt der Figur, sonst auf persoenlichesZiel', () {
    expect(gw.wahlen.where((w) => w['quelle'] == 'geheimnis'), isNotEmpty);
    final v = verstoesseGeheimnisBezug(gw.wahlen, nebendelikte);
    expect(v, isEmpty, reason: v.join('\n'));
  });

  test('Sabotage zählt netto −1: wirksam ist k − 1 für 1 bis n − 1 kooperative Stimmen (n 4 bis 20)', () {
    for (var n = 4; n <= 20; n++) {
      for (var k = 1; k <= n - 1; k++) {
        expect(Gruppenwahl.wirksam(kooperativ: k, sabotage: true), k - 1, reason: 'n=$n, k=$k');
      }
    }
  });

  test('ohne Sabotage zählt jede kooperative Stimme voll (n 4 bis 20)', () {
    for (var n = 4; n <= 20; n++) {
      for (var k = 0; k <= n - 1; k++) {
        expect(Gruppenwahl.wirksam(kooperativ: k, sabotage: false), k, reason: 'n=$n, k=$k');
      }
    }
  });

  test('auswerten zählt mit Sabotage k − 1 und ohne Sabotage k + 1 (n 4 bis 20)', () {
    for (var n = 4; n <= 20; n++) {
      for (var k = 1; k <= n - 1; k++) {
        expect(gw.auswerten(rollen: n, kooperativ: k, taeterSabotiert: true), gw.qualitaet(k - 1, n), reason: 'n=$n, k=$k, Sabotage');
        expect(gw.auswerten(rollen: n, kooperativ: k, taeterSabotiert: false), gw.qualitaet(k + 1, n), reason: 'n=$n, k=$k, kooperativ');
      }
    }
  });

  test('bei null kooperativen Stimmen bleibt die wirksame Zahl bei Sabotage 0', () {
    expect(Gruppenwahl.wirksam(kooperativ: 0, sabotage: true), 0);
  });

  test('Sabotage kann ein wahres Ergebnis kippen: 5 Rollen, 2 kooperative Stimmen', () {
    expect(gw.auswerten(rollen: 5, kooperativ: 2, taeterSabotiert: false), Qualitaet.wahr);
    expect(gw.auswerten(rollen: 5, kooperativ: 2, taeterSabotiert: true), Qualitaet.falsch);
  });

  test('Rot-Probe: Option A mit Kosten „gruppe“ wird als Verstoß gemeldet', () {
    final kaputt = _gwMit((w) {
      (_eine(w, 'gw_ahmet_1')['a'] as Map)['kosten'] = {'art': 'gruppe'};
    });
    final v = verstoesseOptionA(kaputt.wahlen);
    expect(_meldet(v, 'gw_ahmet_1'), isTrue, reason: v.join('\n'));
  });

  test('Rot-Probe: Option B mit Nutzen „gruppe“ wird als Verstoß gemeldet', () {
    final kaputt = _gwMit((w) {
      (_eine(w, 'gw_murat_2')['b'] as Map)['nutzen'] = {'art': 'gruppe'};
    });
    final v = verstoesseOptionB(kaputt.wahlen);
    expect(_meldet(v, 'gw_murat_2'), isTrue, reason: v.join('\n'));
  });

  test('Rot-Probe: fehlende Kosten in Runde 3 werden als kostenlos gemeldet', () {
    final kaputt = _gwMit((w) {
      (_eine(w, 'gw_olli_3')['b'] as Map).remove('kosten');
    });
    final v = verstoesseKostenlos(kaputt.wahlen);
    expect(_meldet(v, 'olli.b in Runde 3'), isTrue, reason: v.join('\n'));
  });

  test('Rot-Probe: Täterfassung bei einer Nicht-Kernrolle wird gemeldet', () {
    final kaputt = _gwMit((w) {
      _eine(w, 'gw_zeynep_1')['bTaeter'] = {
        'art': 'sabotage',
        'kosten': {'art': 'gruppe'},
        'nutzen': {'art': 'tarnung'},
      };
    });
    final v = verstoesseSabotage(kaputt.wahlen, kanon.kernverdaechtige.toSet());
    expect(_meldet(v, 'gw_zeynep_1'), isTrue, reason: v.join('\n'));
  });

  test('Rot-Probe: Loyalitäts-Bezug auf eine andere Person wird gemeldet', () {
    final kaputt = _gwMit((w) {
      (_eine(w, 'gw_ahmet_2')['a'] as Map)['kosten'] = {'art': 'freund', 'bezug': 'emine'};
    });
    final v = verstoesseLoyalitaetsBezug(kaputt.wahlen, figuren);
    expect(_meldet(v, 'gw_ahmet_2'), isTrue, reason: v.join('\n'));
  });

  test('Rot-Probe: Geheimnis-Bezug auf fremdes Nebendelikt wird gemeldet', () {
    final kaputt = _gwMit((w) {
      (_eine(w, 'gw_murat_1')['a'] as Map)['kosten'] = {'art': 'geheimnis', 'bezug': 'nd_schmiere'};
    });
    final v = verstoesseGeheimnisBezug(kaputt.wahlen, nebendelikte);
    expect(_meldet(v, 'gw_murat_1'), isTrue, reason: v.join('\n'));
  });
}
