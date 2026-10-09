import 'dart:typed_data';

import 'material.dart';

/// Eintrag der Farbtafel eines Blockkörpers: Material (Kennung aus [kMaterialien]) und Farbe 0xRRGGBB.
/// So trägt jeder Block ein Material, und Figuren können jede Kanon-Farbe in „Stoff“ tragen.
class Farbeintrag {
  const Farbeintrag(this.material, this.farbe);

  /// Eintrag mit der Grundfarbe des Materials.
  factory Farbeintrag.material(int material) {
    final m = materialVon(material);
    if (m == null) throw ArgumentError.value(material, 'material', 'unbekannte Materialkennung');
    return Farbeintrag(material, m.farbe);
  }

  final int material;
  final int farbe;

  @override
  bool operator ==(Object other) => other is Farbeintrag && other.material == material && other.farbe == farbe;

  @override
  int get hashCode => material * 16777259 + farbe;
}

/// Seitenlänge eines Abschnitts in Blöcken (32³ Blöcke).
const kAbschnitt = 32;
const _abschnittBits = 5;
const _abschnittMaske = kAbschnitt - 1;

/// Ein Blockkörper (6. Begriffe): zusammenhängende Blöcke mit eigener [blockgroesse] (Meter) und eigener
/// Lage. Achsen wie die Welt: x nach Osten, y nach Süden, z nach oben; Block (i, j, k) liegt im Körper bei
/// (i·s … (i+1)·s, j·s …, k·s …). Gespeichert wird dünn: ein Abschnitt aus 32³ Blöcken ist entweder leer
/// (Luft) oder einheitlich (ein Wert, z. B. verdecktes Inneres) – beides kostet nur 1 Byte Kopf – oder voll
/// (32 KB). Randabschnitte gelten als einheitlich, wenn ihr Teil im Körper ganz gefüllt ist.
class Blockkoerper {
  Blockkoerper({required this.blockgroesse, required this.breite, required this.tiefe, required this.hoehe})
      : assert(breite > 0 && tiefe > 0 && hoehe > 0),
        _ax = (breite + _abschnittMaske) >> _abschnittBits,
        _ay = (tiefe + _abschnittMaske) >> _abschnittBits,
        _az = (hoehe + _abschnittMaske) >> _abschnittBits {
    _voll = List<Uint8List?>.filled(_ax * _ay * _az, null);
    _einheitlich = Uint8List(_ax * _ay * _az);
  }

  /// Kantenlänge eines Blocks in Metern.
  final double blockgroesse;

  /// Ausdehnung in Blöcken (x, y, z).
  final int breite, tiefe, hoehe;
  final int _ax, _ay, _az;
  late final List<Uint8List?> _voll;
  late final Uint8List _einheitlich;

  /// Farbtafel; Index 0 ist Luft. Höchstens 255 Einträge.
  final List<Farbeintrag?> tafel = [null];

  /// Index des Eintrags (legt ihn bei Bedarf an).
  int eintrag(Farbeintrag e) {
    final i = tafel.indexOf(e);
    if (i > 0) return i;
    if (tafel.length >= 256) throw StateError('Farbtafel voll (255 Einträge)');
    tafel.add(e);
    return tafel.length - 1;
  }

  int _abschnittIndex(int cx, int cy, int cz) => (cz * _ay + cy) * _ax + cx;

  /// Wert des Blocks (Tafelindex, 0 = Luft); außerhalb des Körpers 0.
  int wert(int x, int y, int z) {
    if (x < 0 || y < 0 || z < 0 || x >= breite || y >= tiefe || z >= hoehe) return 0;
    final a = _abschnittIndex(x >> _abschnittBits, y >> _abschnittBits, z >> _abschnittBits);
    final v = _voll[a];
    if (v == null) return _einheitlich[a];
    return v[((z & _abschnittMaske) << 10) | ((y & _abschnittMaske) << 5) | (x & _abschnittMaske)];
  }

  /// Setzt einen Block (Tafelindex, 0 = Luft).
  void setze(int x, int y, int z, int w) {
    if (w < 0 || w > 255) throw ArgumentError.value(w, 'w', 'Tafelindex 0..255');
    if (x < 0 || y < 0 || z < 0 || x >= breite || y >= tiefe || z >= hoehe) return;
    final a = _abschnittIndex(x >> _abschnittBits, y >> _abschnittBits, z >> _abschnittBits);
    var v = _voll[a];
    if (v == null) {
      if (_einheitlich[a] == w) return;
      v = _voll[a] = _ausEinheitlich(a, _einheitlich[a]);
    }
    v[((z & _abschnittMaske) << 10) | ((y & _abschnittMaske) << 5) | (x & _abschnittMaske)] = w;
  }

  /// Volle Fassung eines einheitlichen Abschnitts: der Wert nur an Stellen innerhalb des Körpers
  /// (Randabschnitte ragen über den Körper hinaus; dort bleibt Luft).
  Uint8List _ausEinheitlich(int a, int u) {
    final v = Uint8List(kAbschnitt * kAbschnitt * kAbschnitt);
    if (u == 0) return v;
    final cx = a % _ax, cy = (a ~/ _ax) % _ay, cz = a ~/ (_ax * _ay);
    final nx = breite - (cx << _abschnittBits), ny = tiefe - (cy << _abschnittBits), nz = hoehe - (cz << _abschnittBits);
    final mx = nx < kAbschnitt ? nx : kAbschnitt, my = ny < kAbschnitt ? ny : kAbschnitt, mz = nz < kAbschnitt ? nz : kAbschnitt;
    for (var z = 0; z < mz; z++) {
      for (var y = 0; y < my; y++) {
        final o = (z << 10) | (y << 5);
        v.fillRange(o, o + mx, u);
      }
    }
    return v;
  }

  /// Füllt den Quader [x0, x1) × [y0, y1) × [z0, z1) mit [w]; ganze Abschnitte werden einheitlich.
  void fuelle(int x0, int y0, int z0, int x1, int y1, int z1, int w) {
    if (w < 0 || w > 255) throw ArgumentError.value(w, 'w', 'Tafelindex 0..255');
    x0 = x0.clamp(0, breite);
    y0 = y0.clamp(0, tiefe);
    z0 = z0.clamp(0, hoehe);
    x1 = x1.clamp(0, breite);
    y1 = y1.clamp(0, tiefe);
    z1 = z1.clamp(0, hoehe);
    for (var cz = z0 >> _abschnittBits; cz <= (z1 - 1) >> _abschnittBits && z1 > z0; cz++) {
      for (var cy = y0 >> _abschnittBits; cy <= (y1 - 1) >> _abschnittBits && y1 > y0; cy++) {
        for (var cx = x0 >> _abschnittBits; cx <= (x1 - 1) >> _abschnittBits && x1 > x0; cx++) {
          final bx = cx << _abschnittBits, by = cy << _abschnittBits, bz = cz << _abschnittBits;
          // ganz: der Teil des Abschnitts, der im Körper liegt, wird vollständig gefüllt
          final ex = bx + kAbschnitt < breite ? bx + kAbschnitt : breite;
          final ey = by + kAbschnitt < tiefe ? by + kAbschnitt : tiefe;
          final ez = bz + kAbschnitt < hoehe ? bz + kAbschnitt : hoehe;
          final ganz = x0 <= bx && y0 <= by && z0 <= bz && x1 >= ex && y1 >= ey && z1 >= ez;
          if (ganz) {
            final a = _abschnittIndex(cx, cy, cz);
            _voll[a] = null;
            _einheitlich[a] = w;
            continue;
          }
          for (var z = z0 > bz ? z0 : bz; z < z1 && z < bz + kAbschnitt; z++) {
            for (var y = y0 > by ? y0 : by; y < y1 && y < by + kAbschnitt; y++) {
              for (var x = x0 > bx ? x0 : bx; x < x1 && x < bx + kAbschnitt; x++) {
                setze(x, y, z, w);
              }
            }
          }
        }
      }
    }
  }

  /// Zahl der belegten (nicht leeren) Blöcke.
  int get bloecke {
    var n = 0;
    for (var a = 0; a < _voll.length; a++) {
      final v = _voll[a];
      if (v == null) {
        if (_einheitlich[a] != 0) n += _belegtImAbschnitt(a);
        continue;
      }
      for (final b in v) {
        if (b != 0) n++;
      }
    }
    return n;
  }

  /// Belegte Blöcke eines einheitlichen Abschnitts (am Rand des Körpers abgeschnitten).
  int _belegtImAbschnitt(int a) {
    final cx = a % _ax, cy = (a ~/ _ax) % _ay, cz = a ~/ (_ax * _ay);
    int teil(int c, int groesse) => ((c + 1) << _abschnittBits) > groesse ? groesse - (c << _abschnittBits) : kAbschnitt;
    return teil(cx, breite) * teil(cy, tiefe) * teil(cz, hoehe);
  }

  /// Speicherbedarf der Blockdaten in Bytes (volle Abschnitte zu 32 KB, einheitliche zu 1 Byte).
  int get speicherBytes => _voll.whereType<Uint8List>().length * kAbschnitt * kAbschnitt * kAbschnitt + _einheitlich.length;

  /// Zahl der Abschnitte (x, y, z) – für das Speicherformat.
  (int, int, int) get abschnitte => (_ax, _ay, _az);

  /// Rohzugriff auf Abschnitt [a] (Index (cz · ay + cy) · ax + cx): volle Daten oder null und der
  /// einheitliche Wert. Nur für Speicherformat und Werkzeuge.
  (Uint8List?, int) abschnittRoh(int a) => (_voll[a], _einheitlich[a]);

  /// Setzt Abschnitt [a] roh: [voll] (32³ Werte, wird übernommen) oder einheitlich [wert].
  void setzeAbschnittRoh(int a, Uint8List? voll, int wert) {
    if (voll != null && voll.length != kAbschnitt * kAbschnitt * kAbschnitt) throw ArgumentError('Abschnitt braucht 32³ Werte');
    _voll[a] = voll;
    _einheitlich[a] = voll == null ? wert : 0;
  }

  /// Ruft [besuch] für jeden belegten Block auf (Reihenfolge: Abschnitte, darin z, y, x).
  void jederBlock(void Function(int x, int y, int z, int w) besuch) {
    for (var cz = 0; cz < _az; cz++) {
      for (var cy = 0; cy < _ay; cy++) {
        for (var cx = 0; cx < _ax; cx++) {
          final a = _abschnittIndex(cx, cy, cz);
          final v = _voll[a];
          final u = _einheitlich[a];
          if (v == null && u == 0) continue;
          final bx = cx << _abschnittBits, by = cy << _abschnittBits, bz = cz << _abschnittBits;
          for (var z = bz; z < bz + kAbschnitt && z < hoehe; z++) {
            for (var y = by; y < by + kAbschnitt && y < tiefe; y++) {
              for (var x = bx; x < bx + kAbschnitt && x < breite; x++) {
                final w = v == null ? u : v[((z & _abschnittMaske) << 10) | ((y & _abschnittMaske) << 5) | (x & _abschnittMaske)];
                if (w != 0) besuch(x, y, z, w);
              }
            }
          }
        }
      }
    }
  }
}
