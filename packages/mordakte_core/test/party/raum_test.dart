// F-03: Räume – Einzelorte genau einmal, jeder Ort begehbar und auf der Karte, alle Ortsangaben im Raumgraph.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

void main() {
  final g = kanon.graph;

  test('Einzelorte gibt es genau einmal', () {
    int anzahlTyp(String typ) => g.einrichtung.values.where((e) => e.typ == typ).length;
    expect(g.raeume.keys.where((r) => r == 'vorratsraum'), hasLength(1), reason: 'Tatort');
    expect(anzahlTyp('vitrine'), 1, reason: 'Vitrine');
    expect(anzahlTyp('ruestung'), 1, reason: 'Rüstung');
    expect(anzahlTyp('sicherungskasten'), 1, reason: 'Sicherungskasten');
    expect(anzahlTyp('jackenstaender'), 1, reason: 'Jackenständer');
    expect(anzahlTyp('fireplace'), 1, reason: 'Kamin');
    expect(g.tueren.values.where((t) => t.id == 'bogentuer'), hasLength(1), reason: 'Turmtür');
    expect(g.tueren.values.where((t) => t.nach == 'draussen' && t.von == 'windfang'), hasLength(1), reason: 'Außentor');
    expect(g.lichtquellen.values.where((l) => l.art == 'kerze'), hasLength(1), reason: 'echte Kerzen nur am Kerzenständer');
    expect(g.lichtquellen.values.where((l) => l.art == 'notlicht'), hasLength(1), reason: 'Notausgangsschild');
  });

  test('die Theke ist ein zusammenhängender Block in einer Reihe', () {
    final theke = g.einrichtung.values.where((e) => e.id.startsWith('theke_')).toList()..sort((a, b) => a.x.compareTo(b.x));
    expect(theke, isNotEmpty);
    expect(theke.map((e) => e.y).toSet(), hasLength(1));
    for (var i = 1; i < theke.length; i++) {
      expect(theke[i].x - theke[i - 1].x, 1, reason: 'Lücke in der Theke bei x=${theke[i].x}');
    }
  });

  test('jeder Ort ist begehbar, liegt in seinem Raum und auf der Karte', () {
    for (final o in g.orte.values) {
      expect(g.raster.walkable(o.x.floor(), o.y.floor()), isTrue, reason: o.id);
      expect(g.raumAn(o.x, o.y)?.id, o.raum, reason: o.id);
      expect(g.karte.charAt(o.x.floor(), o.y.floor()), isNot(TileChar.wall), reason: o.id);
    }
  });

  test('jeder Ort ist von jedem anderen aus erreichbar (außer hinter verschlossenen Toren)', () {
    final start = g.orte['saalmitte']!.id;
    for (final o in g.orte.values) {
      expect(g.weg(start, o.id), isNotNull, reason: o.id);
    }
  });

  test('Außentor und Hoftür sind verschlossen, Vorratsraumtür angelehnt', () {
    expect(g.tueren['aussentor']!.verschlossen, isTrue);
    expect(g.tueren['hoftuer']!.verschlossen, isTrue);
    expect(g.tueren['vorrat_tuer']!.zustand, startsWith('angelehnt'));
  });

  test('jede Ortsangabe im Kanon verweist auf den Raumgraph', () {
    final orte = g.orte.keys.toSet();
    final fehler = <String>[];
    void suche(Object? o, String pfad) {
      if (o is Map) {
        for (final e in o.entries) {
          final k = e.key as String;
          if ({'ort', 'ermittlungsOrt', 'nach'}.contains(k) && e.value is String && !orte.contains(e.value)) fehler.add('$pfad.$k = ${e.value}');
          if (k == 'ueber' && e.value is List) {
            for (final u in e.value as List) {
              if (!orte.contains(u)) fehler.add('$pfad.ueber: $u');
            }
          }
          suche(e.value, '$pfad.$k');
        }
      } else if (o is List) {
        for (var i = 0; i < o.length; i++) {
          suche(o[i], '$pfad[$i]');
        }
      }
    }

    for (final e in kanon.json.entries) {
      if (e.key == 'raeume.json') continue;
      suche(e.value, e.key);
    }
    expect(fehler, isEmpty, reason: fehler.join('\n'));
  });
}
