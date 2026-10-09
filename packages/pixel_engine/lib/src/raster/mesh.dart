import 'dart:math' as math;
import 'dart:typed_data';

/// Einheitliche Texel-Dichte für Welt und Figuren (Texel pro Meter).
const double kTexelsPerMeter = 32;

/// Statische Geometrie: Dreiecke mit Texturkoordinaten (in Texeln) und
/// Vertex-Licht (warm/kalt, je 0..1). Welttexel-Dichte: [kTexelsPerMeter].
class Mesh {
  final Float32List pos; // x,y,z je Vertex
  final Float32List uv; // u,v je Vertex (Texel)
  final Float32List light; // warm, kalt je Vertex
  final Uint32List tri; // 3 Indizes je Dreieck
  final Uint16List tex; // Textur-ID je Dreieck
  final Uint8List flags; // je Dreieck: 1 = beidseitig
  // Begrenzungskugel
  final double bx, by, bz, br;

  Mesh._(this.pos, this.uv, this.light, this.tri, this.tex, this.flags, this.bx, this.by, this.bz, this.br);

  int get vertexCount => pos.length ~/ 3;
  int get triangleCount => tri.length ~/ 3;
}

/// Baut ein [Mesh] Stück für Stück.
class MeshBuilder {
  final _pos = <double>[];
  final _uv = <double>[];
  final _light = <double>[];
  final _tri = <int>[];
  final _tex = <int>[];
  final _flags = <int>[];

  int get vertexCount => _pos.length ~/ 3;
  int get triangleCount => _tri.length ~/ 3;

  int vertex(double x, double y, double z, double u, double v, {double warm = 0, double cold = 0}) {
    _pos..add(x)..add(y)..add(z);
    _uv..add(u)..add(v);
    _light..add(warm)..add(cold);
    return vertexCount - 1;
  }

  void triangle(int a, int b, int c, int texture, {bool doubleSided = false}) {
    _tri..add(a)..add(b)..add(c);
    _tex.add(texture);
    _flags.add(doubleSided ? 1 : 0);
  }

  /// Viereck a-b-c-d (gegen den Uhrzeigersinn von der sichtbaren Seite aus).
  void quad(int a, int b, int c, int d, int texture, {bool doubleSided = false}) {
    triangle(a, b, c, texture, doubleSided: doubleSided);
    triangle(a, c, d, texture, doubleSided: doubleSided);
  }

  /// Senkrechte Wand von (x0,z0) nach (x1,z1), Unterkante y0, Oberkante y1.
  /// Sichtbar von der rechten Seite in Laufrichtung (Normale = links→rechts gedreht).
  /// Texel-Dichte [kTexelsPerMeter]; [u0]/[v0] verschieben die Textur.
  void wall(double x0, double z0, double x1, double z1, double y0, double y1, int texture,
      {double warm = 0, double cold = 0, double u0 = 0, double v0 = 0, bool doubleSided = false,
      double warmTop = -1, double coldTop = -1}) {
    final len = _len(x1 - x0, z1 - z0);
    final wt = warmTop < 0 ? warm : warmTop, ct = coldTop < 0 ? cold : coldTop;
    final a = vertex(x0, y0, z0, u0, v0 + (y1 - y0) * kTexelsPerMeter, warm: warm, cold: cold);
    final b = vertex(x1, y0, z1, u0 + len * kTexelsPerMeter, v0 + (y1 - y0) * kTexelsPerMeter, warm: warm, cold: cold);
    final c = vertex(x1, y1, z1, u0 + len * kTexelsPerMeter, v0, warm: wt, cold: ct);
    final d = vertex(x0, y1, z0, u0, v0, warm: wt, cold: ct);
    quad(a, b, c, d, texture, doubleSided: doubleSided);
  }

  /// Waagrechte Fläche (Boden, Decke) als Rechteck in Kacheln von [step] Metern
  /// (kleine Dreiecke halten Nebel/Mip/Licht stabil). [up] = sichtbar von oben.
  void floor(double x0, double z0, double x1, double z1, double y, int texture,
      {double warm = 0, double cold = 0, bool up = true, double step = 2,
      double Function(double x, double z)? warmAt, double Function(double x, double z)? coldAt}) {
    for (var zz = z0; zz < z1 - 1e-6; zz += step) {
      final zb = zz + step > z1 ? z1 : zz + step;
      for (var xx = x0; xx < x1 - 1e-6; xx += step) {
        final xb = xx + step > x1 ? x1 : xx + step;
        double w(double x, double z) => warmAt == null ? warm : warmAt(x, z);
        double c(double x, double z) => coldAt == null ? cold : coldAt(x, z);
        final a = vertex(xx, y, zz, xx * kTexelsPerMeter, zz * kTexelsPerMeter, warm: w(xx, zz), cold: c(xx, zz));
        final b = vertex(xb, y, zz, xb * kTexelsPerMeter, zz * kTexelsPerMeter, warm: w(xb, zz), cold: c(xb, zz));
        final cc = vertex(xb, y, zb, xb * kTexelsPerMeter, zb * kTexelsPerMeter, warm: w(xb, zb), cold: c(xb, zb));
        final d = vertex(xx, y, zb, xx * kTexelsPerMeter, zb * kTexelsPerMeter, warm: w(xx, zb), cold: c(xx, zb));
        if (up) {
          quad(a, d, cc, b, texture);
        } else {
          quad(a, b, cc, d, texture);
        }
      }
    }
  }

  /// Quader (Kiste, Tisch, Haus-Grundkörper) mit Textur je Seite.
  void box(double x0, double y0, double z0, double x1, double y1, double z1, int texSide,
      {int? texTop, double warm = 0, double cold = 0, bool bottom = false}) {
    wall(x0, z1, x1, z1, y0, y1, texSide, warm: warm, cold: cold); // Süden
    wall(x1, z1, x1, z0, y0, y1, texSide, warm: warm, cold: cold); // Osten
    wall(x1, z0, x0, z0, y0, y1, texSide, warm: warm, cold: cold); // Norden
    wall(x0, z0, x0, z1, y0, y1, texSide, warm: warm, cold: cold); // Westen
    floor(x0, z0, x1, z1, y1, texTop ?? texSide, warm: warm, cold: cold, step: 4);
    if (bottom) floor(x0, z0, x1, z1, y0, texTop ?? texSide, warm: warm, cold: cold, up: false, step: 4);
  }

  Mesh build() {
    var minX = double.infinity, minY = double.infinity, minZ = double.infinity;
    var maxX = -double.infinity, maxY = -double.infinity, maxZ = -double.infinity;
    for (var i = 0; i < _pos.length; i += 3) {
      final x = _pos[i], y = _pos[i + 1], z = _pos[i + 2];
      if (x < minX) minX = x;
      if (y < minY) minY = y;
      if (z < minZ) minZ = z;
      if (x > maxX) maxX = x;
      if (y > maxY) maxY = y;
      if (z > maxZ) maxZ = z;
    }
    final cx = (minX + maxX) / 2, cy = (minY + maxY) / 2, cz = (minZ + maxZ) / 2;
    final r = _len3(maxX - cx, maxY - cy, maxZ - cz);
    return Mesh._(
      Float32List.fromList(_pos),
      Float32List.fromList(_uv),
      Float32List.fromList(_light),
      Uint32List.fromList(_tri),
      Uint16List.fromList(_tex),
      Uint8List.fromList(_flags),
      cx, cy, cz, r.isFinite ? r : 0,
    );
  }

  static double _len(double a, double b) => math.sqrt(a * a + b * b);
  static double _len3(double a, double b, double c) => math.sqrt(a * a + b * b + c * c);
}
