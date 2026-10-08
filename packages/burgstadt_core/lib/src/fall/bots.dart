import '../zufall.dart';
import 'fall_daten.dart';
import 'fall_zustand.dart';

/// Entscheidungen der Bots. Die Bots kennen die Lösung (sie sind das System),
/// handeln aber nach ihrer Rolle: Unschuldige teilen offen, die Täterin teilt nur,
/// was sie nicht belastet, und wählt verschwiegene Optionen (Lügenregel K7).
class FallBots {
  final FallZustand z;
  final Zufall zufall;

  /// Teilen an (Vergleichsläufe „ohne Teilen“ für Ebene 4).
  bool teilen;

  FallBots(this.z, {int seed = 1, this.teilen = true}) : zufall = Zufall(seed);

  FallDaten get d => z.daten;

  static const _belastend = {'S-4', 'S-5', 'S-6', 'S-7'};

  /// Würde [rolle] den Hinweis [h] teilen?
  bool teiltBot(String rolle, Hinweis h) {
    if (!teilen) return false;
    if (rolle == FallZustand.taeterin) {
      return h.stuetzt.intersection(_belastend).isEmpty && !h.inhalt.contains('Merle');
    }
    return true;
  }

  /// Teilt alles Neue nach Regel mit [an] (`akte` oder Spieler). Liefert Ereignisse.
  List<Ereignis> teileNeues(String rolle, {String an = 'akte'}) {
    final out = <Ereignis>[];
    for (final h in z.wissen[rolle]!.toList()..sort()) {
      if (z.akte.contains(h) || (an != 'akte' && z.wissen[an]!.contains(h))) continue;
      final hw = d.hinweise[h];
      if (hw == null || !teiltBot(rolle, hw)) continue;
      out.addAll(z.teile(rolle, an, h));
    }
    return out;
  }

  /// Rollen-Entscheidung des Bots (0-basiert).
  int rollenWahl(RollenEntscheidung e) {
    var best = 0, bestWert = -1 << 30;
    for (var i = 0; i < e.optionen.length; i++) {
      final o = e.optionen[i];
      final belastet = o.hinweise.any((h) => (d.hinweise[h]?.stuetzt.intersection(_belastend).isNotEmpty ?? false));
      int wert;
      if (e.rolle == FallZustand.taeterin) {
        wert = (o.oeffentlich ? -2 : 2) - (belastet ? 5 : 0) - o.hinweise.length;
      } else {
        wert = !teilen ? (o.oeffentlich ? -2 : 2) : (o.oeffentlich ? 2 : -2) + o.hinweise.length;
      }
      if (wert > bestWert) {
        bestWert = wert;
        best = i;
      }
    }
    return best;
  }

  /// Detektiv-Entscheidung: echte Spur, wenn ein begründender Hinweis bekannt ist,
  /// sonst geraten.
  String detektivWahl(DetektivEntscheidung e) {
    final bekannt = z.bekannt(FallZustand.detektiv);
    if (e.begruendbar.any(bekannt.contains)) return e.echte;
    return zufall.waehle(const ['A', 'B', 'C']);
  }

  /// Wie viele notwendige Schlussfolgerungen kann [wer] mit seinem Wissen stützen?
  /// Gestützt = mindestens zwei bekannte Hinweise (bzw. alle, falls im Spiel weniger
  /// als zwei vorkommen) – wie die Fairness-Regel in kanon.py (zwei Quellen).
  int gestuetzteSchluesse(String wer) {
    final b = z.bekannt(wer);
    var anzahl = 0;
    for (final s in d.notwendig) {
      final imSpiel = d.schluesse[s]!.where((h) => d.hinweise[h] != null && d.imSpiel(d.hinweise[h]!, z.n)).toSet();
      final soll = imSpiel.length < 2 ? imSpiel.length : 2;
      if (imSpiel.where(b.contains).length >= soll) anzahl++;
    }
    return anzahl;
  }

  bool geloest(String wer) => gestuetzteSchluesse(wer) == d.notwendig.length;

  /// Anklage des Detektiv-Bots aus dem verbleibenden Kreis.
  String anklage() {
    final kreis = z.verdaechtigenkreis;
    final b = z.bekannt(FallZustand.detektiv);
    // Täterin, wenn die belastenden Schlüsse S-5…S-7 gestützt sind
    final gegenMerle = ['S-5', 'S-6', 'S-7'].where((s) => d.schluesse[s]!.any(b.contains)).length;
    if (gegenMerle >= 2 && kreis.contains(FallZustand.taeterin)) return FallZustand.taeterin;
    return zufall.waehle(kreis);
  }
}

/// Ergebnis eines Durchspiels.
class Durchspiel {
  final int n, punkte, schritte;
  final int? geloestBei;
  final String angeklagt, ende;
  final int akte;
  Durchspiel(this.n, this.punkte, this.schritte, this.geloestBei, this.angeklagt, this.ende, this.akte);

  @override
  String toString() =>
      'N=$n · Punkte $punkte · gelöst ${geloestBei == null ? 'nie' : 'nach $geloestBei Schritten'} · angeklagt $angeklagt → $ende · Fallakte $akte';
}

/// Spielt einen Fall headless mit Bots in allen Rollen und einem Detektiv-Bot durch.
/// Ein Schritt = eine Handlung des Detektivs (Station, Zuhören, Gespräch mit einer Rolle).
Durchspiel spieleDurch(FallDaten daten, int n, {int seed = 1, bool teilen = true, int runden = 18}) {
  final z = FallZustand(daten, n)..starte();
  final bots = FallBots(z, seed: seed, teilen: teilen);
  final r = bots.zufall;
  var schritte = 0;
  int? geloestBei;
  const stationen = ['BS-01', 'BS-03', 'BS-05', 'BS-09', 'BS-04', 'Kunibert', 'BS-06', 'BS-08', 'BS-11', 'BS-12', 'BW'];
  for (var p = 1; p <= 3; p++) {
    var si = 0;
    for (var runde = 0; runde < runden && z.abschnitt == Abschnitt.ermittlung; runde++) {
      // Rollen führen je ein offenes Gespräch; der Detektiv hört bei einem zu
      final offene = [for (final rolle in z.rollen) ...z.offeneGespraeche(rolle).take(1)];
      // Der Detektiv kann nicht überall sein: jede zweite Runde hört er einem Gespräch zu,
      // in den anderen untersucht er eine Station.
      final zuhoeren = offene.isEmpty || runde.isOdd ? -1 : r.ganz(offene.length);
      for (var i = 0; i < offene.length; i++) {
        final (g, _, _) = offene[i];
        z.fuehreGespraech(g.von, g.id, zuhoerer: i == zuhoeren ? const [FallZustand.detektiv] : const []);
      }
      if (zuhoeren >= 0) schritte++;
      // Detektiv untersucht eine Station
      if (runde.isOdd && si < stationen.length) {
        z.untersuche(FallZustand.detektiv, stationen[si++]);
        schritte++;
      }
      // Rollen untersuchen ebenfalls Stationen (IF-2) und teilen Neues an die Fallakte
      for (final rolle in z.rollen) {
        if (r.chance(0.35)) z.untersuche(rolle, r.waehle(stationen));
        bots.teileNeues(rolle);
      }
      if (geloestBei == null && bots.geloest(FallZustand.detektiv)) geloestBei = schritte;
      z.zeitVergeht(65 / runden + 0.01);
    }
    if (z.abschnitt == Abschnitt.ermittlung) z.beendeErmittlung();
    for (final e in z.rollenEntscheidungen()) {
      z.waehleRolle(e.id, bots.rollenWahl(e));
    }
    if (geloestBei == null && bots.geloest(FallZustand.detektiv)) geloestBei = schritte;
    z.zurDetektivWahl();
    for (final e in z.detektivEntscheidungen()) {
      z.waehleDetektiv(e.id, bots.detektivWahl(e));
    }
    z.weiter();
  }
  final a = bots.anklage();
  z.klageAn(a);
  return Durchspiel(n, z.punkte, schritte, geloestBei, a, z.ende ?? '-', z.akte.length);
}
