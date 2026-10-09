/// Synthese-Bausteine für alle Klänge von „Burgstadt Schartenfels“ (Auftrag A-603a).
///
/// Alles ist eigene Berechnung: Teiltonsummen für Glocken, Karplus-Strong für
/// gezupfte Saiten, Wellentabellen für Streicher und Holzbläser, Rauschen aus
/// einem deterministischen LCG, Zweipol-Filter nach RBJ-Formeln, Schroeder-Hall.
/// Keine Samples, keine fremden Klänge.
library;

import 'dart:math' as math;
import 'dart:typed_data';

/// Abtastrate aller Dateien.
const int abtastrate = 22050;

const double _zwoPi = 2 * math.pi;

/// Anzahl Abtastwerte für eine Dauer in Sekunden.
int sekunden(double s) => (s * abtastrate).round();

/// Deterministischer Zufallsgenerator (lineare Kongruenz mit festem Seed).
class Lcg {
  Lcg(int seed) : _zustand = seed & 0xFFFFFFFF;

  int _zustand;

  /// Gleichverteilt in [-1, 1).
  double naechste() {
    _zustand = (_zustand * 1664525 + 1013904223) & 0xFFFFFFFF;
    return _zustand / 2147483648.0 - 1.0;
  }

  /// Gleichverteilt in [a, b).
  double zwischen(double a, double b) => a + (naechste() + 1.0) * 0.5 * (b - a);
}

/// Weißes Rauschen mit n Abtastwerten.
Float64List rauschen(Lcg rnd, int n) {
  final out = Float64List(n);
  for (var i = 0; i < n; i++) {
    out[i] = rnd.naechste();
  }
  return out;
}

/// Addiert [quelle] in [ziel] ab [versatz]. Mit [kreis] umläuft die Schleife das Ziel (für Schleifen).
void mische(
  Float64List ziel,
  Float64List quelle, {
  int versatz = 0,
  double pegel = 1.0,
  bool kreis = false,
}) {
  final n = ziel.length;
  for (var i = 0; i < quelle.length; i++) {
    var j = versatz + i;
    if (kreis) {
      j %= n;
    } else if (j < 0 || j >= n) {
      continue;
    }
    ziel[j] += quelle[i] * pegel;
  }
}

/// Zweipol-Filter (Direct Form I) nach den RBJ-Formeln.
class Zweipol {
  Zweipol._(this._b0, this._b1, this._b2, this._a1, this._a2);

  /// Bandpass mit Spitzenverstärkung 1 bei [f0].
  factory Zweipol.bandpass(double f0, double guete) {
    final w = _zwoPi * f0 / abtastrate;
    final alpha = math.sin(w) / (2 * guete);
    final a0 = 1 + alpha;
    return Zweipol._(alpha / a0, 0, -alpha / a0, -2 * math.cos(w) / a0, (1 - alpha) / a0);
  }

  /// Tiefpass bei [f0].
  factory Zweipol.tiefpass(double f0, double guete) {
    final w = _zwoPi * f0 / abtastrate;
    final cw = math.cos(w);
    final alpha = math.sin(w) / (2 * guete);
    final a0 = 1 + alpha;
    final b1 = (1 - cw) / a0;
    return Zweipol._(b1 / 2, b1, b1 / 2, -2 * cw / a0, (1 - alpha) / a0);
  }

  /// Hochpass bei [f0].
  factory Zweipol.hochpass(double f0, double guete) {
    final w = _zwoPi * f0 / abtastrate;
    final cw = math.cos(w);
    final alpha = math.sin(w) / (2 * guete);
    final a0 = 1 + alpha;
    final b1 = -(1 + cw) / a0;
    return Zweipol._(-b1 / 2, b1, -b1 / 2, -2 * cw / a0, (1 - alpha) / a0);
  }

  final double _b0;
  final double _b1;
  final double _b2;
  final double _a1;
  final double _a2;
  double _x1 = 0;
  double _x2 = 0;
  double _y1 = 0;
  double _y2 = 0;

  double verarbeite(double x) {
    final y = _b0 * x + _b1 * _x1 + _b2 * _x2 - _a1 * _y1 - _a2 * _y2;
    _x2 = _x1;
    _x1 = x;
    _y2 = _y1;
    _y1 = y;
    return y;
  }

  void ruecksetzen() {
    _x1 = 0;
    _x2 = 0;
    _y1 = 0;
    _y2 = 0;
  }
}

/// Filtert ein Signal einmal von vorn nach hinten.
Float64List filtere(Float64List x, Zweipol f) {
  final y = Float64List(x.length);
  for (var i = 0; i < x.length; i++) {
    y[i] = f.verarbeite(x[i]);
  }
  return y;
}

/// Filtert umlaufend: ein Einschwingdurchlauf, danach das Ergebnis des zweiten Durchlaufs.
/// Ergibt für Schleifen eine periodische Fortsetzung ohne Sprung am Schleifenende.
Float64List kreisFiltere(Float64List x, Zweipol f) {
  f.ruecksetzen();
  for (var i = 0; i < x.length; i++) {
    f.verarbeite(x[i]);
  }
  return filtere(x, f);
}

/// Kosinus-Einblendung über [sekundenLaenge] am Anfang.
void einblenden(Float64List x, double sekundenLaenge) {
  final n = math.min(x.length, sekunden(sekundenLaenge));
  for (var i = 0; i < n; i++) {
    x[i] *= 0.5 - 0.5 * math.cos(math.pi * i / n);
  }
}

/// Kosinus-Ausblendung über [sekundenLaenge] am Ende.
void ausblenden(Float64List x, double sekundenLaenge) {
  final n = math.min(x.length, sekunden(sekundenLaenge));
  final start = x.length - n;
  for (var i = 0; i < n; i++) {
    x[start + i] *= 0.5 + 0.5 * math.cos(math.pi * i / n);
  }
}

/// Entfernt den Gleichanteil (Mittelwert wird zu null).
void gleichanteilEntfernen(Float64List x) {
  var summe = 0.0;
  for (final v in x) {
    summe += v;
  }
  final mittel = summe / x.length;
  for (var i = 0; i < x.length; i++) {
    x[i] -= mittel;
  }
}

/// Skaliert die Spitze auf [dbfs] (Standard −1 dBFS).
void normalisiere(Float64List x, {double dbfs = -1.0}) {
  var spitze = 0.0;
  for (final v in x) {
    spitze = math.max(spitze, v.abs());
  }
  if (spitze == 0) {
    return;
  }
  final ziel = math.pow(10, dbfs / 20).toDouble();
  final faktor = ziel / spitze;
  for (var i = 0; i < x.length; i++) {
    x[i] *= faktor;
  }
}

/// Glocke: inharmonische Teiltöne, jeder mit eigener Abklingzeit, leichte Schwebung
/// durch verstimmte Zwillinge und ein kurzer, gefilterter Anschlag.
/// [ausklang] ist die Zeit bis −60 dB des Grundtons.
Float64List glocke({
  required double grundton,
  required double dauer,
  required double ausklang,
  required Lcg rnd,
  double helligkeit = 1.0,
  double schwebung = 0.7,
  double anschlag = 0.25,
}) {
  // Teilton-Verhältnisse nach Glockenbauart (Prim, Terz, Quint, Oktave, höhere Partialtöne).
  const verhaeltnis = [0.5, 1.0, 1.19, 1.5, 2.0, 2.74, 3.76, 5.07];
  const relDauer = [1.25, 1.0, 0.7, 0.8, 0.6, 0.45, 0.35, 0.25];
  const pegel = [0.45, 1.0, 0.55, 0.5, 0.45, 0.3, 0.2, 0.12];
  final n = sekunden(dauer);
  final out = Float64List(n);
  for (var k = 0; k < verhaeltnis.length; k++) {
    final f = grundton * verhaeltnis[k];
    if (f > 0.45 * abtastrate) {
      continue;
    }
    final amp = pegel[k] * (k >= 5 ? helligkeit : 1.0);
    final rate = math.log(1000) / (ausklang * relDauer[k]);
    for (final verstimmt in [-schwebung, schwebung]) {
      final w = _zwoPi * (f + verstimmt) / abtastrate;
      final phase0 = rnd.naechste() * math.pi;
      for (var i = 0; i < n; i++) {
        out[i] += 0.5 * amp * math.exp(-rate * i / abtastrate) * math.sin(w * i + phase0);
      }
    }
  }
  // Anschlag: kurzes, gefiltertes Rauschen (Klöppel auf Bronze).
  final klick = Float64List(sekunden(0.03));
  for (var i = 0; i < klick.length; i++) {
    klick[i] = rnd.naechste() * math.exp(-i / (0.004 * abtastrate));
  }
  mische(out, filtere(klick, Zweipol.bandpass(2600, 1.5)), pegel: anschlag);
  einblenden(out, 0.002);
  ausblenden(out, 0.15);
  return out;
}

/// Gezupfte Saite (Karplus-Strong): Verzögerungsleitung mit gemittelter Rückkopplung.
/// [ausklang] ist die Zeit bis −60 dB. [helligkeit] steuert die Anregung (0 bis 1).
Float64List zupfen({
  required double frequenz,
  required double dauer,
  required double ausklang,
  required Lcg rnd,
  double helligkeit = 0.6,
}) {
  final n = sekunden(dauer);
  final laenge = math.max(2, (abtastrate / frequenz).round());
  final puffer = Float64List(laenge);
  var geglaettet = 0.0;
  for (var i = 0; i < laenge; i++) {
    geglaettet += helligkeit * (rnd.naechste() - geglaettet);
    puffer[i] = geglaettet;
  }
  final g = math.exp(-math.log(1000) / (ausklang * frequenz));
  final out = Float64List(n);
  var pos = 0;
  for (var i = 0; i < n; i++) {
    final aktuell = puffer[pos];
    final naechsterWert = puffer[(pos + 1) % laenge];
    out[i] = aktuell;
    puffer[pos] = g * 0.5 * (aktuell + naechsterWert);
    pos = (pos + 1) % laenge;
  }
  return out;
}

/// Wellentabelle aus Teiltönen: teilpegel[k] ist die Amplitude des (k+1)-ten Teiltons.
/// Die Tabelle hat einen Zusatzwert am Ende für die lineare Interpolation.
Float64List wellenform(List<double> teilpegel) {
  const laenge = 2048;
  final tab = Float64List(laenge + 1);
  var spitze = 0.0;
  for (var i = 0; i < laenge; i++) {
    final phase = _zwoPi * i / laenge;
    var summe = 0.0;
    for (var k = 0; k < teilpegel.length; k++) {
      summe += teilpegel[k] * math.sin((k + 1) * phase);
    }
    tab[i] = summe;
    spitze = math.max(spitze, summe.abs());
  }
  for (var i = 0; i <= laenge; i++) {
    tab[i] = tab[i % laenge] / spitze;
  }
  return tab;
}

/// ADSR-Hüllkurve an Position [i] einer Tonlänge [n] (Abtastwerte): linearer Anstieg über [angriff],
/// Abfall über [abfall] auf den Haltepegel [halte], Halten, linearer Ausklang über [ausklang].
/// Mit abfall = 0 und halte = 1 entsteht eine reine Anstieg-Ausklang-Hüllkurve.
double adsrHuelle(int i, int n, int angriff, int abfall, double halte, int ausklang) {
  if (i < angriff) {
    return i / angriff;
  }
  final j = i - angriff;
  var h = (abfall > 0 && j < abfall) ? 1.0 - (1.0 - halte) * j / abfall : halte;
  final rest = n - i;
  if (rest < ausklang) {
    h *= rest / ausklang;
  }
  return h;
}

/// Ton aus einer Wellentabelle mit ADSR-Hüllkurve und optionalem Vibrato.
Float64List ton({
  required Float64List tabelle,
  required double frequenz,
  required double dauer,
  double angriff = 0.05,
  double abfall = 0.0,
  double haltepegel = 1.0,
  double ausklang = 0.2,
  double vibratoTiefe = 0.0,
  double vibratoHz = 5.0,
  double cents = 0.0,
}) {
  final n = sekunden(dauer);
  final out = Float64List(n);
  final tabLen = tabelle.length - 1;
  final f = frequenz * math.pow(2, cents / 1200).toDouble();
  final a = math.max(1, sekunden(angriff));
  final d = sekunden(abfall);
  final r = math.max(1, sekunden(ausklang));
  var zyklus = 0.0;
  for (var i = 0; i < n; i++) {
    final vib = 1.0 + vibratoTiefe * math.sin(_zwoPi * vibratoHz * i / abtastrate);
    zyklus += f * vib / abtastrate;
    zyklus -= zyklus.floor();
    final pos = zyklus * tabLen;
    final i0 = pos.floor();
    final teil = pos - i0;
    final wert = tabelle[i0] + (tabelle[i0 + 1] - tabelle[i0]) * teil;
    out[i] = wert * adsrHuelle(i, n, a, d, haltepegel, r);
  }
  return out;
}

/// Schroeder-artiger Hall: vier parallele Kammfilter, zwei Allpässe in Reihe.
/// Mit [kreis] wird ein Einschwingdurchlauf vorgeschaltet, damit Schleifen am Ende passen.
Float64List hall(
  Float64List x, {
  double nachhall = 1.6,
  double anteil = 0.25,
  bool kreis = false,
}) {
  final halle = _Halle(nachhall);
  final wet = Float64List(x.length);
  if (kreis) {
    for (var i = 0; i < x.length; i++) {
      halle.verarbeite(x[i]);
    }
  }
  for (var i = 0; i < x.length; i++) {
    wet[i] = halle.verarbeite(x[i]);
  }
  final out = Float64List(x.length);
  for (var i = 0; i < x.length; i++) {
    out[i] = x[i] * (1 - anteil) + wet[i] * anteil;
  }
  return out;
}

class _Kamm {
  _Kamm(double verzoegerungSek, double nachhall)
      : _puffer = Float64List(math.max(1, (verzoegerungSek * abtastrate).round())),
        _g = math.pow(0.001, verzoegerungSek / nachhall).toDouble();

  final Float64List _puffer;
  final double _g;
  int _pos = 0;

  double verarbeite(double x) {
    final y = _puffer[_pos];
    _puffer[_pos] = x + _g * y;
    _pos = (_pos + 1) % _puffer.length;
    return y;
  }
}

class _Allpass {
  _Allpass(double verzoegerungSek)
      : _puffer = Float64List(math.max(1, (verzoegerungSek * abtastrate).round()));

  static const double _g = 0.5;
  final Float64List _puffer;
  int _pos = 0;

  double verarbeite(double x) {
    final v = _puffer[_pos];
    final y = -_g * x + v;
    _puffer[_pos] = x + _g * y;
    _pos = (_pos + 1) % _puffer.length;
    return y;
  }
}

class _Halle {
  _Halle(double nachhall)
      : _kamm = [
          for (final ms in [29.7, 37.1, 41.1, 43.7]) _Kamm(ms / 1000, nachhall),
        ],
        _allpass = [_Allpass(0.005), _Allpass(0.0017)];

  final List<_Kamm> _kamm;
  final List<_Allpass> _allpass;

  double verarbeite(double x) {
    var summe = 0.0;
    for (final k in _kamm) {
      summe += k.verarbeite(x);
    }
    summe *= 0.25;
    for (final a in _allpass) {
      summe = a.verarbeite(summe);
    }
    return summe;
  }
}

/// Kodiert ein Signal als WAV: RIFF, PCM, 16 Bit, mono, 22 050 Hz.
Uint8List wavBytes(Float64List x) {
  final dataBytes = x.length * 2;
  final bd = ByteData(44 + dataBytes);
  void text(int offset, String s) {
    for (var i = 0; i < 4; i++) {
      bd.setUint8(offset + i, s.codeUnitAt(i));
    }
  }

  text(0, 'RIFF');
  bd.setUint32(4, 36 + dataBytes, Endian.little);
  text(8, 'WAVE');
  text(12, 'fmt ');
  bd.setUint32(16, 16, Endian.little);
  bd.setUint16(20, 1, Endian.little);
  bd.setUint16(22, 1, Endian.little);
  bd.setUint32(24, abtastrate, Endian.little);
  bd.setUint32(28, abtastrate * 2, Endian.little);
  bd.setUint16(32, 2, Endian.little);
  bd.setUint16(34, 16, Endian.little);
  text(36, 'data');
  bd.setUint32(40, dataBytes, Endian.little);
  for (var i = 0; i < x.length; i++) {
    final v = (x[i] * 32767).round().clamp(-32768, 32767);
    bd.setInt16(44 + 2 * i, v, Endian.little);
  }
  return bd.buffer.asUint8List();
}
