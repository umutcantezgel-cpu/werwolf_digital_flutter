import '../palette.dart';
import '../raster/texture.dart';
import 'werkzeug.dart';

/// Textur-Bibliothek der Burgstadt (Auftrag A-302a).
///
/// Jede Textur ist kachelbar (Zweierpotenz-Seitenlänge, Wrap-Zeichnung), nutzt
/// nur Palettenindizes 0–63 und zeigt die Grundfarbe in mittleren Stufen (2–5).
/// Fugen und Schatten liegen dunkler, Kanten oben links eine Stufe heller.
/// Alles ist deterministisch: eigener LCG mit festem Seed, kein `dart:math`-Zufall.
enum TexturId {
  pflaster,
  pflasterGross,
  putzOcker,
  putzAltrosa,
  putzTaubenblau,
  putzCreme,
  putzKalkweiss,
  putzSandstein,
  sockelBruchstein,
  dachBiberschwanz,
  dachBiberschwanzMoos,
  bruchsteinMauer,
  quaderMauer,
  burgBruchstein,
  gewoelbeDecke,
  holzBohlen,
  holzDielen,
  eichenTuer,
  eichenTuerEisen,
  fensterLaden,
  fensterDunkel,
  fensterKerze,
  fachwerkPutz,
  ziegelKamin,
  kiesWeg,
  wiese,
  erde,
  schieferPlatten,
  stufenStein,
  teppichRot,
  kachelOfen,
  regalBuecher,
  tapeteStreifen,
  holzVertaefelung,
  putzInnenWarm,
  eisenGitter,
}

/// Eintrag des Textur-Registers (Burgstadt HD, P1-OPUS-01): Bauer und Zeichendichte.
class TexturEintrag {
  const TexturEintrag(this.bauer, {this.dichte = 32});

  /// Baut die Textur (jedes Mal identische Bytes).
  final IndexedTexture Function() bauer;

  /// Texel pro Meter, in der die Textur gezeichnet ist: 32 = Bestand (Nachtlauf), 64 = Burgstadt HD.
  final int dichte;
}

/// HD-Fassungen nach Name: ersetzen den Bestandseintrag mit gleichem [TexturId]. Jede HD-Textur
/// liegt in einer eigenen Datei `kit/texturen/<name>.dart` und wird hier eingetragen (Register nach
/// Name, E-010; der Enum [TexturId] bleibt die Namensquelle).
final Map<TexturId, TexturEintrag> _hdTexturen = {};

/// Registereintrag einer Textur: HD-Fassung, sonst Bestand.
TexturEintrag texturEintrag(TexturId id) => _hdTexturen[id] ?? TexturEintrag(_bauer[id.index]);

/// Baut eine einzelne Textur in ihrer Zeichendichte (jedes Mal identische Bytes).
IndexedTexture baueTextur(TexturId id) => texturEintrag(id).bauer();

/// Alle Texturen; Index = `TexturId.index`.
List<IndexedTexture> baueAlleTexturen() => [for (final id in TexturId.values) baueTextur(id)];

typedef _Bauer = IndexedTexture Function();

final List<_Bauer> _bauer = [
  _pflaster,
  _pflasterGross,
  () => putz(Ramp.amber, 4, seed: 1),
  () => putz(Ramp.skin, 4, seed: 2),
  () => putz(Ramp.blue, 5, seed: 3),
  () => putz(Ramp.skin, 5, seed: 4),
  () => putz(Ramp.stone, 5, seed: 5),
  () => putz(Ramp.wood, 5, seed: 6),
  _sockelBruchstein,
  _dachBiberschwanz,
  _dachBiberschwanzMoos,
  _bruchsteinMauer,
  _quaderMauer,
  _burgBruchstein,
  _gewoelbeDecke,
  _holzBohlen,
  _holzDielen,
  _eichenTuer,
  _eichenTuerEisen,
  _fensterLaden,
  _fensterDunkel,
  _fensterKerze,
  _fachwerkPutz,
  _ziegelKamin,
  _kiesWeg,
  _wiese,
  _erde,
  _schieferPlatten,
  _stufenStein,
  _teppichRot,
  _kachelOfen,
  _regalBuecher,
  _tapeteStreifen,
  _holzVertaefelung,
  () => putz(Ramp.amber, 3, seed: 7),
  _eisenGitter,
];

// ---------------------------------------------------------------- Texturen

IndexedTexture _pflaster() {
  final t = Tex(32);
  steine(
    t,
    Lcg(11),
    rampe: Ramp.stone,
    koerper: 4,
    fuge: Ramp.at(Ramp.stone, 1),
    runden: Ramp.at(Ramp.stone, 1),
    zeilen: [2, 7, 12, 18, 23, 28],
    spalten: [
      [4, 10, 16, 22, 28],
      [1, 7, 13, 19, 25],
      [3, 9, 15, 21, 27],
      [2, 8, 14, 20, 26],
      [4, 11, 17, 24, 30],
      [5, 11, 17, 23, 29],
    ],
  );
  return t.build();
}

IndexedTexture _pflasterGross() {
  final t = Tex(64);
  steine(
    t,
    Lcg(21),
    rampe: Ramp.neutral,
    koerper: 5,
    fuge: Ramp.at(Ramp.neutral, 1),
    zeilen: [3, 11, 19, 27, 35, 43, 51, 59],
    spalten: [
      for (var k = 0; k < 8; k++) [for (var x = k.isEven ? 2 : 6; x < 64; x += 8) x],
    ],
  );
  return t.build();
}

IndexedTexture _sockelBruchstein() {
  final t = Tex(32);
  steine(
    t,
    Lcg(31),
    rampe: Ramp.stone,
    koerper: 3,
    fuge: Ramp.at(Ramp.stone, 1),
    zeilen: [1, 8, 14, 21, 27],
    spalten: [
      [5, 12, 19, 26],
      [2, 9, 16, 23, 30],
      [4, 11, 17, 24],
      [9, 20, 29],
      [3, 14, 25],
    ],
  );
  return t.build();
}

IndexedTexture _dachBiberschwanz() => _dach(seed: 41, moos: false);

IndexedTexture _dachBiberschwanzMoos() => _dach(seed: 42, moos: true);

/// Biberschwanz-Ziegel: Reihen zu 8 Pixeln, jede zweite Reihe um 4 versetzt. Jede Reihe hat
/// eine helle Oberkante, eine dunkle Unterkante und abgerundete Enden. Moos sitzt in den
/// Fugen und an den Unterkanten.
IndexedTexture _dach({required int seed, required bool moos}) {
  final t = Tex(32), r = Lcg(seed);
  final fuge = Ramp.at(Ramp.red, 0), schattenFarbe = Ramp.at(Ramp.red, 2);
  for (var reihe = 0; reihe < 8; reihe++) {
    final y0 = 2 + reihe * 4;
    final fugen = reihe.isEven ? [2, 10, 18, 26] : [6, 14, 22, 30];
    for (var i = 0; i < fugen.length; i++) {
      final a = fugen[i] + 1;
      final b = (i + 1 < fugen.length ? fugen[i + 1] : fugen[0] + 32) - 1;
      final dunkler = !moos && r.below(3) == 0;
      final s = 3 - (dunkler ? 1 : 0);
      final korper = Ramp.at(Ramp.red, s), hell = Ramp.at(Ramp.red, s + 1), schatten = Ramp.at(Ramp.red, s - 1);
      for (var y = y0; y <= y0 + 3; y++) {
        for (var x = a; x <= b; x++) {
          t.p(x, y, korper);
        }
        t.p(a, y, hell);
        t.p(b, y, schatten);
      }
      for (var x = a; x <= b; x++) {
        t.p(x, y0, hell);
        t.p(x, y0 + 3, schatten);
      }
      t.p(a, y0 + 3, fuge);
      t.p(b, y0 + 3, fuge);
    }
    for (final x in fugen) {
      for (var y = y0; y <= y0 + 3; y++) {
        t.p(x, y, fuge);
      }
    }
  }
  if (moos) {
    for (var y = 0; y < 32; y++) {
      for (var x = 0; x < 32; x++) {
        final c = t.g(x, y);
        if ((c == fuge && r.below(100) < 75) ||
            (c == schattenFarbe && r.below(100) < 45) ||
            (c == Ramp.at(Ramp.red, 3) && r.below(100) < 6)) {
          t.p(x, y, Pal.moss);
        }
      }
    }
  }
  return t.build();
}

IndexedTexture _bruchsteinMauer() {
  final t = Tex(64), r = Lcg(51);
  final fuge = Ramp.at(Ramp.stone, 2);
  steine(
    t,
    r,
    rampe: Ramp.stone,
    koerper: 4,
    fuge: fuge,
    zeilen: [3, 12, 19, 30, 37, 47, 56],
    spalten: [
      [5, 16, 27, 40, 52],
      [9, 22, 36, 49],
      [3, 13, 25, 33, 46, 58],
      [11, 30, 44, 56],
      [7, 20, 39, 51],
      [14, 28, 42, 60],
      [4, 19, 32, 48],
    ],
  );
  for (var y = 0; y < 64; y++) {
    for (var x = 0; x < 64; x++) {
      final c = t.g(x, y);
      if ((c == fuge && r.below(100) < 60) || (c == Ramp.at(Ramp.stone, 5) && r.below(100) < 12)) {
        t.p(x, y, Pal.moss);
      }
    }
  }
  return t.build();
}

IndexedTexture _quaderMauer() {
  final t = Tex(64);
  steine(
    t,
    Lcg(61),
    rampe: Ramp.stone,
    koerper: 5,
    fuge: Ramp.at(Ramp.stone, 2),
    zeilen: [3, 19, 35, 51],
    spalten: [
      [4, 20, 36, 52],
      [12, 28, 44, 60],
      [4, 20, 36, 52],
      [12, 28, 44, 60],
    ],
  );
  return t.build();
}

IndexedTexture _burgBruchstein() {
  final t = Tex(64);
  steine(
    t,
    Lcg(71),
    rampe: Ramp.stone,
    koerper: 3,
    fuge: Ramp.at(Ramp.stone, 0),
    zeilen: [2, 11, 18, 27, 36, 45, 54],
    spalten: [
      [6, 19, 33, 47],
      [10, 27, 41, 58],
      [4, 15, 30, 44, 56],
      [9, 22, 37, 52],
      [13, 26, 48],
      [3, 17, 35, 50, 61],
      [8, 24, 39, 55],
    ],
  );
  return t.build();
}

IndexedTexture _gewoelbeDecke() {
  final t = Tex(64);
  // Rippen: 2 Pixel breit (Kern, helle Kante), dunkle Gegenkante; Felder dazwischen.
  final panel = Ramp.at(Ramp.stone, 3), schatten = Ramp.at(Ramp.stone, 2);
  final rippe = Ramp.at(Ramp.stone, 5), licht = Ramp.at(Ramp.stone, 6);
  for (var y = 0; y < 64; y++) {
    for (var x = 0; x < 64; x++) {
      final d1 = (x - y) % 32, d2 = (x + y) % 32;
      if (d1 == 0 || d2 == 0) {
        t.p(x, y, rippe);
      } else if (d1 == 1 || d2 == 1) {
        t.p(x, y, licht);
      } else if (d1 == 31 || d2 == 31) {
        t.p(x, y, schatten);
      } else {
        t.p(x, y, panel);
      }
    }
  }
  return t.build();
}

IndexedTexture _holzBohlen() {
  final t = Tex(32);
  planken(t, Lcg(81), rampe: Ramp.wood, koerper: 3, fuge: Ramp.at(Ramp.wood, 1), fugenX: [3, 11, 19, 27]);
  return t.build();
}

IndexedTexture _holzDielen() {
  final t = Tex(32);
  steine(
    t,
    Lcg(91),
    rampe: Ramp.wood,
    koerper: 4,
    fuge: Ramp.at(Ramp.wood, 1),
    zeilen: [2, 10, 18, 26],
    spalten: [
      [9],
      [22],
      [5],
      [16],
    ],
  );
  return t.build();
}

IndexedTexture _eichenTuer() {
  final t = Tex(32);
  final fuge = Ramp.at(Ramp.wood, 1);
  planken(t, Lcg(101), rampe: Ramp.wood, koerper: 3, fuge: fuge, fugenX: [2, 10, 18, 26]);
  t.hline(0, 9, 32, fuge);
  t.hline(0, 22, 32, fuge);
  return t.build();
}

IndexedTexture _eichenTuerEisen() {
  final t = Tex(32);
  planken(t, Lcg(111), rampe: Ramp.wood, koerper: 3, fuge: Ramp.at(Ramp.wood, 2), fugenX: [2, 10, 18, 26], toene: 0);
  for (final y in [7, 22]) {
    t.hline(0, y, 32, Ramp.at(Ramp.neutral, 5));
    t.hline(0, y + 1, 32, Ramp.at(Ramp.neutral, 3));
  }
  return t.build();
}

IndexedTexture _fensterLaden() {
  final t = Tex(32);
  steine(
    t,
    Lcg(121),
    rampe: Ramp.wood,
    koerper: 4,
    fuge: Ramp.at(Ramp.wood, 1),
    zeilen: [2, 6, 10, 14, 18, 22, 26, 30],
    spalten: [for (var k = 0; k < 8; k++) <int>[]],
  );
  return t.build();
}

IndexedTexture _fensterDunkel() {
  final t = Tex(32);
  final rahmen = Ramp.at(Ramp.wood, 2), rahmenHell = Ramp.at(Ramp.wood, 3);
  final glas = Ramp.at(Ramp.blue, 2), glasTief = Ramp.at(Ramp.blue, 1), glasHell = Ramp.at(Ramp.blue, 3);
  t.fill(glas);
  t.rect(0, 20, 32, 12, glasTief);
  for (var k = 0; k < 6; k++) {
    t.p(4 + k, 5 + k, glasHell);
    t.p(5 + k, 5 + k, glasHell);
  }
  for (var k = 0; k < 4; k++) {
    t.p(20 + k, 19 - k, glasHell);
  }
  t.rect(0, 0, 32, 2, rahmen);
  t.rect(0, 30, 32, 2, rahmen);
  t.rect(0, 0, 2, 32, rahmen);
  t.rect(30, 0, 2, 32, rahmen);
  t.rect(2, 2, 28, 1, rahmenHell);
  t.rect(2, 2, 1, 28, rahmenHell);
  t.rect(15, 2, 2, 28, rahmen);
  t.rect(2, 15, 28, 2, rahmen);
  return t.build();
}

IndexedTexture _fensterKerze() {
  final t = Tex(32);
  final rahmen = Ramp.at(Ramp.wood, 2), glas = Ramp.at(Ramp.amber, 3), glut = Ramp.at(Ramp.amber, 4);
  final flamme = Ramp.at(Ramp.amber, 5);
  t.fill(glas);
  t.rect(4, 4, 24, 22, glut);
  t.rect(0, 0, 32, 2, rahmen);
  t.rect(0, 30, 32, 2, rahmen);
  t.rect(0, 0, 2, 32, rahmen);
  t.rect(30, 0, 2, 32, rahmen);
  t.rect(15, 2, 2, 28, rahmen);
  t.rect(2, 15, 28, 2, rahmen);
  t.rect(14, 19, 4, 8, rahmen);
  t.rect(15, 17, 2, 2, flamme);
  return t.build();
}

IndexedTexture _fachwerkPutz() {
  final t = Tex(64), r = Lcg(131);
  final putz = Ramp.at(Ramp.skin, 4), dunkel = Ramp.at(Ramp.skin, 3);
  final holz = Ramp.at(Ramp.wood, 3), holzHell = Ramp.at(Ramp.wood, 4), holzDunkel = Ramp.at(Ramp.wood, 2);
  t.fill(putz);
  for (var k = 0; k < 10; k++) {
    t.rect(2 + r.below(58), r.below(64), 3 + r.below(4), 2 + r.below(3), dunkel);
  }
  // Ständer und Riegel: 3 Pixel breit, Kante oben links hell, unten rechts dunkel.
  for (final x in [14, 46]) {
    t.vline(x, 0, 64, holzHell);
    t.vline(x + 1, 0, 64, holz);
    t.vline(x + 2, 0, 64, holzDunkel);
  }
  for (final y in [26, 50]) {
    t.hline(0, y, 64, holzHell);
    t.hline(0, y + 1, 64, holz);
    t.hline(0, y + 2, 64, holzDunkel);
  }
  // Andreaskreuz im unteren Feld zwischen den Ständern.
  for (var k = 0; k <= 28; k++) {
    final y = 29 + (k * 20) ~/ 28;
    for (final (x, yy) in [(17 + k, y), (45 - k, y), (17 + k, y + 1), (45 - k, y + 1)]) {
      t.p(x, yy, holz);
    }
  }
  return t.build();
}

IndexedTexture _ziegelKamin() {
  final t = Tex(32);
  steine(
    t,
    Lcg(141),
    rampe: Ramp.red,
    koerper: 4,
    fuge: Ramp.at(Ramp.stone, 5),
    zeilen: [1, 5, 9, 13, 17, 21, 25, 29],
    spalten: [for (var k = 0; k < 8; k++) k.isEven ? [2, 10, 18, 26] : [6, 14, 22, 30]],
  );
  return t.build();
}

IndexedTexture _kiesWeg() {
  final t = Tex(32), r = Lcg(151);
  t.fill(Ramp.at(Ramp.stone, 3));
  for (var k = 0; k < 20; k++) {
    final x = r.below(32), y = r.below(32);
    t.p(x, y, Ramp.at(Ramp.stone, 5));
    t.p(x + 1, y, Ramp.at(Ramp.stone, 4));
    t.p(x, y + 1, Ramp.at(Ramp.stone, 4));
    t.p(x + 1, y + 1, Ramp.at(Ramp.stone, 2));
  }
  return t.build();
}

IndexedTexture _wiese() {
  final t = Tex(32), r = Lcg(161);
  final tief = Ramp.at(Ramp.green, 2), gras = Ramp.at(Ramp.green, 3);
  final halm = Ramp.at(Ramp.green, 5), spitze = Ramp.at(Ramp.green, 6);
  t.fill(gras);
  for (var k = 0; k < 10; k++) {
    t.rect(r.below(32), r.below(32), 3, 2, tief);
  }
  for (var k = 0; k < 16; k++) {
    final x = r.below(32), y = r.below(32);
    t.p(x, y, spitze);
    t.p(x + 2, y, spitze);
    t.p(x + 1, y + 1, halm);
    t.p(x + 1, y + 2, halm);
  }
  return t.build();
}

IndexedTexture _erde() {
  final t = Tex(32), r = Lcg(171);
  t.fill(Ramp.at(Ramp.wood, 3));
  for (var k = 0; k < 30; k++) {
    t.p(r.below(32), r.below(32), Ramp.at(Ramp.wood, 2));
  }
  for (var k = 0; k < 10; k++) {
    final x = r.below(32), y = r.below(32);
    t.p(x, y, Ramp.at(Ramp.wood, 4));
    t.p(x + 1, y, Ramp.at(Ramp.stone, 4));
    t.p(x, y + 1, Ramp.at(Ramp.stone, 3));
    t.p(x + 1, y + 1, Ramp.at(Ramp.wood, 2));
  }
  return t.build();
}

IndexedTexture _schieferPlatten() {
  final t = Tex(32);
  steine(
    t,
    Lcg(181),
    rampe: Ramp.blue,
    koerper: 3,
    fuge: Ramp.at(Ramp.blue, 0),
    zeilen: [3, 11, 19, 27],
    spalten: [
      [9, 22],
      [4, 17, 28],
      [13, 25],
      [6, 15, 24],
    ],
  );
  return t.build();
}

IndexedTexture _stufenStein() {
  final t = Tex(32);
  steine(
    t,
    Lcg(191),
    rampe: Ramp.stone,
    koerper: 5,
    fuge: Ramp.at(Ramp.stone, 2),
    zeilen: [2, 10, 18, 26],
    spalten: [
      [11, 27],
      [5, 21],
      [14, 30],
      [8, 24],
    ],
  );
  return t.build();
}

IndexedTexture _teppichRot() {
  final t = Tex(32);
  final grund = Ramp.at(Ramp.red, 2), ring = Ramp.at(Ramp.red, 3), kern = Ramp.at(Ramp.red, 4);
  final rand = Ramp.at(Ramp.red, 1), gold = Ramp.at(Ramp.amber, 4);
  for (var y = 0; y < 32; y++) {
    for (var x = 0; x < 32; x++) {
      final d = (x % 16 - 8).abs() + (y % 16 - 8).abs();
      if (d <= 2) {
        t.p(x, y, kern);
      } else if (d == 3) {
        t.p(x, y, ring);
      } else if (d == 4) {
        t.p(x, y, rand);
      } else {
        t.p(x, y, grund);
      }
    }
  }
  for (var y = 0; y < 32; y += 16) {
    for (var x = 0; x < 32; x += 16) {
      t.p(x, y, gold);
    }
  }
  return t.build();
}

IndexedTexture _kachelOfen() {
  final t = Tex(32);
  final fuge = Ramp.at(Ramp.neutral, 2), ornament = fuge;
  steine(
    t,
    Lcg(201),
    rampe: Ramp.blue,
    koerper: 4,
    fuge: fuge,
    zeilen: [3, 11, 19, 27],
    spalten: [
      for (var k = 0; k < 4; k++) [3, 11, 19, 27],
    ],
  );
  // Ein Niet pro Kachel; ein Ornament mit Armen würde über den Rand laufen.
  for (final cy in [7, 15, 23, 31]) {
    for (final cx in [7, 15, 23, 31]) {
      t.p(cx, cy, ornament);
    }
  }
  return t.build();
}

IndexedTexture _regalBuecher() {
  final t = Tex(32), r = Lcg(211);
  final lucke = Ramp.at(Ramp.wood, 0), brett = Ramp.at(Ramp.wood, 2);
  final buecher = [Ramp.at(Ramp.red, 4), Ramp.at(Ramp.blue, 4), Ramp.at(Ramp.amber, 3)];
  t.fill(lucke);
  t.hline(0, 12, 32, brett);
  t.hline(0, 28, 32, brett);
  for (final band in [
    [13, 27],
    [29, 43],
  ]) {
    var x = 0;
    while (x < 32) {
      final breite = 2 + r.below(2);
      t.rect(x, band[0], breite, band[1] - band[0] + 1, buecher[r.below(buecher.length)]);
      x += breite + 1;
    }
  }
  return t.build();
}

IndexedTexture _tapeteStreifen() {
  final t = Tex(32);
  final grund = Ramp.at(Ramp.skin, 3), hell = Ramp.at(Ramp.skin, 5);
  final dunkel = Ramp.at(Ramp.skin, 2), mittel = Ramp.at(Ramp.skin, 4);
  for (var y = 0; y < 32; y++) {
    for (var x = 0; x < 32; x++) {
      final p = x % 8;
      var c = grund;
      if (p == 1 || p == 2) c = hell;
      if (p == 5) c = dunkel;
      if (p == 2 && y % 8 == 4) c = mittel;
      t.p(x, y, c);
    }
  }
  return t.build();
}

IndexedTexture _holzVertaefelung() {
  final t = Tex(32);
  final fuge = Ramp.at(Ramp.wood, 1);
  planken(t, Lcg(221), rampe: Ramp.wood, koerper: 4, fuge: fuge, fugenX: [4, 12, 20, 28]);
  t.hline(0, 10, 32, fuge);
  t.hline(0, 21, 32, fuge);
  return t.build();
}

IndexedTexture _eisenGitter() {
  final t = Tex(32);
  final loch = Ramp.at(Ramp.blue, 1), hell = Ramp.at(Ramp.neutral, 5);
  final koerper = Ramp.at(Ramp.neutral, 3), niet = Ramp.at(Ramp.neutral, 6);
  t.fill(loch);
  for (final c in [7, 23]) {
    t.vline(c, 0, 32, hell);
    t.vline(c + 1, 0, 32, koerper);
  }
  for (final r in [7, 23]) {
    t.hline(0, r, 32, hell);
    t.hline(0, r + 1, 32, koerper);
  }
  for (final c in [7, 23]) {
    for (final r in [7, 23]) {
      t.p(c, r, niet);
    }
  }
  return t.build();
}
