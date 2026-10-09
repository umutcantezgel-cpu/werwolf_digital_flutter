import 'kanon/kanon.dart';

/// Ein Eintrag der Endenmatrix (B-12).
class EndeRegel {
  final String id;
  final String name;
  final bool richtig;
  final int punkteVon, punkteBis;
  const EndeRegel(this.id, this.name, this.richtig, this.punkteVon, this.punkteBis);
}

/// Endenmatrix: Punkte × Anklage → genau ein Ende (F-07).
class Enden {
  final List<EndeRegel> regeln;

  Enden(Kanon kanon)
      : regeln = [
          for (final e in ((kanon.fall['enden'] as Map)['matrix'] as List))
            EndeRegel(
              (e as Map)['id'] as String,
              e['name'] as String,
              e['anklage'] == 'richtig',
              e['punkteVon'] as int,
              e['punkteBis'] as int,
            ),
        ];

  /// Alle Regeln, die auf [punkte] und [richtig] passen (für den Test auf Eindeutigkeit).
  List<EndeRegel> passend(int punkte, bool richtig) =>
      [for (final r in regeln) if (r.richtig == richtig && punkte >= r.punkteVon && punkte <= r.punkteBis) r];

  /// Das Ende zu [punkte] richtigen Entscheidungen und einer richtigen oder falschen Anklage.
  EndeRegel ende(int punkte, bool richtig) {
    final p = passend(punkte, richtig);
    if (p.length != 1) throw StateError('Endenmatrix nicht eindeutig für $punkte Punkte, Anklage ${richtig ? 'richtig' : 'falsch'}');
    return p.single;
  }
}
