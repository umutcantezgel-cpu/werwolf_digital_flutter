import 'ablauf.dart';
import 'gruppenwahl.dart';
import 'kanon/kanon.dart';

/// Bausteinwahl des Erzählers (Master 7.12). Der Spielzustand wählt feste
/// Kennungen; die Texte stehen in der Textsammlung des Kanons (F3).
///
/// Vor dem Finale hängt jede Wahl nur am Wissen des Detektivs (S-1): an
/// aufgedeckten Fakten, Restmenge und dem sichtbaren Gruppenergebnis. Einzige
/// Ausnahme ist der Bonus-Hinweis selbst, der als wahrer, neutraler oder
/// falscher Satz im selben Rahmen kommt.
class Erzaehler {
  final Kanon kanon;
  Erzaehler(this.kanon);

  static const belastend = {'spaetankunft', 'zusatzindiz', 'fundort', 'schluesselbeweis'};

  List<String> intro(Spiel s) {
    final lacher = [for (final l in (kanon.json['setting.json']!['lacher'] as List? ?? const [])) (l as Map).cast<String, Object?>()];
    return [
      'intro.start',
      for (final l in lacher) 'intro.lacher.${l['id']}.${s.besetzung.istBesetzt(l['wer'] as String, s.einstellungen.rollen) ? 'besetzt' : 'npc'}',
      'intro.auftrag.${s.einstellungen.detektiv}',
    ];
  }

  List<String> rundenStart(int runde) => ['runde.$runde.start'];

  List<String> bonus(Spiel s) {
    final q = s.qualitaeten[s.runde]!;
    final h = s.gruppe.hinweis(s.pfad, s.runde, q);
    return ['bonus.rahmen', 'hinweis.${h['id']}'];
  }

  /// Drei Fächer: Gruppenergebnis, Stand der Restverdächtigen, Lage.
  List<String> resuemee(Spiel s) {
    final q = s.qualitaeten[s.runde]!;
    final fakten = s.bekannteFakten(s.runde);
    return [
      'resuemee.gruppe.${Gruppenwahl.zusammengehalten(q) ? 'zusammen' : 'uneins'}',
      restSchluessel(s.ermittlung.restmenge(fakten)),
      'resuemee.lage.${s.runde}.${lageStufe(s, fakten)}',
    ];
  }

  /// Schlüssel für die Restmenge; bei nur einer Person ohne Namen (S-1).
  String restSchluessel(Set<String> rest) {
    final kern = kanon.kernverdaechtige;
    if (rest.length == kern.length) return 'resuemee.rest.alle';
    if (rest.length == 1) return 'resuemee.rest.eins';
    return 'resuemee.rest.${[for (final p in kern) if (rest.contains(p)) p].join('_')}';
  }

  String lageStufe(Spiel s, Set<String> fakten) {
    final typen = {for (final f in fakten) s.ermittlung.fakten[f]!.typ};
    if (typen.contains('schluesselbeweis')) return 'klar';
    if (typen.any(belastend.contains)) return 'spur';
    return 'offen';
  }

  List<String> anklage() => ['anklage.start'];

  List<String> finale(Spiel s) => ['finale.${s.pfad}.${s.ende.id}', 'rueckblende.${s.pfad}'];

  List<String> aufloesung(Spiel s) => [
        for (final r in s.besetzt)
          if (kanon.kernverdaechtige.contains(r)) 'aufloesung.$r.${r == s.pfad ? 'taeter' : 'unschuldig'}' else 'aufloesung.$r',
      ];

  /// Alle Kennungen, die der Erzähler je wählen kann (Katalog für F3).
  List<String> katalog() {
    final kern = kanon.kernverdaechtige;
    final lacher = [for (final l in (kanon.json['setting.json']!['lacher'] as List? ?? const [])) (l as Map)['id'] as String];
    final paare = <String>[];
    for (var a = 0; a < kern.length; a++) {
      for (var b = a + 1; b < kern.length; b++) {
        paare.add('resuemee.rest.${kern[a]}_${kern[b]}');
      }
    }
    final dreier = [
      for (final weg in kern) 'resuemee.rest.${[for (final p in kern) if (p != weg) p].join('_')}',
    ];
    final enden = [for (final e in ((kanon.fall['enden'] as Map)['matrix'] as List)) (e as Map)['id'] as String];
    return [
      'intro.start',
      for (final l in lacher) ...['intro.lacher.$l.besetzt', 'intro.lacher.$l.npc'],
      'intro.auftrag.m',
      'intro.auftrag.w',
      for (var r = 1; r <= 3; r++) 'runde.$r.start',
      'bonus.rahmen',
      'resuemee.gruppe.zusammen',
      'resuemee.gruppe.uneins',
      'resuemee.rest.alle',
      ...dreier,
      ...paare,
      'resuemee.rest.eins',
      for (var r = 1; r <= 3; r++) for (final st in ['offen', 'spur', 'klar']) 'resuemee.lage.$r.$st',
      'anklage.start',
      for (final p in kanon.pfade) ...[for (final e in enden) 'finale.$p.$e', 'rueckblende.$p'],
      for (final r in kanon.figuren.map((f) => f['id'] as String))
        if (kern.contains(r)) ...['aufloesung.$r.taeter', 'aufloesung.$r.unschuldig'] else 'aufloesung.$r',
    ];
  }
}
