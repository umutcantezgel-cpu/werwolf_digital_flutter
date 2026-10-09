/// Rollen-Fähigkeiten und exklusive Sichtschichten (Z-05), aus
/// `data/rollen/faehigkeiten.json` (Auftrag A-402a). Jede Rolle der Clique hat genau
/// eine Fähigkeit; sie zeigt nur öffentliche Tatsachen aus dem Blickwinkel ihres Berufs
/// und nur der Rolle selbst.
library;

import '../welt/spuren.dart';

enum FaehigkeitArt { station, gespraech, werkzeug, sicht, bewegung }

class Faehigkeit {
  final String rolle, name, sichtschicht, zeigt;
  final FaehigkeitArt art;

  /// Auslöser: Station (beim Untersuchen), Gespräch/Begegnung mit [gespraechMit]
  /// (null = mit jeder Rolle), erstes Betreten von [bereich], Werkzeug an [werkzeug].
  final String? station, gespraechMit, bereich, werkzeug;
  final bool gespraech;

  /// Spurenarten, die diese Rolle zusätzlich zum Detektiv sieht.
  final Set<SpurArt> spurarten;

  const Faehigkeit(this.rolle, this.name, this.art, this.sichtschicht, this.zeigt,
      {this.station, this.gespraech = false, this.gespraechMit, this.bereich, this.werkzeug, this.spurarten = const {}});

  factory Faehigkeit.ausJson(Map<String, dynamic> j) {
    final a = j['ausloeser'] as Map<String, dynamic>;
    final s = j['sichtschicht'] as Map<String, dynamic>;
    return Faehigkeit(
      j['rolle'] as String,
      j['faehigkeit'] as String,
      FaehigkeitArt.values.byName((j['wirkung'] as Map)['art'] as String),
      s['name'] as String,
      s['zeigt'] as String,
      station: a['station'] as String?,
      gespraech: a.containsKey('gespraech'),
      gespraechMit: a['gespraech'] as String?,
      bereich: a['bereich'] as String?,
      werkzeug: a['werkzeug'] as String?,
      spurarten: {for (final x in s['spurarten'] as List) SpurArt.values.byName(x as String)},
    );
  }

  /// Text der Sichtschicht, wie ihn die Rolle sieht.
  String get text => '$sichtschicht ($name): $zeigt';
}

/// Liest `faehigkeiten.json` (`{"version":1,"rollen":[…]}`).
Map<String, Faehigkeit> faehigkeitenAusJson(Map<String, dynamic> j) => {
      for (final r in j['rollen'] as List) (r as Map<String, dynamic>)['rolle'] as String: Faehigkeit.ausJson(r),
    };

/// Spuren mit den Sichtschichten der Rollen: Wer eine Spurenart lesen kann, sieht
/// solche Spuren zusätzlich zum Detektiv.
List<Spur> spurenMitSichtschichten(List<Spur> spuren, Map<String, Faehigkeit> faehigkeiten) => [
      for (final s in spuren)
        s.mitSicht({...s.sicht, for (final f in faehigkeiten.values) if (f.spurarten.contains(s.art)) f.rolle}),
    ];
