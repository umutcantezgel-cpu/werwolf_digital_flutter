/// Geräusche und Alltagsklänge (Schritte, Türen, Truhe, Rüstung, Papier, Oberfläche).
/// Jede Funktion erzeugt ihr Signal selbst aus festem Seed; die Nachbearbeitung
/// (Ein-/Ausblendung, Normalisierung) übernimmt erzeuge.dart.
library;

import 'dart:math' as math;
import 'dart:typed_data';

import 'klangwerk.dart';

const double _zp = 2 * math.pi;

/// Sinus-Wellentabelle.
final Float64List sinusTabelle = wellenform([1.0]);

/// Sägezahn-artige Tabelle (1/k-Teiltöne) für Knarren, Reibung und Streicher.
final Float64List saegezahnTabelle = wellenform([for (var k = 1; k <= 12; k++) 1.0 / k]);

/// Sinuston mit exponentiellem Abfall (Zeitkonstante [tau] in Sekunden).
Float64List sinusAbfall(double f, double dauer, double tau, {double phase = 0}) {
  final n = sekunden(dauer);
  final out = Float64List(n);
  final w = _zp * f / abtastrate;
  for (var i = 0; i < n; i++) {
    out[i] = math.sin(w * i + phase) * math.exp(-i / (tau * abtastrate));
  }
  return out;
}

/// Anregungsimpuls: weißes Rauschen mit exponentiellem Abfall, n Abtastwerte lang.
Float64List anregungImpuls(Lcg rnd, int n, double tau) {
  final out = Float64List(n);
  for (var i = 0; i < n; i++) {
    out[i] = rnd.naechste() * math.exp(-i / (tau * abtastrate));
  }
  return out;
}

/// Resonanz: Anregung durch ein Bandpass-Filter bei [f] mit Abklingzeit [tau].
Float64List klingt(Float64List anregung, double f, double tau) {
  return filtere(anregung, Zweipol.bandpass(f, math.max(0.5, math.pi * f * tau)));
}

/// Wellentabelle mit wandernder Frequenz f(t) und Hüllkurve h(t) (Phasenakkumulator).
Float64List gleitWelle({
  required Float64List tabelle,
  required double Function(double t) frequenz,
  required double dauer,
  required double Function(double t) huelle,
}) {
  final n = sekunden(dauer);
  final out = Float64List(n);
  final tabLen = tabelle.length - 1;
  var zyklus = 0.0;
  for (var i = 0; i < n; i++) {
    final t = i / abtastrate;
    zyklus += frequenz(t) / abtastrate;
    zyklus -= zyklus.floor();
    final pos = zyklus * tabLen;
    final i0 = pos.floor();
    final teil = pos - i0;
    out[i] = (tabelle[i0] + (tabelle[i0 + 1] - tabelle[i0]) * teil) * huelle(t);
  }
  return out;
}

/// Metallischer Klirr: inharmonische Teiltöne (Verhältnis 1 : 2,76 : 5,4), kurz abklingend.
Float64List klirr(double f0, double dauer, double tau, {double helligkeit = 1.0}) {
  const verhaeltnis = [1.0, 2.76, 5.4];
  const pegel = [1.0, 0.4, 0.2];
  const relTau = [1.0, 0.5, 0.25];
  final out = Float64List(sekunden(dauer));
  for (var k = 0; k < verhaeltnis.length; k++) {
    final f = f0 * verhaeltnis[k];
    if (f > 0.45 * abtastrate) {
      continue;
    }
    mische(out, sinusAbfall(f, dauer, tau * relTau[k]),
        pegel: pegel[k] * (k == 0 ? 1.0 : helligkeit));
  }
  return out;
}

// --- Schritte: vier Untergründe, je vier Varianten (Tonhöhe, Lautheit, Seed) ---

/// Schritt auf Kopfsteinpflaster: Stein-auf-Stein mit drei Resonanzen und hartem Absatz.
Float64List schrittPflaster(int variante) {
  final rnd = Lcg(1000 + variante);
  final s = 1.0 + (variante - 2.5) * 0.06;
  final n = sekunden(0.35);
  final anr = anregungImpuls(rnd, n, 0.004);
  final out = Float64List(n);
  mische(out, klingt(anr, 380 * s, 0.030));
  mische(out, klingt(anr, 690 * s, 0.022), pegel: 0.7);
  mische(out, klingt(anr, 1150 * s, 0.012), pegel: 0.45);
  mische(out, filtere(anregungImpuls(rnd, n, 0.0015), Zweipol.bandpass(1900, 1.2)), pegel: 0.9);
  return out;
}

/// Schritt auf Holzdielen: dumpfer Balken mit zwei Moden und leichter Knack am Absatz.
Float64List schrittHolz(int variante) {
  final rnd = Lcg(2000 + variante);
  final s = 1.0 + (variante - 2.5) * 0.05;
  final n = sekunden(0.45);
  final anr = anregungImpuls(rnd, n, 0.008);
  final out = Float64List(n);
  mische(out, klingt(anr, 190 * s, 0.070));
  mische(out, klingt(anr, 420 * s, 0.040), pegel: 0.6);
  mische(out, filtere(anregungImpuls(rnd, n, 0.0012), Zweipol.bandpass(2400, 2)), pegel: 0.5);
  return out;
}

/// Schritt auf Steinstufen: hart, hell, kurz klingend.
Float64List schrittStein(int variante) {
  final rnd = Lcg(3000 + variante);
  final s = 1.0 + (variante - 2.5) * 0.05;
  final n = sekunden(0.30);
  final anr = anregungImpuls(rnd, n, 0.003);
  final out = Float64List(n);
  mische(out, klingt(anr, 850 * s, 0.012), pegel: 0.8);
  mische(out, klingt(anr, 1550 * s, 0.008), pegel: 0.6);
  mische(out, filtere(anregungImpuls(rnd, n, 0.0008), Zweipol.bandpass(3300, 1.5)), pegel: 1.1);
  return out;
}

/// Schritt im Schnee (Raureif): dicht gestreute Körner, weicher Körper.
Float64List schrittSchnee(int variante) {
  final rnd = Lcg(4000 + variante);
  final s = 1.0 + (variante - 2.5) * 0.05;
  final n = sekunden(0.45);
  final out = Float64List(n);
  for (var k = 0; k < 9; k++) {
    final start = sekunden(rnd.zwischen(0.0, 0.22));
    final korn = anregungImpuls(rnd, sekunden(0.004), 0.0012);
    mische(out, filtere(korn, Zweipol.bandpass(rnd.zwischen(900, 2600) * s, 1.2)),
        versatz: start, pegel: rnd.zwischen(0.3, 0.9));
  }
  mische(out, filtere(anregungImpuls(rnd, n, 0.05), Zweipol.tiefpass(650 * s, 0.7)), pegel: 0.6);
  return out;
}

// --- Türen, Truhe, Rüstung, Schlüssel ---

/// Eichentür öffnet sich: Knarren mit steigender Tonhöhe, Holzdumpf am Anfang, Riegelklick am Ende.
Float64List tuerEicheAuf() {
  final rnd = Lcg(5101);
  final n = sekunden(1.6);
  final out = Float64List(n);
  final knarr = gleitWelle(
    tabelle: saegezahnTabelle,
    frequenz: (t) => 150 + 80 * math.min(1.0, t / 1.2),
    dauer: 1.6,
    huelle: (t) {
      if (t < 0.15) {
        return t / 0.15;
      }
      if (t > 1.2) {
        return math.max(0.0, (1.5 - t) / 0.3);
      }
      return 1.0;
    },
  );
  mische(out, filtere(knarr, Zweipol.bandpass(550, 3)), pegel: 0.5);
  mische(out, filtere(knarr, Zweipol.bandpass(1500, 4)), pegel: 0.35);
  mische(out, filtere(anregungImpuls(rnd, n, 0.02), Zweipol.tiefpass(140, 0.7)), pegel: 1.2);
  mische(out, filtere(anregungImpuls(rnd, sekunden(0.02), 0.0015), Zweipol.bandpass(3000, 2)),
      versatz: sekunden(1.35), pegel: 0.9);
  return out;
}

/// Eichentür fällt ins Schloss: tiefer Körper, Riegelschnappen, kurzes Knarren.
Float64List tuerEicheZu() {
  final rnd = Lcg(5201);
  final n = sekunden(1.3);
  final out = Float64List(n);
  mische(out, sinusAbfall(85, 1.3, 0.05), pegel: 1.0);
  mische(out, filtere(anregungImpuls(rnd, n, 0.03), Zweipol.tiefpass(300, 0.7)), pegel: 0.6);
  mische(out, filtere(anregungImpuls(rnd, sekunden(0.02), 0.0015), Zweipol.bandpass(2500, 2)),
      versatz: sekunden(0.55), pegel: 0.8);
  final knarr = gleitWelle(
    tabelle: saegezahnTabelle,
    frequenz: (t) => 180 - 60 * math.min(1.0, (t - 0.1) / 0.5),
    dauer: 1.3,
    huelle: (t) => (t < 0.1 || t > 0.6) ? 0.0 : math.sin(math.pi * (t - 0.1) / 0.5),
  );
  mische(out, filtere(knarr, Zweipol.bandpass(600, 3)), pegel: 0.12);
  return out;
}

/// Eisentür: metallisches Dröhnen mit inharmonischen Platten-Moden, Schleifen, harter Anschlag.
Float64List tuerEisen() {
  final rnd = Lcg(5301);
  final n = sekunden(1.8);
  final out = Float64List(n);
  mische(out, filtere(anregungImpuls(rnd, sekunden(0.01), 0.004), Zweipol.bandpass(1200, 1.0)),
      pegel: 0.8);
  const verh = [1.0, 2.32, 4.25, 6.63];
  const pegel = [1.0, 0.5, 0.25, 0.12];
  const tauWerte = [0.9, 0.5, 0.3, 0.2];
  for (var k = 0; k < verh.length; k++) {
    mische(out, sinusAbfall(230 * verh[k], 1.8, tauWerte[k]), pegel: 0.5 * pegel[k]);
  }
  final schleif = filtere(rauschen(rnd, n), Zweipol.bandpass(1400, 4));
  for (var i = 0; i < n; i++) {
    final t = i / abtastrate;
    final rattern = 0.5 + 0.5 * math.sin(_zp * (18 + 3 * math.sin(_zp * 0.7 * t)) * t);
    schleif[i] *= 0.4 * rattern * math.exp(-t / 0.5);
  }
  mische(out, schleif);
  return out;
}

/// Holztruhe öffnet sich: Holzknarren, Riegelklirren, hohler Kasten-Nachhall beim Hochklappen.
Float64List truheAuf() {
  final n = sekunden(1.4);
  final out = Float64List(n);
  final knarr = gleitWelle(
    tabelle: saegezahnTabelle,
    frequenz: (t) => 260 + 80 * math.min(1.0, t / 0.6),
    dauer: 1.4,
    huelle: (t) => math.min(1.0, t / 0.1) * math.max(0.0, math.min(1.0, (0.6 - t) / 0.2)),
  );
  mische(out, filtere(knarr, Zweipol.bandpass(700, 3)), pegel: 0.45);
  mische(out, sinusAbfall(1800, 0.2, 0.04), versatz: sekunden(0.05), pegel: 0.6);
  mische(out, sinusAbfall(3100, 0.2, 0.03), versatz: sekunden(0.05), pegel: 0.35);
  final rnd = Lcg(5401);
  final klapp = anregungImpuls(rnd, sekunden(0.8), 0.01);
  mische(out, klingt(klapp, 190, 0.25), versatz: sekunden(0.62), pegel: 0.9);
  return out;
}

/// Rüstung klappert leise: Stoffrascheln und einige kleine metallische Klirrer.
Float64List ruestungKlappern() {
  final rnd = Lcg(5501);
  final n = sekunden(1.5);
  final out = Float64List(n);
  final stoff = filtere(rauschen(rnd, n), Zweipol.tiefpass(900, 0.8));
  for (var i = 0; i < n; i++) {
    stoff[i] *= 0.18 * (0.5 + 0.5 * math.sin(_zp * 3.0 * i / abtastrate));
  }
  mische(out, stoff);
  for (var k = 0; k < 6; k++) {
    final start = sekunden(rnd.zwischen(0.05, 1.15));
    final f0 = rnd.zwischen(1200, 2600);
    final laut = rnd.zwischen(0.4, 0.9);
    mische(out, klirr(f0, 0.25, 0.05, helligkeit: 0.8), versatz: start, pegel: laut);
  }
  return out;
}

/// Schlüsselbund klimpert: viele kurze helle Klirrer, dazwischen feines Schaben.
Float64List schluesselKlimpern() {
  final rnd = Lcg(5601);
  final n = sekunden(1.0);
  final out = Float64List(n);
  for (var k = 0; k < 8; k++) {
    final start = sekunden(rnd.zwischen(0.0, 0.85));
    final f0 = rnd.zwischen(2200, 3800);
    mische(out, klirr(f0, 0.25, 0.03, helligkeit: 0.8), versatz: start, pegel: rnd.zwischen(0.4, 1.0));
    mische(out, filtere(anregungImpuls(rnd, sekunden(0.004), 0.0012), Zweipol.bandpass(4000, 1.5)),
        versatz: start, pegel: 0.3);
  }
  return out;
}

// --- Papier, Ablage, Teilen, Oberfläche des Handys ---

/// Papier raschelt: gefiltertes Rauschen in kurzen Körnern mit wechselnder Lautstärke.
Float64List papierRascheln() {
  final rnd = Lcg(6101);
  final n = sekunden(1.0);
  final out = Float64List(n);
  final rausch = filtere(rauschen(rnd, n), Zweipol.bandpass(4000, 0.9));
  var i = 0;
  while (i < n) {
    final len = sekunden(rnd.zwischen(0.008, 0.025));
    final amp = rnd.zwischen(0.2, 1.0);
    for (var j = 0; j < len && i + j < n; j++) {
      out[i + j] += rausch[i + j] * amp * math.sin(math.pi * j / len);
    }
    i += len;
  }
  mische(out, filtere(rauschen(rnd, n), Zweipol.tiefpass(1100, 0.8)), pegel: 0.3);
  return out;
}

/// Fallakte heften: Papierstapel klatscht, Klammer klickt, kurzes Blättern.
Float64List fallakteHeften() {
  final rnd = Lcg(6201);
  final n = sekunden(0.45);
  final out = Float64List(n);
  mische(out, filtere(anregungImpuls(rnd, sekunden(0.012), 0.004), Zweipol.bandpass(3000, 1.0)),
      pegel: 0.9);
  mische(out, klirr(2600, 0.1, 0.02, helligkeit: 0.8), versatz: sekunden(0.12), pegel: 0.6);
  final blaettern = filtere(rauschen(rnd, n), Zweipol.bandpass(3500, 1.0));
  for (var i = 0; i < n; i++) {
    final t = (i / abtastrate - 0.14) / 0.25;
    final huelle = (t > 0 && t < 1) ? math.sin(math.pi * t) : 0.0;
    blaettern[i] *= 0.35 * huelle;
  }
  mische(out, blaettern);
  return out;
}

/// Teilen oder Senden: Wisch mit wandernder Mittenfrequenz, dazu zwei kurze Pings.
Float64List teilenSenden() {
  final rnd = Lcg(6301);
  final n = sekunden(0.5);
  final out = Float64List(n);
  final rausch = rauschen(rnd, n);
  final baender = [
    filtere(rausch, Zweipol.bandpass(900, 2.5)),
    filtere(rausch, Zweipol.bandpass(1800, 2.5)),
    filtere(rausch, Zweipol.bandpass(3000, 2.5)),
  ];
  for (var i = 0; i < n; i++) {
    final t = i / abtastrate;
    final lage = math.min(1.0, t / 0.3) * 2;
    final huelle = math.min(1.0, t / 0.01) * math.exp(-t / 0.25);
    for (var k = 0; k < 3; k++) {
      final abstand = lage - k;
      out[i] += baender[k][i] * math.exp(-2.0 * abstand * abstand) * 0.6 * huelle;
    }
  }
  mische(out, sinusAbfall(1046, 0.5, 0.05), versatz: sekunden(0.22), pegel: 0.5);
  mische(out, sinusAbfall(1568, 0.5, 0.07), versatz: sekunden(0.30), pegel: 0.45);
  return out;
}

/// Kurzer UI-Klick.
Float64List uiKlick() {
  final rnd = Lcg(6401);
  final n = sekunden(0.05);
  final out = sinusAbfall(1800, 0.05, 0.006);
  mische(out, filtere(anregungImpuls(rnd, n, 0.0012), Zweipol.bandpass(3500, 1.5)), pegel: 0.4);
  return out;
}

/// Zurück-Ton: fallender Doppelton.
Float64List uiZurueck() {
  return gleitWelle(
    tabelle: sinusTabelle,
    frequenz: (t) => 820 - 200 * (t / 0.16),
    dauer: 0.16,
    huelle: (t) => math.exp(-t / 0.07),
  );
}

/// Detektivblick an: steigendes Schimmern mit Tremolo, Luftrauschen und Hall.
Float64List detektivblickAn() {
  final rnd = Lcg(6501);
  final n = sekunden(0.6);
  final out = gleitWelle(
    tabelle: sinusTabelle,
    frequenz: (t) => 400 * math.pow(3, math.min(1.0, t / 0.5)).toDouble(),
    dauer: 0.6,
    huelle: (t) => math.min(1.0, t / 0.25) * (0.7 + 0.3 * math.sin(_zp * 12 * t)),
  );
  final luft = filtere(rauschen(rnd, n), Zweipol.bandpass(4000, 1.0));
  mische(out, luft, pegel: 0.05);
  return hall(out, nachhall: 0.6, anteil: 0.3);
}

/// Detektivblick aus: fallendes Schimmern, schnell verklingend, mit Hall.
Float64List detektivblickAus() {
  final out = gleitWelle(
    tabelle: sinusTabelle,
    frequenz: (t) => 1200 * math.pow(380 / 1200, t / 0.45).toDouble(),
    dauer: 0.45,
    huelle: (t) => math.exp(-t / 0.18),
  );
  return hall(out, nachhall: 0.6, anteil: 0.3);
}

/// Schreck: kurzer Streicher-Stich mit kleiner Reibung (Sekunde gegen Prim), Anstieg und Tremolo.
Float64List schreck() {
  final n = sekunden(0.9);
  final out = Float64List(n);
  for (final f0 in [220.0, 233.08, 329.63]) {
    final stimme = gleitWelle(
      tabelle: saegezahnTabelle,
      frequenz: (t) => f0 * (1.0 + 0.06 * math.exp(-t / 0.03)),
      dauer: 0.9,
      huelle: (t) =>
          math.min(1.0, t / 0.012) * math.exp(-t / 0.3) * (0.75 + 0.25 * math.sin(_zp * 9 * t)),
    );
    mische(out, stimme, pegel: 0.3);
  }
  return filtere(out, Zweipol.tiefpass(3200, 0.7));
}

/// Handylicht an/aus: Mechanik-Klick mit kleinem Kontaktton.
Float64List handylichtKlick() {
  final rnd = Lcg(6601);
  final n = sekunden(0.12);
  final out = filtere(anregungImpuls(rnd, n, 0.0015), Zweipol.bandpass(3500, 2));
  mische(out, filtere(anregungImpuls(rnd, n, 0.004), Zweipol.tiefpass(400, 0.7)), pegel: 0.8);
  mische(out, sinusAbfall(2800, 0.12, 0.008), versatz: sekunden(0.01), pegel: 0.25);
  return out;
}
