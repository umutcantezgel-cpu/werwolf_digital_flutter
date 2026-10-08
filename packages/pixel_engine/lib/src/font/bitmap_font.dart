import 'dart:typed_data';

import '../pixel_buffer.dart';

/// Bitmap-Pixelschrift aus einem Text-Raster (Format: `FORMAT-SCHRIFT.md`).
///
/// Jede Glyphe hat [height] Zeilen (Standard 11): Zeilen 0–1 Akzentraum über
/// Großbuchstaben, [capTop]–[baseline] Großbuchstaben (7 Zeilen), [xTop]–[baseline]
/// Kleinbuchstaben, darunter Unterlängen.
class BitmapFont {
  final int height;
  final int capTop;
  final int xTop;
  final int baseline;
  final int spacing;
  final Map<int, Glyph> glyphs;

  BitmapFont._(this.height, this.capTop, this.xTop, this.baseline, this.spacing, this.glyphs);

  /// Zeichen, die jede Spielschrift haben muss (ASCII + Deutsch + Kanon-Sonderzeichen).
  static final String requiredChars = '${String.fromCharCodes([for (var c = 0x20; c <= 0x7E; c++) c])}'
      'ÄÖÜäöüß°·¼½¾×éêóÉÓĆćğńŞşŽž–—‚‘’“„«»…€→←↑↓▶◀✓✗•';

  factory BitmapFont.parse(String src) {
    var height = 11, capTop = 2, xTop = 4, baseline = 8, spacing = 1;
    final glyphs = <int, Glyph>{};
    final lines = src.split('\n');
    var i = 0;
    while (i < lines.length) {
      final line = lines[i].trimRight();
      i++;
      if (line.isEmpty || line.startsWith('#!')) continue;
      final parts = line.split(' ');
      switch (parts[0]) {
        case 'hoehe':
          height = int.parse(parts[1]);
        case 'oberlinie':
          capTop = int.parse(parts[1]);
        case 'x-hoehe':
          xTop = int.parse(parts[1]);
        case 'grundlinie':
          baseline = int.parse(parts[1]);
        case 'abstand':
          spacing = int.parse(parts[1]);
        case 'zeichen':
          final name = line.substring(8);
          final cp = name == 'leer' ? 0x20 : name.runes.first;
          if (name != 'leer' && name.runes.length != 1) {
            throw FormatException('Zeile $i: „zeichen“ braucht genau ein Zeichen, nicht „$name“');
          }
          final rows = <String>[];
          for (var r = 0; r < height; r++) {
            if (i >= lines.length) throw FormatException('Glyphe „$name“: zu wenige Zeilen');
            rows.add(lines[i].trimRight());
            i++;
          }
          final w = rows.first.length;
          for (final r in rows) {
            if (r.length != w || r.replaceAll(RegExp(r'[.#]'), '').isNotEmpty) {
              throw FormatException('Glyphe „$name“: Zeile „$r“ ungültig (nur . und #, gleiche Breite)');
            }
          }
          final bits = Uint8List(w * height);
          for (var y = 0; y < height; y++) {
            for (var x = 0; x < w; x++) {
              bits[y * w + x] = rows[y].codeUnitAt(x) == 0x23 ? 1 : 0;
            }
          }
          if (glyphs.containsKey(cp)) throw FormatException('Glyphe „$name“ doppelt');
          glyphs[cp] = Glyph(cp, w, height, bits);
        default:
          throw FormatException('Zeile $i: unbekannt „$line“');
      }
    }
    return BitmapFont._(height, capTop, xTop, baseline, spacing, glyphs);
  }

  /// Prüft die Schrift; leere Liste = in Ordnung.
  List<String> validate({String? required}) {
    final out = <String>[];
    for (final r in (required ?? requiredChars).runes) {
      if (!glyphs.containsKey(r)) out.add('fehlt: „${String.fromCharCode(r)}“ (U+${r.toRadixString(16).toUpperCase().padLeft(4, '0')})');
    }
    const descenders = 'gjpqyçşğ,;';
    const tall = 'ÄÖÜÉÓĆŞŽ'; // Großbuchstaben mit Akzent dürfen in Zeilen 0–1
    for (final g in glyphs.values) {
      final ch = String.fromCharCode(g.codePoint);
      if (g.width < 1 || g.width > 9) out.add('„$ch“: Breite ${g.width} außerhalb 1–9');
      final inkRows = <int>{for (var y = 0; y < height; y++) if (g.rowHasInk(y)) y};
      if (g.codePoint != 0x20 && inkRows.isEmpty) out.add('„$ch“: leer');
      final isAsciiLetter = RegExp(r'^[A-Za-z0-9]$').hasMatch(ch);
      if (isAsciiLetter && inkRows.any((y) => y < capTop)) out.add('„$ch“: Tinte im Akzentraum (Zeile < $capTop)');
      if (RegExp(r'^[A-Z0-9]$').hasMatch(ch) && inkRows.any((y) => y > baseline)) out.add('„$ch“: Großbuchstabe/Ziffer unter der Grundlinie');
      if (RegExp(r'^[a-z]$').hasMatch(ch) && !descenders.contains(ch) && inkRows.any((y) => y > baseline)) {
        out.add('„$ch“: Unterlänge ohne Grund');
      }
      if (descenders.contains(ch) && RegExp(r'^[a-z]$').hasMatch(ch) && !inkRows.any((y) => y > baseline)) {
        out.add('„$ch“: Unterlänge fehlt');
      }
      if (RegExp(r'^[acemnorsuvwxz]$').hasMatch(ch) && inkRows.any((y) => y < xTop)) out.add('„$ch“: ragt über die x-Höhe');
      if (tall.contains(ch) && !inkRows.any((y) => y < capTop)) out.add('„$ch“: Akzent fehlt über dem Großbuchstaben');
    }
    return out;
  }

  Glyph? glyphFor(int cp) => glyphs[cp] ?? glyphs[0x3F]; // „?“ als Ersatz

  int measure(String text) {
    var w = 0;
    var first = true;
    for (final r in text.runes) {
      final g = glyphFor(r);
      if (g == null) continue;
      if (!first) w += spacing;
      w += g.width;
      first = false;
    }
    return w;
  }

  /// Zeichnet [text] ab (x, y = Oberkante der Glyphenzelle) in Farbe [color];
  /// optional mit 1-px-Schatten unten rechts. [scale] vergrößert ganzzahlig.
  /// Gibt die Breite zurück.
  int draw(PixelBuffer fb, String text, int x, int y, int color, {int? shadow, int scale = 1}) {
    var cx = x;
    var first = true;
    for (final r in text.runes) {
      final g = glyphFor(r);
      if (g == null) continue;
      if (!first) cx += spacing * scale;
      if (shadow != null) _blit(fb, g, cx + scale, y + scale, shadow, scale);
      _blit(fb, g, cx, y, color, scale);
      cx += g.width * scale;
      first = false;
    }
    return cx - x;
  }

  void _blit(PixelBuffer fb, Glyph g, int x0, int y0, int color, int s) {
    final w = fb.width, h = fb.height, col = fb.color;
    for (var gy = 0; gy < g.height; gy++) {
      for (var gx = 0; gx < g.width; gx++) {
        if (g.bits[gy * g.width + gx] == 0) continue;
        for (var sy = 0; sy < s; sy++) {
          final py = y0 + gy * s + sy;
          if (py < 0 || py >= h) continue;
          for (var sx = 0; sx < s; sx++) {
            final px = x0 + gx * s + sx;
            if (px < 0 || px >= w) continue;
            col[py * w + px] = color;
          }
        }
      }
    }
  }

  /// Bricht [text] in Zeilen mit höchstens [maxWidth] Pixeln um (an Leerzeichen;
  /// überlange Wörter werden hart getrennt). `\n` erzwingt einen Umbruch.
  List<String> wrap(String text, int maxWidth) {
    final out = <String>[];
    for (final para in text.split('\n')) {
      var line = '';
      for (final word in para.split(' ')) {
        final cand = line.isEmpty ? word : '$line $word';
        if (measure(cand) <= maxWidth) {
          line = cand;
          continue;
        }
        if (line.isNotEmpty) out.add(line);
        line = word;
        while (measure(line) > maxWidth && line.length > 1) {
          var cut = line.length - 1;
          while (cut > 1 && measure(line.substring(0, cut)) > maxWidth) {
            cut--;
          }
          out.add(line.substring(0, cut));
          line = line.substring(cut);
        }
      }
      out.add(line);
    }
    return out;
  }
}

class Glyph {
  final int codePoint;
  final int width;
  final int height;
  final Uint8List bits;
  Glyph(this.codePoint, this.width, this.height, this.bits);

  bool rowHasInk(int y) {
    for (var x = 0; x < width; x++) {
      if (bits[y * width + x] != 0) return true;
    }
    return false;
  }
}
