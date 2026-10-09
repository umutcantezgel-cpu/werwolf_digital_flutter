import 'dart:math' as math;

/// Farbabstand nach CIEDE2000 (Sharma, Wu, Dalal 2005), kL = kC = kH = 1.
/// Weißpunkt D65; sRGB → linear → XYZ → CIELAB.

const List<double> _weissD65 = [0.95047, 1.0, 1.08883];
const double _sechsAchtelDelta = 6 / 29;
final double _p25hoch7 = math.pow(25, 7).toDouble();

/// Hex-Farbe `#rrggbb` (das `#` ist optional) als Liste aus drei Kanälen 0..255.
List<int> _hexNachRgb(String hex) {
  final treffer = RegExp(r'^#?([0-9a-fA-F]{6})$').firstMatch(hex.trim());
  if (treffer == null) {
    throw FormatException('Keine Hex-Farbe #rrggbb: $hex');
  }
  final wert = int.parse(treffer.group(1)!, radix: 16);
  return [(wert >> 16) & 0xff, (wert >> 8) & 0xff, wert & 0xff];
}

/// sRGB-Kanal (0..255) → linearer Lichtwert (0..1).
double _linear(int kanal) {
  final v = kanal / 255;
  return v <= 0.04045 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
}

/// Kennlinie für CIELAB.
double _labF(double t) {
  if (t > _sechsAchtelDelta * _sechsAchtelDelta * _sechsAchtelDelta) {
    return math.pow(t, 1 / 3).toDouble();
  }
  return t / (3 * _sechsAchtelDelta * _sechsAchtelDelta) + 4 / 29;
}

/// Hex-Farbe → CIELAB `[L, a, b]` unter D65.
List<double> labAusHex(String hex) {
  final rgb = _hexNachRgb(hex);
  final r = _linear(rgb[0]);
  final g = _linear(rgb[1]);
  final b = _linear(rgb[2]);
  final x = 0.4124564 * r + 0.3575761 * g + 0.1804375 * b;
  final y = 0.2126729 * r + 0.7151522 * g + 0.0721750 * b;
  final z = 0.0193339 * r + 0.1191920 * g + 0.9503041 * b;
  final fx = _labF(x / _weissD65[0]);
  final fy = _labF(y / _weissD65[1]);
  final fz = _labF(z / _weissD65[2]);
  return [116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz)];
}

double _grad(double rad) => rad * 180 / math.pi;
double _rad(double grad) => grad * math.pi / 180;

/// Farbwinkel in Grad (0..360) aus b und a'.
double _winkel(double b, double a) {
  if (a == 0 && b == 0) return 0;
  final h = _grad(math.atan2(b, a));
  return h < 0 ? h + 360 : h;
}

double _pow(double basis, num exponent) => math.pow(basis, exponent).toDouble();

/// CIEDE2000-Abstand zweier CIELAB-Farben `[L, a, b]`.
double deltaE2000Lab(List<double> lab1, List<double> lab2) {
  final l1 = lab1[0], a1 = lab1[1], b1 = lab1[2];
  final l2 = lab2[0], a2 = lab2[1], b2 = lab2[2];

  // Chroma-Ausgleich (G) für die Achse a.
  final cBar = (math.sqrt(a1 * a1 + b1 * b1) + math.sqrt(a2 * a2 + b2 * b2)) / 2;
  final cBar7 = _pow(cBar, 7);
  final g = 0.5 * (1 - math.sqrt(cBar7 / (cBar7 + _p25hoch7)));
  final a1p = (1 + g) * a1;
  final a2p = (1 + g) * a2;
  final c1p = math.sqrt(a1p * a1p + b1 * b1);
  final c2p = math.sqrt(a2p * a2p + b2 * b2);
  final h1p = _winkel(b1, a1p);
  final h2p = _winkel(b2, a2p);

  // Differenzen.
  final dLp = l2 - l1;
  final dCp = c2p - c1p;
  double dhp;
  if (c1p * c2p == 0) {
    dhp = 0;
  } else if ((h2p - h1p).abs() <= 180) {
    dhp = h2p - h1p;
  } else if (h2p - h1p > 180) {
    dhp = h2p - h1p - 360;
  } else {
    dhp = h2p - h1p + 360;
  }
  final dHp = 2 * math.sqrt(c1p * c2p) * math.sin(_rad(dhp / 2));

  // Mittelwerte.
  final lBarp = (l1 + l2) / 2;
  final cBarp = (c1p + c2p) / 2;
  double hBarp;
  if (c1p * c2p == 0) {
    hBarp = h1p + h2p;
  } else if ((h1p - h2p).abs() <= 180) {
    hBarp = (h1p + h2p) / 2;
  } else if (h1p + h2p < 360) {
    hBarp = (h1p + h2p + 360) / 2;
  } else {
    hBarp = (h1p + h2p - 360) / 2;
  }

  // Gewichtungsfunktionen.
  final t = 1 -
      0.17 * math.cos(_rad(hBarp - 30)) +
      0.24 * math.cos(_rad(2 * hBarp)) +
      0.32 * math.cos(_rad(3 * hBarp + 6)) -
      0.20 * math.cos(_rad(4 * hBarp - 63));
  final dTheta = 30 * math.exp(-_pow((hBarp - 275) / 25, 2));
  final cBarp7 = _pow(cBarp, 7);
  final rc = 2 * math.sqrt(cBarp7 / (cBarp7 + _p25hoch7));
  final lAbweichung = lBarp - 50;
  final sl = 1 + 0.015 * lAbweichung * lAbweichung / math.sqrt(20 + lAbweichung * lAbweichung);
  final sc = 1 + 0.045 * cBarp;
  final sh = 1 + 0.015 * cBarp * t;
  final rt = -math.sin(_rad(2 * dTheta)) * rc;

  final termL = dLp / sl;
  final termC = dCp / sc;
  final termH = dHp / sh;
  return math.sqrt(termL * termL + termC * termC + termH * termH + rt * termC * termH);
}

/// CIEDE2000-Abstand zweier Hex-Farben `#rrggbb`.
double deltaE2000(String hexA, String hexB) => deltaE2000Lab(labAusHex(hexA), labAusHex(hexB));
