/// Umgebungsklänge und Tierrufe: Wind, Nebel, Kaminglut, Kessel, Uhrturm, Hund, Eule, Fledermäuse, Hinweis.
/// Schleifen sind periodisch über ihre Länge gebaut (Frequenzen als ganze Vielfache von 1/Länge),
/// damit das Schleifenende ohne Sprung in den Anfang übergeht.
library;

import 'dart:math' as math;
import 'dart:typed_data';

import 'geraeusche.dart';
import 'klangwerk.dart';

const double _zp = 2 * math.pi;

/// Sinusschwingung mit ganzzahligem Zyklus pro Schleifenlänge (periodisch).
double _lfo(double t, double dauer, int zyklen, double phase) =>
    math.sin(_zp * zyklen * t / dauer + phase);

/// Wind: bandpassgefiltertes, langsam moduliertes Rauschen (20 s, periodisch).
Float64List windSchleife() {
  const dauer = 20.0;
  final n = sekunden(dauer);
  final rnd = Lcg(7101);
  final rausch = rauschen(rnd, n);
  final koerper = kreisFiltere(kreisFiltere(rausch, Zweipol.bandpass(520, 0.7)), Zweipol.tiefpass(900, 0.7));
  final boeen = kreisFiltere(rausch, Zweipol.bandpass(1300, 2.0));
  final out = Float64List(n);
  for (var i = 0; i < n; i++) {
    final t = i / abtastrate;
    final huelle = 0.55 +
        0.25 * _lfo(t, dauer, 1, 1.1) +
        0.12 * _lfo(t, dauer, 2, 2.3) +
        0.08 * _lfo(t, dauer, 3, 0.4) +
        0.06 * _lfo(t, dauer, 5, 0.9);
    final boenHuelle = 0.5 + 0.5 * _lfo(t, dauer, 2, 1.7);
    out[i] = koerper[i] * huelle + boeen[i] * 0.3 * boenHuelle;
  }
  return out;
}

/// Nebel brummt: tiefe, sehr ruhige Fläche aus Grundton, Schwebung und dunklem Rauschen (20 s, periodisch).
Float64List nebelBrummenSchleife() {
  const dauer = 20.0;
  final n = sekunden(dauer);
  final rnd = Lcg(7201);
  final out = Float64List(n);
  final brumm = <(double, double)>[(41.0, 1.0), (41.5, 0.8), (62.0, 0.45), (83.0, 0.2)];
  for (final (f, a) in brumm) {
    mische(out, sinusAbfall(f, dauer, 1e6), pegel: 0.25 * a);
  }
  final dunkel = kreisFiltere(rauschen(rnd, n), Zweipol.tiefpass(110, 0.7));
  for (var i = 0; i < n; i++) {
    final t = i / abtastrate;
    out[i] = out[i] * (0.8 + 0.2 * _lfo(t, dauer, 1, 0.2)) + dunkel[i] * 0.4;
  }
  return out;
}

/// Kaminglut knistert: dunkles Glühen mit zufälligen Knacksern (6 s, periodisch).
Float64List kaminGlutSchleife() {
  const dauer = 6.0;
  final n = sekunden(dauer);
  final rnd = Lcg(7301);
  final out = Float64List(n);
  final rumpel = kreisFiltere(rauschen(rnd, n), Zweipol.tiefpass(160, 0.7));
  for (var i = 0; i < n; i++) {
    final t = i / abtastrate;
    out[i] = rumpel[i] * 0.25 * (0.6 + 0.4 * _lfo(t, dauer, 1, 0.5));
  }
  for (var k = 0; k < 90; k++) {
    final start = sekunden(rnd.zwischen(0.0, dauer));
    final impuls = anregungImpuls(rnd, sekunden(0.012), 0.0015);
    mische(out, filtere(impuls, Zweipol.bandpass(rnd.zwischen(1200, 4200), 1.5)),
        versatz: start, pegel: rnd.zwischen(0.2, 1.0), kreis: true);
  }
  return out;
}

/// Ein einzelnes Blubbern: steigender Ton mit schnellem Abfall.
Float64List _blase(Lcg rnd) {
  const dauer = 0.035;
  final len = sekunden(dauer);
  final f0 = rnd.zwischen(300, 650);
  final out = Float64List(len);
  var phase = 0.0;
  for (var i = 0; i < len; i++) {
    final t = i / abtastrate;
    phase += f0 * (1 + 1.5 * t / dauer) / abtastrate;
    out[i] = math.sin(_zp * phase) * math.exp(-t / 0.010);
  }
  return out;
}

/// Kessel brodelt: dichtes Blubbern über einem warmen Sieden (6 s, periodisch).
Float64List kesselBrodelnSchleife() {
  const dauer = 6.0;
  final n = sekunden(dauer);
  final rnd = Lcg(7401);
  final out = Float64List(n);
  final sieden = kreisFiltere(rauschen(rnd, n), Zweipol.tiefpass(380, 0.6));
  for (var i = 0; i < n; i++) {
    final t = i / abtastrate;
    out[i] = sieden[i] * 0.18 * (0.7 + 0.3 * _lfo(t, dauer, 1, 0.8));
  }
  for (var k = 0; k < 70; k++) {
    final start = sekunden(rnd.zwischen(0.0, dauer));
    mische(out, _blase(rnd), versatz: start, pegel: rnd.zwischen(0.25, 0.8), kreis: true);
  }
  return out;
}

/// Uhrturm schlägt die volle Stunde: tiefe Bronzeglocke, 4 s Ausklang.
Float64List uhrturmSchlag() {
  return glocke(
    grundton: 98.0,
    dauer: 4.5,
    ausklang: 4.0,
    rnd: Lcg(8101),
    helligkeit: 0.9,
    anschlag: 0.25,
  );
}

/// Uhrturm-Viertelschlag: zwei hellere Töne (Quinte abwärts) im Abstand von 0,9 s.
Float64List uhrturmViertel() {
  final out = Float64List(sekunden(2.7));
  mische(out,
      glocke(grundton: 587.33, dauer: 1.8, ausklang: 1.6, rnd: Lcg(8201), helligkeit: 1.5, anschlag: 0.2));
  mische(out,
      glocke(grundton: 440.0, dauer: 1.8, ausklang: 1.6, rnd: Lcg(8202), helligkeit: 1.5, anschlag: 0.2),
      versatz: sekunden(0.9));
  return out;
}

/// Hund in der Ferne: zwei gedämpfte Kläffer, tiefpassgefiltert und mit Hall.
Float64List hundFern() {
  final n = sekunden(1.8);
  final quelle = Float64List(n);
  for (final start in [0.10, 0.85]) {
    final bell = gleitWelle(
      tabelle: saegezahnTabelle,
      frequenz: (t) => 280 - 80 * math.min(1.0, t / 0.2),
      dauer: 0.35,
      huelle: (t) => math.min(1.0, t / 0.012) * math.exp(-t / 0.07),
    );
    final geformt = Float64List(bell.length);
    mische(geformt, filtere(bell, Zweipol.bandpass(700, 3)));
    mische(geformt, filtere(bell, Zweipol.bandpass(1500, 4)), pegel: 0.5);
    mische(quelle, geformt, versatz: sekunden(start));
  }
  return hall(filtere(quelle, Zweipol.tiefpass(2200, 0.7)), nachhall: 1.2, anteil: 0.35);
}

/// Eule ruft zweimal: weicher Ton mit leicht fallender Tonhöhe.
Float64List eule() {
  final out = Float64List(sekunden(1.7));
  mische(
    out,
    gleitWelle(
      tabelle: sinusTabelle,
      frequenz: (t) => 430 - 60 * math.min(1.0, t / 0.6),
      dauer: 0.6,
      huelle: (t) {
        final an = math.min(1.0, t / 0.12);
        return t > 0.4 ? an * math.max(0.0, (0.6 - t) / 0.2) : an;
      },
    ),
    pegel: 0.8,
  );
  mische(
    out,
    gleitWelle(
      tabelle: sinusTabelle,
      frequenz: (t) => 400 - 60 * math.min(1.0, t / 0.45),
      dauer: 0.45,
      huelle: (t) {
        final an = math.min(1.0, t / 0.1);
        return t > 0.25 ? an * math.max(0.0, (0.45 - t) / 0.2) : an;
      },
    ),
    versatz: sekunden(0.95),
    pegel: 0.6,
  );
  return out;
}

/// Fledermäuse flattern: Rauschen mit Flügelschlag-Hüllkurve und kurze Ultraschall-Chirps.
Float64List fledermausFlattern() {
  final n = sekunden(1.2);
  final rnd = Lcg(8401);
  final out = Float64List(n);
  final rausch = filtere(rauschen(rnd, n), Zweipol.bandpass(3800, 1.2));
  for (var i = 0; i < n; i++) {
    final t = i / abtastrate;
    final schlag = math.sin(_zp * 14 * t).abs();
    out[i] = rausch[i] * schlag * schlag * 0.9 * math.exp(-t / 1.0);
  }
  for (var k = 0; k < 4; k++) {
    final start = sekunden(rnd.zwischen(0.1, 1.0));
    mische(out, _chirp(7000, 3500, 0.022), versatz: start, pegel: 0.4);
  }
  return out;
}

/// Fallender Chirp zwischen zwei Frequenzen.
Float64List _chirp(double von, double bis, double dauer) {
  final out = Float64List(sekunden(dauer));
  var phase = 0.0;
  for (var i = 0; i < out.length; i++) {
    final t = i / abtastrate;
    phase += (von + (bis - von) * t / dauer) / abtastrate;
    out[i] = math.sin(_zp * phase) * math.exp(-t / (dauer * 0.5));
  }
  return out;
}

/// Hinweis gefunden: kurzes, warmes Glöckchen-Arpeggio (D5, F5, A5, D6).
Float64List hinweisGefunden() {
  final out = Float64List(sekunden(1.6));
  const tonhoehen = [587.33, 698.46, 880.0, 1174.66];
  for (var k = 0; k < tonhoehen.length; k++) {
    mische(
      out,
      glocke(
        grundton: tonhoehen[k],
        dauer: 1.2,
        ausklang: 0.9,
        rnd: Lcg(8501 + k),
        helligkeit: 0.45,
        anschlag: 0.1,
      ),
      versatz: sekunden(0.11 * k),
      pegel: 0.8,
    );
  }
  return out;
}
