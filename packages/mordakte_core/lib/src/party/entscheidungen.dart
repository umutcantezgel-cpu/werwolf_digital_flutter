import 'kanon/kanon.dart';
import 'spuren.dart';

/// Ein Fakt, den eine Detektiv-Entscheidung aufdecken kann (E-024).
/// Seine Quelle ist eine Beobachtung oder eine Spur im Kanon; es gibt ihn in
/// einem Pfad genau dann, wenn die Quelle dort entsteht.
class Fakt {
  final String id;
  final String typ;
  final List<String> personen;
  final String? beobachtung;
  final String? spur;

  const Fakt({required this.id, required this.typ, required this.personen, this.beobachtung, this.spur});

  factory Fakt.fromJson(Map j) {
    final q = j['quelle'] as Map;
    return Fakt(
      id: j['id'] as String,
      typ: j['typ'] as String,
      personen: [for (final p in j['personen'] as List) p as String],
      beobachtung: q['beobachtung'] as String?,
      spur: q['spur'] as String?,
    );
  }
}

class EntscheidungsOption {
  final String id;
  final String text;
  final Map<String, String> ziel;
  final List<String> fakten;

  const EntscheidungsOption({required this.id, required this.text, required this.ziel, required this.fakten});

  factory EntscheidungsOption.fromJson(Map j) => EntscheidungsOption(
        id: j['id'] as String,
        text: j['text'] as String,
        ziel: (j['ziel'] as Map).map((k, v) => MapEntry(k as String, v as String)),
        fakten: [for (final f in j['fakten'] as List) f as String],
      );
}

/// Begründungskette zu einer richtigen Option (Master 7.7).
class Begruendung {
  final List<String> kette;
  final String text;
  const Begruendung(this.kette, this.text);
}

class Entscheidung {
  final String id;
  final int runde;
  final int nr;
  final String art;
  final String frage;
  final List<EntscheidungsOption> optionen;
  final Map<String, String> richtig;
  final Map<String, Begruendung> begruendung;

  const Entscheidung({
    required this.id,
    required this.runde,
    required this.nr,
    required this.art,
    required this.frage,
    required this.optionen,
    required this.richtig,
    required this.begruendung,
  });

  factory Entscheidung.fromJson(Map j) => Entscheidung(
        id: j['id'] as String,
        runde: j['runde'] as int,
        nr: j['nr'] as int,
        art: j['art'] as String,
        frage: j['frage'] as String,
        optionen: [for (final o in j['optionen'] as List) EntscheidungsOption.fromJson(o as Map)],
        richtig: (j['richtig'] as Map).map((k, v) => MapEntry(k as String, v as String)),
        begruendung: {
          for (final e in (j['begruendung'] as Map).entries)
            e.key as String: Begruendung([for (final k in (e.value as Map)['kette'] as List) k as String], (e.value as Map)['text'] as String),
        },
      );

  EntscheidungsOption option(String id) => optionen.firstWhere((o) => o.id == id);

  /// Begründung für [pfad] (eigene Fassung oder „alle“).
  Begruendung? begruendungFuer(String pfad) => begruendung[pfad] ?? begruendung['alle'];
}

/// Was eine Option in einem Pfad zeigt: einen Fakt oder die harmlose Fassung
/// einer Spur, die dort nicht entsteht.
class Aufdeckung {
  final String fakt;
  final bool entstanden;
  final String text;
  const Aufdeckung(this.fakt, this.entstanden, this.text);
}

/// Regel des Ermittlungsbogens (R-ENTLASTET, R-UEBERFUEHRT).
class Ausschlussregel {
  final String id;
  final List<String> wenn;
  final String folge;
  const Ausschlussregel(this.id, this.wenn, this.folge);
}

/// Entscheidungsmodell eines Partyfalls: Fakten, Entscheidungen, Wertung je
/// Pfad und Restverdächtige (F-06).
class Ermittlung {
  final Kanon kanon;
  final SpurRechner spuren;
  late final Map<String, Fakt> fakten;
  late final List<Entscheidung> entscheidungen;
  late final List<Ausschlussregel> regeln;
  late final Map<String, Map<String, Object?>> _spurJson;
  late final Map<String, Map<String, Object?>> _beobachtungJson;
  final Map<String, Set<String>> _faktPfade = {};

  Ermittlung(this.kanon, {SpurRechner? spuren}) : spuren = spuren ?? SpurRechner(kanon) {
    final j = kanon.entscheidungenJson;
    fakten = {for (final f in (j['fakten'] as List).map((e) => Fakt.fromJson(e as Map))) f.id: f};
    entscheidungen = [for (final e in j['entscheidungen'] as List) Entscheidung.fromJson(e as Map)]
      ..sort((a, b) => a.runde != b.runde ? a.runde.compareTo(b.runde) : a.nr.compareTo(b.nr));
    regeln = [
      for (final r in j['regeln'] as List)
        Ausschlussregel((r as Map)['id'] as String, [for (final w in r['wenn'] as List) w as String], r['folge'] as String),
    ];
    _spurJson = {
      for (final g in kanon.gegenstaende)
        for (final s in (g['spuren'] as List? ?? const [])) (s as Map)['id'] as String: s.cast<String, Object?>(),
    };
    _beobachtungJson = {for (final b in kanon.beobachtungen) b['id'] as String: b};
  }

  List<String> get pfade => kanon.pfade;
  List<String> get kern => kanon.kernverdaechtige;

  Entscheidung entscheidung(String id) => entscheidungen.firstWhere((e) => e.id == id);
  List<Entscheidung> runde(int r) => [for (final e in entscheidungen) if (e.runde == r) e];

  Map<String, Object?>? spurJson(String id) => _spurJson[id];
  Map<String, Object?>? beobachtungJson(String id) => _beobachtungJson[id];

  /// Pfade, in denen es den Fakt gibt.
  Set<String> faktPfade(String faktId) => _faktPfade[faktId] ??= () {
        final f = fakten[faktId]!;
        if (f.beobachtung != null) {
          final pf = _beobachtungJson[f.beobachtung]!['pfade'];
          return {for (final p in pfade) if (Kanon.giltIn(pf, p)) p};
        }
        final s = _spurJson[f.spur]!;
        return {for (final p in pfade) if (spuren.entsteht(s['entstehtWenn'] as Map, p)) p};
      }();

  bool gibtEs(String faktId, String pfad) => faktPfade(faktId).contains(pfad);

  /// Fakten, die [optionId] in [pfad] aufdeckt (nur die, die es dort gibt).
  Set<String> faktenVon(String optionId, String pfad) => {
        for (final f in _option(optionId).fakten)
          if (gibtEs(f, pfad)) f,
      };

  /// Anzeige einer Option in [pfad]: Fakten im Wortlaut der Quelle, sonst die
  /// harmlose Fassung der Spur (gleiche Sätze nur einmal).
  List<Aufdeckung> aufdecken(String optionId, String pfad) {
    final aus = <Aufdeckung>[];
    final gesehen = <String>{};
    for (final fid in _option(optionId).fakten) {
      final f = fakten[fid]!;
      final da = gibtEs(fid, pfad);
      String? text;
      if (da) {
        text = f.beobachtung != null ? _beobachtungJson[f.beobachtung]!['text'] as String : _spurJson[f.spur]!['zeigt'] as String;
      } else if (f.spur != null) {
        text = _spurJson[f.spur]!['harmlos'] as String?;
      }
      if (text != null && gesehen.add(text)) aus.add(Aufdeckung(fid, da, text));
    }
    return aus;
  }

  EntscheidungsOption _option(String id) {
    for (final e in entscheidungen) {
      for (final o in e.optionen) {
        if (o.id == id) return o;
      }
    }
    throw ArgumentError('unbekannte Option $id');
  }

  bool istRichtig(String entscheidungId, String optionId, String pfad) => entscheidung(entscheidungId).richtig[pfad] == optionId;

  /// Bestes Spiel in [pfad]: die richtige Option jeder Entscheidung.
  List<String> bestesSpiel(String pfad) => [for (final e in entscheidungen) e.richtig[pfad]!];

  /// Stand je Kernperson: welche Faktarten zu ihr bekannt sind.
  Map<String, Set<String>> stand(Iterable<String> faktIds) {
    final s = {for (final p in kern) p: <String>{}};
    for (final id in faktIds) {
      final f = fakten[id];
      if (f == null) continue;
      for (final p in f.personen) {
        s[p]?.add(f.typ);
      }
    }
    return s;
  }

  /// Restverdächtige aus den bekannten Fakten, nur nach den Regeln (W-1:
  /// Bonus-Hinweise sind keine Fakten und zählen nicht).
  Set<String> restmenge(Iterable<String> faktIds) {
    final st = stand(faktIds);
    bool erfuellt(Ausschlussregel r, String p) => r.wenn.every((typ) => st[p]!.contains(typ));
    for (final r in regeln.where((r) => r.folge == 'ueberfuehrt')) {
      final ueberfuehrt = [for (final p in kern) if (erfuellt(r, p)) p];
      if (ueberfuehrt.length == 1) return {ueberfuehrt.single};
    }
    final rest = kern.toSet();
    for (final r in regeln.where((r) => r.folge == 'entlastet')) {
      rest.removeWhere((p) => erfuellt(r, p));
    }
    return rest;
  }
}
