// F-10 (F3-TEST-01, Erzähler 7.12): Sammlung vollständig; durchgespielte Abende nutzen nur vorhandene Bausteine,
// Finale und Auflösung erst am Ende, Resümee nennt die sichtbare Restmenge.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

String _datei(String rel) => '$repoWurzel/content/party/schlosskeller/$rel';

/// Textsammlung aus den Dateien des Kanons; [ersatz] ersetzt einzelne Dateien (Rot-Proben).
Textsammlung _sammlungMit([Map<String, Map<String, Object?>> ersatz = const {}]) =>
    Textsammlung.lade((p) => ersatz[p] ?? leseJson(_datei(p)));

Textsammlung? _echt;
Textsammlung get _textsammlung => _echt ??= _sammlungMit();

/// Eine Datei der Textsammlung mit veränderten Einträgen (Rot-Proben).
Map<String, Object?> _geaendert(
  String datei,
  List<Map<String, Object?>> Function(List<Map<String, Object?>> alt) aendern,
) {
  final j = leseJson(_datei(datei));
  final alt = [for (final e in j['eintraege'] as List) (e as Map).cast<String, Object?>()];
  return {...j, 'eintraege': aendern(alt)};
}

/// Ein durchgespielter Abend: der Spielzustand und der Restschlüssel je Runde (in der Reihenfolge der Runden).
typedef _Abend = ({Spiel s, List<String> rest});

/// Spielt einen Abend bis zum Ende. [option] wählt je Entscheidung, [angeklagt] wird angeklagt,
/// [kooperativ] und [taeterSabotiert] bestimmen die Gruppenwahl je Runde.
_Abend _spiele(
  String pfad,
  int rollen, {
  required String Function(Spiel s, Entscheidung e) option,
  required String angeklagt,
  required int kooperativ,
  required bool taeterSabotiert,
}) {
  final s = Spiel(kanon)..weiter();
  s.einrichten(Einstellungen(rollen: rollen, detektiv: 'w', code: FallCode.fuerPfad(pfad, kanon.pfade)));
  final rest = <String>[];
  for (var schritt = 0; s.phase != PartyPhase.ende; schritt++) {
    if (schritt > 100) throw StateError('Abend bleibt in ${s.phase} hängen');
    switch (s.phase) {
      case PartyPhase.entscheidungen:
        for (final e in s.ermittlung.runde(s.runde)) {
          s.waehle(e.id, option(s, e));
        }
      case PartyPhase.gruppenwahl:
        s.abstimmen(kooperativ: kooperativ, taeterSabotiert: taeterSabotiert);
      case PartyPhase.bonus:
        // Das Resümee dieser Runde entsteht beim Weiterschalten; der Schlüssel gilt für den Stand jetzt.
        rest.add(s.erzaehler.restSchluessel(s.ermittlung.restmenge(s.bekannteFakten(s.runde))));
      case PartyPhase.anklage:
        s.anklagen(angeklagt);
      default:
        break;
    }
    s.weiter();
  }
  return (s: s, rest: rest);
}

/// Ein Lauf der Matrix: Pfad, Besetzung, Spielweise, Gruppe und das Ergebnis.
typedef _Lauf = ({String wo, String pfad, int rollen, _Abend a});

List<_Lauf>? _laeufe;

/// Alle Läufe: Pfad × Besetzung {4, 20} × drei Spielweisen × Gruppe (keine kooperative Stimme, alle kooperativ).
List<_Lauf> get _alleLaeufe {
  if (_laeufe != null) return _laeufe!;
  final laeufe = <_Lauf>[];
  for (final pfad in kanon.pfade) {
    final falsch = kanon.kernverdaechtige.firstWhere((p) => p != pfad);
    final weisen = <String, ({String Function(Spiel, Entscheidung) option, String angeklagt})>{
      'bestes Spiel, Anklage des Täters': (option: (s, e) => e.richtig[pfad]!, angeklagt: pfad),
      'erste Option, falsche Anklage': (option: (s, e) => s.optionen(e.id).first.id, angeklagt: falsch),
      'letzte Option, Anklage des Täters': (option: (s, e) => s.optionen(e.id).last.id, angeklagt: pfad),
    };
    for (final rollen in [4, 20]) {
      final gruppen = [
        (name: 'keine kooperative Stimme', kooperativ: 0, sabotiert: true),
        (name: 'alle kooperativ', kooperativ: rollen - 1, sabotiert: false),
      ];
      for (final w in weisen.entries) {
        for (final g in gruppen) {
          final a = _spiele(
            pfad,
            rollen,
            option: w.value.option,
            angeklagt: w.value.angeklagt,
            kooperativ: g.kooperativ,
            taeterSabotiert: g.sabotiert,
          );
          laeufe.add((wo: '$pfad, $rollen Rollen, ${w.key}, ${g.name}', pfad: pfad, rollen: rollen, a: a));
        }
      }
    }
  }
  return _laeufe = laeufe;
}

/// Schritt 10: Jede Kennung eines Abends gibt es (Hinweise aus bonus.json, alles andere aus der Sammlung).
/// Finale und Rückblende kommen genau einmal vor, Auflösung „taeter“ nur für die Täterperson.
List<String> _kennungFehler(
  List<String> bausteine,
  Textsammlung t,
  Set<String> hinweise, {
  required String pfad,
  required String ende,
  required Set<String> besetzteKern,
}) {
  final f = <String>[];
  for (final k in bausteine) {
    if (k.startsWith('hinweis.')) {
      if (!hinweise.contains(k.substring('hinweis.'.length))) f.add('$k: kein Hinweis in bonus.json');
    } else if (!t.bausteine.containsKey(k)) {
      f.add('$k: nicht in der Textsammlung');
    }
  }
  int anzahl(String k) => bausteine.where((x) => x == k).length;
  if (anzahl('finale.$pfad.$ende') != 1) f.add('finale.$pfad.$ende: ${anzahl('finale.$pfad.$ende')} statt 1');
  if (anzahl('rueckblende.$pfad') != 1) f.add('rueckblende.$pfad: ${anzahl('rueckblende.$pfad')} statt 1');
  final finale = bausteine.where((x) => x.startsWith('finale.')).length;
  if (finale != 1) f.add('$finale Finaltexte statt 1');
  for (final k in besetzteKern) {
    final taeter = anzahl('aufloesung.$k.taeter');
    final unschuldig = anzahl('aufloesung.$k.unschuldig');
    if (k == pfad) {
      if (taeter != 1 || unschuldig != 0) f.add('aufloesung.$k: Täterfassung $taeter, unschuldig $unschuldig');
    } else if (taeter != 0 || unschuldig != 1) {
      f.add('aufloesung.$k: taeter $taeter, unschuldig $unschuldig (nur unschuldig)');
    }
  }
  return f;
}

const _vorFinale = ['intro.', 'runde.', 'bonus.rahmen', 'hinweis.', 'resuemee.', 'anklage.'];

/// Schritt 11: Vor dem ersten finale.-Baustein steht nichts aus Finale, Rückblende oder Auflösung.
List<String> _vorFinaleFehler(List<String> bausteine) {
  final erster = bausteine.indexWhere((k) => k.startsWith('finale.'));
  if (erster < 0) return ['kein finale.-Baustein im Abend'];
  return [
    for (final k in bausteine.take(erster))
      if (!_vorFinale.any((p) => k.startsWith(p))) 'vor dem Finale: $k',
  ];
}

/// Schritt 12: Das Resümee jeder Runde nennt genau die Restmenge des Stands dieser Runde.
List<String> _restFehler(List<String> ist, List<String> soll) {
  final f = <String>[];
  if (ist.length != soll.length) f.add('${ist.length} Restschlüssel statt ${soll.length}');
  for (var i = 0; i < soll.length && i < ist.length; i++) {
    if (ist[i] != soll[i]) f.add('Runde ${i + 1}: ${ist[i]} statt ${soll[i]}');
  }
  return f;
}

void main() {
  final hinweise = {for (final h in kanon.bonusJson['hinweise'] as List) (h as Map)['id'] as String};

  test('Sammlung vollständig: keine Erzähler-, Dossier-, Gesprächs-, Wahl- oder Täterlücke', () {
    final f = textLuecken(kanon, _textsammlung);
    expect(f, isEmpty, reason: f.join('\n'));
  });

  test('Durchgespielte Abende nutzen nur vorhandene Bausteine (Pfade, 4 und 20 Rollen, drei Spielweisen, zwei Gruppen)', () {
    expect(_alleLaeufe, hasLength(48), reason: 'Matrix: 4 Pfade × 2 Besetzungen × 3 Spielweisen × 2 Gruppen');
    final f = <String>[];
    for (final l in _alleLaeufe) {
      final besetzteKern = {for (final k in kanon.kernverdaechtige) if (l.a.s.besetzung.istBesetzt(k, l.rollen)) k};
      f.addAll(_kennungFehler(
        l.a.s.bausteine,
        _textsammlung,
        hinweise,
        pfad: l.pfad,
        ende: l.a.s.ende.id,
        besetzteKern: besetzteKern,
      ).map((x) => '${l.wo}: $x'));
    }
    expect(f, isEmpty, reason: f.join('\n'));
  });

  test('Vor dem Finale nichts aus Finale, Rückblende oder Auflösung', () {
    final f = <String>[];
    for (final l in _alleLaeufe) {
      f.addAll(_vorFinaleFehler(l.a.s.bausteine).map((x) => '${l.wo}: $x'));
    }
    expect(f, isEmpty, reason: f.join('\n'));
  });

  test('Resümee nennt genau die sichtbare Restmenge je Runde', () {
    final f = <String>[];
    for (final l in _alleLaeufe) {
      expect(l.a.rest, hasLength(3), reason: '${l.wo}: drei Runden mit Resümee');
      final ist = [for (final k in l.a.s.bausteine) if (k.startsWith('resuemee.rest.')) k];
      f.addAll(_restFehler(ist, l.a.rest).map((x) => '${l.wo}: $x'));
    }
    expect(f, isEmpty, reason: f.join('\n'));
  });

  test('Rot-Probe: ein fehlender Finaltext wird in der Lückenliste genannt', () {
    final t = _sammlungMit({
      'texte/erzaehler-finale-ahmet.json': _geaendert(
        'texte/erzaehler-finale-ahmet.json',
        (alt) => [for (final e in alt) if (e['id'] != 'finale.ahmet.ende_meister') e],
      ),
    });
    final f = textLuecken(kanon, t);
    expect(f.any((x) => x.contains('finale.ahmet.ende_meister')), isTrue, reason: f.join('\n'));
  });

  test('Rot-Probe: fremde Kennung und fehlender Hinweis werden gemeldet', () {
    final f = _kennungFehler(
      ['intro.start', 'intro.fremd.xyz', 'hinweis.h_gibt_es_nicht', 'finale.ahmet.ende_meister', 'rueckblende.ahmet'],
      _textsammlung,
      hinweise,
      pfad: 'ahmet',
      ende: 'ende_meister',
      besetzteKern: {'ahmet'},
    );
    expect(f.any((x) => x.startsWith('intro.fremd.xyz')), isTrue, reason: f.join('\n'));
    expect(f.any((x) => x.startsWith('hinweis.h_gibt_es_nicht')), isTrue, reason: f.join('\n'));
  });

  test('Rot-Probe: eine Auflösung vor dem Finale wird gemeldet', () {
    final f = _vorFinaleFehler(['intro.start', 'aufloesung.gruppe.1', 'finale.ahmet.ende_meister']);
    expect(f, ['vor dem Finale: aufloesung.gruppe.1']);
  });

  test('Rot-Probe: ein falscher Restschlüssel im Resümee wird gemeldet', () {
    final f = _restFehler(['resuemee.rest.eins'], ['resuemee.rest.alle']);
    expect(f, ['Runde 1: resuemee.rest.eins statt resuemee.rest.alle']);
  });
}
