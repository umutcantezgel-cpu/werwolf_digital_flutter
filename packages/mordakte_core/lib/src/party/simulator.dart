import 'enden.dart';
import 'entscheidungen.dart';
import 'erzaehler.dart';
import 'gruppenwahl.dart';
import 'kanon/kanon.dart';

/// Ergebnis einer Optionsfolge in einem Pfad.
class Verlauf {
  final List<String> optionen;
  final int punkte;
  final List<int> richtigJeRunde;
  final List<Set<String>> restNachRunde;
  final Set<String> fakten;
  const Verlauf(this.optionen, this.punkte, this.richtigJeRunde, this.restNachRunde, this.fakten);
  Set<String> get rest => restNachRunde.last;
}

/// Auszählung eines Pfads über alle Optionsfolgen und Anklagen.
class PfadBericht {
  final String pfad;
  final Map<String, int> enden = {};
  final Map<int, int> punkte = {};
  final Map<int, int> restGroesse = {};
  int spiele = 0;
  int rateEnden = 0;
  int rateTreffer = 0;
  int kuerzerAlsBest = 0;
  PfadBericht(this.pfad);
}

/// Erschöpfender Simulator (F-06, F-07): alle Pfade × alle Optionsfolgen ×
/// alle Anklagen; Gruppenergebnisse ändern die Restmenge nie (W-1) und
/// werden über alle 27 Folgen je Pfad geprüft.
class Simulator {
  final Kanon kanon;
  final Ermittlung ermittlung;
  final Enden enden;
  final Gruppenwahl gruppe;

  Simulator(this.kanon, {Ermittlung? ermittlung})
      : ermittlung = ermittlung ?? Ermittlung(kanon),
        enden = Enden(kanon),
        gruppe = Gruppenwahl(kanon);

  List<Entscheidung> get _e => ermittlung.entscheidungen;

  /// Alle Optionsfolgen (eine Option je Entscheidung, in Kanon-Reihenfolge).
  Iterable<List<String>> folgen() sync* {
    final e = _e;
    final idx = List.filled(e.length, 0);
    while (true) {
      yield [for (var i = 0; i < e.length; i++) e[i].optionen[idx[i]].id];
      var i = e.length - 1;
      while (i >= 0) {
        idx[i]++;
        if (idx[i] < e[i].optionen.length) break;
        idx[i] = 0;
        i--;
      }
      if (i < 0) return;
    }
  }

  Verlauf verlauf(String pfad, List<String> optionen) {
    final fakten = <String>{};
    final rest = <Set<String>>[];
    final richtig = [0, 0, 0];
    var punkte = 0;
    for (var r = 1; r <= 3; r++) {
      for (var i = 0; i < _e.length; i++) {
        if (_e[i].runde != r) continue;
        fakten.addAll(ermittlung.faktenVon(optionen[i], pfad));
        if (_e[i].richtig[pfad] == optionen[i]) {
          punkte++;
          richtig[r - 1]++;
        }
      }
      rest.add(ermittlung.restmenge(fakten));
    }
    return Verlauf(optionen, punkte, richtig, rest, fakten);
  }

  Map<String, PfadBericht> auszaehlen() {
    final out = <String, PfadBericht>{};
    for (final p in kanon.pfade) {
      final b = out[p] = PfadBericht(p);
      for (final f in folgen()) {
        final v = verlauf(p, f);
        b.punkte[v.punkte] = (b.punkte[v.punkte] ?? 0) + 1;
        b.restGroesse[v.rest.length] = (b.restGroesse[v.rest.length] ?? 0) + 1;
        if (v.rest.length == 1 && v.punkte < 9) b.kuerzerAlsBest++;
        for (final a in kanon.kernverdaechtige) {
          b.spiele++;
          final e = enden.ende(v.punkte, a == p);
          b.enden[e.id] = (b.enden[e.id] ?? 0) + 1;
          if (!v.rest.contains(a)) b.rateEnden++;
          if (a == p && v.rest.length > 1) b.rateTreffer++;
        }
      }
    }
    return out;
  }

  /// Alle Verstöße gegen F-06, F-07 und F-08 (Struktur). Leer heißt grün.
  List<String> pruefe() {
    final f = <String>[];
    final kern = kanon.kernverdaechtige;
    final ndTypen = {for (final p in kern) p: false};

    for (final p in kanon.pfade) {
      // Bestes Spiel.
      final best = ermittlung.bestesSpiel(p);
      final vb = verlauf(p, best);
      if (vb.punkte != 9) f.add('Pfad $p: bestes Spiel hat ${vb.punkte} Punkte');
      if (vb.restNachRunde[1].length != 2) f.add('Pfad $p: nach Runde 2 mit 6 richtigen ${vb.restNachRunde[1]} statt genau 2');
      if (vb.rest.length != 1 || !vb.rest.contains(p)) f.add('Pfad $p: bestes Spiel endet mit ${vb.rest}');
      final st = ermittlung.stand(vb.fakten);
      for (final q in kern) {
        if (!st[q]!.contains('nebendelikt')) f.add('Pfad $p: bestes Spiel deckt das Nebendelikt von $q nicht auf');
        ndTypen[q] = true;
      }

      // Jede richtige Option zeigt etwas, das es gibt, und erweitert den Stand;
      // keine falsche Option hilft mehr als die richtige (im Kontext des besten Spiels).
      final vorher = <String>{};
      for (var i = 0; i < _e.length; i++) {
        final e = _e[i];
        final r = e.richtig[p]!;
        final neu = ermittlung.faktenVon(r, p);
        if (neu.isEmpty) f.add('Pfad $p, ${e.id}: richtige Option $r deckt nichts auf');
        final stVor = ermittlung.stand(vorher);
        final stNach = ermittlung.stand({...vorher, ...neu});
        final gewinn = kern.any((q) => stNach[q]!.length > stVor[q]!.length);
        if (!gewinn) f.add('Pfad $p, ${e.id}: richtige Option $r ändert den Stand nicht');
        // Eine falsche Option darf nur dann mehr ausschließen, wenn die richtige
        // ein Indiz gegen die Täterperson liefert (E-024, Nachtrag).
        final restRichtig = ermittlung.restmenge({...vorher, ...neu}).length;
        final gegenTaeter = neu.any((id) {
          final x = ermittlung.fakten[id]!;
          return x.personen.contains(p) && Erzaehler.belastend.contains(x.typ);
        });
        for (final o in e.optionen) {
          if (o.id == r) continue;
          final restFalsch = ermittlung.restmenge({...vorher, ...ermittlung.faktenVon(o.id, p)}).length;
          if (restFalsch < restRichtig && !gegenTaeter) f.add('Pfad $p, ${e.id}: falsche Option ${o.id} schließt mehr aus als die richtige');
        }
        vorher.addAll(neu);
      }

      // D-1: Optionen mit 0 Punkten zeigen weder Schlüsselbeweis noch Zusatzindiz.
      for (final e in _e) {
        for (final o in e.optionen) {
          if (o.id == e.richtig[p]) continue;
          for (final id in ermittlung.faktenVon(o.id, p)) {
            final t = ermittlung.fakten[id]!.typ;
            if (t == 'schluesselbeweis' || t == 'zusatzindiz') f.add('Pfad $p: falsche Option ${o.id} zeigt $t ($id)');
          }
        }
      }

      // Erschöpfend: 0 richtige → mindestens 2 Restverdächtige; jedes Ende erreichbar.
      final endenErreicht = <String>{};
      for (final folge in folgen()) {
        final v = verlauf(p, folge);
        if (v.punkte == 0 && v.rest.length < 2) f.add('Pfad $p: 0 richtige, aber Restmenge ${v.rest}');
        if (v.richtigJeRunde[0] == 3 && v.richtigJeRunde[1] == 3 && v.restNachRunde[1].length != 2) {
          f.add('Pfad $p: Runde 1 und 2 richtig, aber nach Runde 2 ${v.restNachRunde[1]}');
        }
        if (!v.rest.contains(p)) f.add('Pfad $p: Täterperson scheidet aus (${folge.join(',')})');
        // W-1 scharf: Hinweise sind keine Fakten und ändern die Restmenge nie.
        final mitHinweisen = {...v.fakten, for (final h in gruppe.hinweise) h['id'] as String};
        if (ermittlung.restmenge(mitHinweisen).length != v.rest.length) f.add('Pfad $p: Hinweise ändern die Restmenge');
        for (final a in kern) {
          endenErreicht.add(enden.ende(v.punkte, a == p).id);
        }
      }
      for (final e in enden.regeln) {
        if (!endenErreicht.contains(e.id)) f.add('Pfad $p: Ende ${e.id} nicht erreichbar');
      }

      // Bonus: je Runde und Qualität genau ein Hinweis; falsche Fährten belasten
      // Unschuldige und werden durch eine im Pfad richtige Entscheidung widerlegt.
      for (var r = 1; r <= 3; r++) {
        for (final q in Qualitaet.values) {
          final hs = [for (final h in gruppe.hinweise) if (h['pfad'] == p && h['runde'] == r && h['qualitaet'] == q.name) h];
          if (hs.length != 1) {
            f.add('Pfad $p, Runde $r, $q: ${hs.length} Hinweise');
            continue;
          }
          final h = hs.single;
          final w = h['wirkung'] as Map;
          if (q == Qualitaet.falsch) {
            if (w['art'] != 'belastet' || w['person'] == p || !kern.contains(w['person'])) f.add('${h['id']}: falsche Fährte belastet keinen Unschuldigen');
            final wd = [for (final o in (h['widerlegtDurch'] as List? ?? const [])) o as String];
            if (!wd.any((o) => best.contains(o))) f.add('${h['id']}: keine im Pfad richtige Entscheidung widerlegt es');
          } else {
            if ((h['widerlegtDurch'] as List?)?.isNotEmpty == true) f.add('${h['id']}: wahrer oder neutraler Hinweis mit widerlegtDurch');
            if (q == Qualitaet.wahr && w['art'] == 'belastet' && w['person'] != p) f.add('${h['id']}: wahrer Hinweis belastet einen Unschuldigen');
            if (q == Qualitaet.wahr && w['art'] == 'entlastet' && w['person'] == p) f.add('${h['id']}: wahrer Hinweis entlastet die Täterperson');
            if (q == Qualitaet.neutral && w['art'] != 'neutral') f.add('${h['id']}: neutraler Hinweis mit Wirkung');
          }
        }
      }
    }
    for (final e in ndTypen.entries) {
      if (!e.value) f.add('Nebendelikt von ${e.key} nie geprüft');
    }
    f.addAll(pruefeBegruendungen());
    return f;
  }

  /// Begründungsketten (Master 7.7): Jede Kette nutzt nur, was der Detektiv bei
  /// bestem Spiel vorher wissen kann.
  List<String> pruefeBegruendungen() {
    final f = <String>[];
    final sichtbar = {for (final g in kanon.gegenstaende) if (g['sichtbar'] == true) g['id'] as String};
    final figuren = {for (final x in kanon.figuren) x['id'] as String};
    for (final p in kanon.pfade) {
      for (final e in _e) {
        final b = e.begruendungFuer(p);
        if (b == null) {
          f.add('${e.id}: keine Begründung für Pfad $p');
          continue;
        }
        final vorher = <String>{
          for (final x in _e)
            if (x.runde < e.runde) ...ermittlung.faktenVon(x.richtig[p]!, p),
        };
        for (final k in b.kette) {
          final teile = k.split(':');
          final art = teile[0], id = teile[1];
          switch (art) {
            case 'fakt':
              if (!vorher.contains(id)) f.add('${e.id}, Pfad $p: $id ist vor Runde ${e.runde} nicht bekannt');
            case 'beobachtung':
              final bj = ermittlung.beobachtungJson(id);
              if (bj == null) {
                f.add('${e.id}: unbekannte Beobachtung $id');
              } else if (bj['kanal'] == 'verborgen') {
                f.add('${e.id}: Beobachtung $id ist verborgen');
              } else if (!Kanon.giltIn(bj['pfade'], p)) {
                f.add('${e.id}: Beobachtung $id gilt nicht in Pfad $p');
              }
            case 'karte':
              if (!sichtbar.contains(id)) f.add('${e.id}: $id ist nicht auf der Karte');
            case 'merkmal':
              if (!figuren.contains(id)) f.add('${e.id}: Figur $id unbekannt');
            default:
              f.add('${e.id}: unbekannte Kettenart $art');
          }
        }
      }
    }
    return f;
  }

  /// F-08: Jede Qualität ist für jede Personenzahl über eine Stimmverteilung
  /// erreichbar; Sabotage zählt netto −1 (G-1).
  List<String> pruefeSchwellen() {
    final f = <String>[];
    for (var n = 4; n <= 20; n++) {
      final erreicht = <Qualitaet>{};
      for (var k = 0; k <= n - 1; k++) {
        for (final sab in [false, true]) {
          erreicht.add(gruppe.auswerten(rollen: n, kooperativ: k, taeterSabotiert: sab));
        }
        // Sabotage gegenüber kooperativer Täterstimme: zwei Stimmen weniger (0 statt +1, dazu −1).
        final mit = Gruppenwahl.wirksam(kooperativ: k, sabotage: true);
        final ohne = Gruppenwahl.wirksam(kooperativ: k + 1, sabotage: false);
        if (k >= 1 && ohne - mit != 2) f.add('$n Rollen, $k kooperativ: Sabotage wirkt ${ohne - mit} statt 2');
      }
      for (final q in Qualitaet.values) {
        if (!erreicht.contains(q)) f.add('$n Rollen: $q nicht erreichbar');
      }
    }
    return f;
  }
}
