// Kontaktbogen (P0-AUTOR-02, HZ-04/05/07): beschriftete Probebilder für Texturen und
// Meshes, damit Prüfer Stil, Kachelbarkeit und Mip-Lesbarkeit beurteilen können.
//
// Aufruf aus packages/burgstadt_spiel:
//   dart run bin/kontaktbogen.dart texturen <ausgabe.png> [name1,name2,…] [--zoom N]
//   dart run bin/kontaktbogen.dart texturen-licht <ausgabe.png> [namen] [--zoom N]
//   dart run bin/kontaktbogen.dart bereich <bereich-id> <ausgabe.png>
//
// Jeder Lauf endet mit „KONTAKTBOGEN <modus> · <n> Zellen · Palette OK“ bzw.
// „… · PALETTE FEHLER <n>“ (Exit 1). Geprüft wird, ob jeder Palettenindex unter
// paletteRgb.length liegt, und die RGBA-Fassung des PNG gegen die Palette.

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

const _nutzung = 'Aufruf (aus packages/burgstadt_spiel):\n'
    '  dart run bin/kontaktbogen.dart texturen <ausgabe.png> [name1,name2,…] [--zoom N]\n'
    '  dart run bin/kontaktbogen.dart texturen-licht <ausgabe.png> [namen] [--zoom N]\n'
    '  dart run bin/kontaktbogen.dart bereich <bereich-id> <ausgabe.png>';

/// Lichtlage einer Zelle: Warm- und Kaltlicht je 0..1, Nebelstufe 0..3 (Index der LightTable).
class _Lage {
  const _Lage(this.name, this.warm, this.kalt, this.nebel);
  final String name;
  final double warm;
  final double kalt;
  final int nebel;
}

const _lichtlagen = [
  _Lage('kalt 0,3', 0, 0.3, 0),
  _Lage('warm 0,6', 0.6, 0, 0),
  _Lage('Nebel 2', 0, 0, 2),
];

/// Eine Zelle des Rasters: Textur, Beschriftungszeilen und optionale Lichtlage.
class _Zelle {
  _Zelle(this.tex, this.zeilen, this.lage);
  final IndexedTexture tex;
  final List<String> zeilen;
  final _Lage? lage;
}

void main(List<String> args) {
  var zoom = 2;
  final pos = <String>[];
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--zoom') {
      final wert = i + 1 < args.length ? int.tryParse(args[i + 1]) : null;
      if (wert == null || wert < 1) _abbruch('--zoom braucht eine ganze Zahl ab 1');
      zoom = wert;
      i++;
    } else {
      pos.add(args[i]);
    }
  }
  if (pos.isEmpty) _abbruch('Modus fehlt');
  switch (pos[0]) {
    case 'texturen':
      _texturen(pos, zoom, licht: false);
    case 'texturen-licht':
      _texturen(pos, zoom, licht: true);
    case 'bereich':
      _bereich(pos);
    case 'kandidaten':
      _kandidaten(pos, zoom);
    default:
      _abbruch('unbekannter Modus „${pos[0]}“');
  }
}

/// Texturen (Mip 0 oben, Mip 1 darunter, je 2×2 gekachelt) mit Namen; mit [licht]
/// zusätzlich je drei Lichtlagen in einer Zeile.
void _texturen(List<String> pos, int zoom, {required bool licht}) {
  if (pos.length < 2 || pos.length > 3) _abbruch('Ausgabedatei fehlt oder zu viele Argumente');
  final alle = baueAlleTexturen();
  final namen = pos.length == 3
      ? pos[2].split(',').map((n) => n.trim()).where((n) => n.isNotEmpty)
      : TexturId.values.map((t) => t.name);
  final ids = TexturId.values.asNameMap();
  final gewaehlt = <TexturId>[];
  for (final n in namen) {
    final id = ids[n];
    if (id == null) _abbruch('unbekannte Textur „$n“ (Namen wie im Enum TexturId)');
    gewaehlt.add(id);
  }
  if (gewaehlt.isEmpty) _abbruch('keine Textur gewählt');
  final tafel = licht ? LightTable.nacht : null;
  final zellen = <_Zelle>[];
  for (final id in gewaehlt) {
    if (!licht) {
      zellen.add(_Zelle(alle[id.index], [id.name], null));
      continue;
    }
    zellen.add(_Zelle(alle[id.index], [id.name, 'ohne Licht'], null));
    for (final lage in _lichtlagen) {
      zellen.add(_Zelle(alle[id.index], [id.name, lage.name], lage));
    }
  }
  final spalten = licht ? 4 : math.max(1, math.sqrt(zellen.length).ceil());
  final bild = _raster(zellen, spalten, zoom, tafel);
  _fertig(licht ? 'texturen-licht' : 'texturen', bild, zellen.length, pos[1]);
}

/// Textur-Kandidaten (kit/texturen/kandidaten.dart) in Weltdichte neben ihrer Bestandstextur
/// (Name bis zum letzten „_“), je mit Befunden der Stilblatt-Prüfung; Befunde auch auf stdout.
void _kandidaten(List<String> pos, int zoom) {
  if (pos.length < 2 || pos.length > 3) _abbruch('Ausgabedatei fehlt oder zu viele Argumente');
  final namen = pos.length == 3
      ? pos[2].split(',').map((n) => n.trim()).where((n) => n.isNotEmpty).toList()
      : kTexturKandidaten.keys.toList();
  if (namen.isEmpty) _abbruch('keine Kandidaten eingetragen');
  final ids = TexturId.values.asNameMap();
  final zellen = <_Zelle>[];
  final gezeigt = <String>{};
  var befundeGesamt = 0;
  for (final n in namen) {
    final e = kTexturKandidaten[n];
    if (e == null) _abbruch('unbekannter Kandidat „$n“ (siehe kit/texturen/kandidaten.dart)');
    final basis = n.contains('_') ? n.substring(0, n.lastIndexOf('_')) : n;
    final id = ids[basis];
    if (id != null && gezeigt.add(basis)) zellen.add(_Zelle(baueWeltTextur(id), [basis, 'Bestand'], null));
    final t = e.bauer();
    final befunde = pruefeHdTextur(n, t);
    befundeGesamt += befunde.length;
    stdout.writeln('KANDIDAT $n · ${t.width}×${t.height} · ${befunde.isEmpty ? 'Stilblatt OK' : '${befunde.length} Befunde: ${befunde.join('; ')}'}');
    zellen.add(_Zelle(t, [n, befunde.isEmpty ? 'Stilblatt OK' : '${befunde.length} Befunde'], null));
  }
  final spalten = math.max(1, math.sqrt(zellen.length).ceil());
  final bild = _raster(zellen, spalten, zoom, null);
  _fertig('kandidaten', bild, zellen.length, pos[1]);
  if (befundeGesamt > 0) exitCode = 1;
}

/// Ein Bereich aus drei Blickwinkeln (Bereichsfotos-Aufbau über ladeAusRepo).
void _bereich(List<String> pos) {
  if (pos.length != 3) _abbruch('Bereich-id und Ausgabedatei nötig');
  final spiel = Spiel();
  ladeAusRepo(spiel);
  final id = pos[1];
  final bereich = spiel.stadt.bereiche[id];
  if (bereich == null) _abbruch('unbekannter Bereich „$id“');
  final meshes = spiel.geometrie(id).meshes;
  final bild = rendereMeshBlicke(meshes, spiel.texturen,
      titel: '$id · ${meshes.length} Meshes', innen: bereich.innen);
  _fertig('bereich', bild, 3, pos[2]);
}

/// Rendert [meshes] aus drei Blickwinkeln (von Süden, Südosten, Osten) nebeneinander.
/// Die Kamera steht außerhalb des Bounding-Rechtecks der Meshes auf 1,62 m Höhe und
/// schaut zur Mitte. Öffentlich, damit Bauteile und Formen dasselbe Bild bekommen.
PixelBuffer rendereMeshBlicke(
  List<Mesh> meshes,
  List<IndexedTexture> texturen, {
  String titel = '',
  bool innen = true,
  int bildBreite = 320,
  int bildHoehe = 180,
}) {
  final font = BitmapFont.parse(kSchriftNormal);
  final tafel = LightTable.nacht;
  var x0 = double.infinity, z0 = double.infinity, x1 = -double.infinity, z1 = -double.infinity;
  for (final m in meshes) {
    final p = m.pos;
    for (var i = 0; i < p.length; i += 3) {
      x0 = math.min(x0, p[i]);
      z0 = math.min(z0, p[i + 2]);
      x1 = math.max(x1, p[i]);
      z1 = math.max(z1, p[i + 2]);
    }
  }
  if (!x0.isFinite) {
    x0 = 0;
    z0 = 0;
    x1 = 1;
    z1 = 1;
  }
  final cx = (x0 + x1) / 2, cz = (z0 + z1) / 2;
  final diagonale = math.sqrt((x1 - x0) * (x1 - x0) + (z1 - z0) * (z1 - z0));
  const abstand = 2.0; // Meter außerhalb des Rechtecks
  final ansichten = <(String, double, double)>[
    ('von Süden', cx, z1 + abstand),
    ('von Südosten', x1 + abstand, z1 + abstand),
    ('von Osten', x1 + abstand, cz),
  ];
  const rand = 6, zwischen = 6;
  final zeile = font.height + 2;
  final oben = rand + (titel.isEmpty ? 0 : zeile) + 2;
  final bild = PixelBuffer(
    2 * rand + 3 * (bildBreite + 2) + 2 * zwischen,
    oben + bildHoehe + 2 + 4 + zeile + rand,
  )..clear(Pal.black);
  if (titel.isNotEmpty) font.draw(bild, titel, rand, rand, Pal.parchment, shadow: Pal.black);
  for (var i = 0; i < ansichten.length; i++) {
    final (name, kx, kz) = ansichten[i];
    final ansicht = _ansicht(meshes, tafel, texturen, kx, kz, cx, cz, innen, bildBreite, bildHoehe,
        diagonale + 2 * abstand);
    final rx = rand + i * (bildBreite + 2 + zwischen);
    _rahmen(bild, rx, oben, bildBreite + 2, bildHoehe + 2);
    bild.blit(ansicht, rx + 1, oben + 1);
    font.draw(bild, name, rx + (bildBreite - font.measure(name)) ~/ 2, oben + bildHoehe + 2 + 4,
        Pal.parchment, shadow: Pal.black);
  }
  return bild;
}

/// Eine Ansicht: Kamera bei ([x], 1,62, [z]), Blick auf ([cx], [cz]).
PixelBuffer _ansicht(List<Mesh> meshes, LightTable tafel, List<IndexedTexture> texturen, double x,
    double z, double cx, double cz, bool innen, int w, int h, double ferne) {
  final fb = PixelBuffer(w, h);
  final r = Renderer(fb, tafel, texturen);
  r.camera
    ..x = x
    ..y = 1.62
    ..z = z
    ..yaw = math.atan2(cz - z, cx - x)
    ..pitch = 0
    ..far = math.max(48.0, ferne + 4);
  r.fogStart = innen ? 3.0 : 8.0;
  r.fogEnd = innen ? 20.0 : 46.0;
  r.groundFog = innen ? 0.0 : 0.25;
  r.begin();
  if (innen) {
    fb.clear(Pal.black);
  } else {
    r.drawSky();
  }
  for (final m in meshes) {
    r.drawMesh(m);
  }
  return fb;
}

/// Raster aus Zellen: je Zelle Mip 0 (2×2), darunter Mip 1 (2×2, halb so groß), darunter
/// die Beschriftung. Hintergrund Pal.black, Rahmen Pal.darkGrey.
PixelBuffer _raster(List<_Zelle> zellen, int spalten, int zoom, LightTable? tafel) {
  final font = BitmapFont.parse(kSchriftNormal);
  final zeilenH = font.height + 2;
  final nMax = zellen.map((z) => z.tex.widths[0]).reduce(math.max);
  final zeilenMax = zellen.map((z) => z.zeilen.length).reduce(math.max);
  final beschriftungMax = [for (final z in zellen) for (final s in z.zeilen) font.measure(s)].reduce(math.max);
  const rand = 8, pad = 6, luft = 4, abstand = 8;
  final mip0 = 2 * nMax * zoom, mip1 = nMax * zoom;
  final zellenB = math.max(mip0, beschriftungMax) + 2 * pad;
  final zellenH = pad + mip0 + luft + mip1 + luft + zeilenMax * zeilenH + pad;
  final reihen = (zellen.length + spalten - 1) ~/ spalten;
  final bild = PixelBuffer(
    2 * rand + spalten * zellenB + (spalten - 1) * abstand,
    2 * rand + reihen * zellenH + (reihen - 1) * abstand,
  )..clear(Pal.black);
  for (var i = 0; i < zellen.length; i++) {
    final z = zellen[i];
    final x = rand + (i % spalten) * (zellenB + abstand);
    final y = rand + (i ~/ spalten) * (zellenH + abstand);
    _rahmen(bild, x, y, zellenB, zellenH);
    final b0 = 2 * z.tex.widths[0] * zoom, b1 = 2 * z.tex.widths[1] * zoom;
    _kachel(bild, z.tex, 0, x + (zellenB - b0) ~/ 2, y + pad, zoom, z.lage, tafel);
    _kachel(bild, z.tex, 1, x + (zellenB - b1) ~/ 2, y + pad + mip0 + luft, zoom, z.lage, tafel);
    final ly = y + pad + mip0 + luft + mip1 + luft;
    for (var j = 0; j < z.zeilen.length; j++) {
      final s = z.zeilen[j];
      font.draw(bild, s, x + (zellenB - font.measure(s)) ~/ 2, ly + j * zeilenH, Pal.parchment,
          shadow: Pal.black);
    }
  }
  return bild;
}

/// Kachelt Mip-Stufe [stufe] der Textur 2×2 und vergrößert jeden Texel um [zoom].
/// Mit Lichtlage wird jeder Palettenindex über die LightTable umgefärbt.
void _kachel(PixelBuffer b, IndexedTexture tex, int stufe, int x0, int y0, int zoom, _Lage? lage,
    LightTable? tafel) {
  final w = tex.widths[stufe], h = tex.heights[stufe], px = tex.levels[stufe];
  for (var ty = 0; ty < 2 * h; ty++) {
    for (var tx = 0; tx < 2 * w; tx++) {
      var c = px[(ty % h) * w + tx % w];
      if (c == kTransparent) continue;
      if (lage != null && tafel != null && c < paletteRgb.length) {
        c = tafel.lookup(c, _stufe(lage.warm), _stufe(lage.kalt), lage.nebel);
      }
      b.fillRect(x0 + tx * zoom, y0 + ty * zoom, zoom, zoom, c);
    }
  }
}

/// Lichtwert 0..1 als Stufe 0..7 der LightTable (dieselbe Abbildung wie der Renderer, ohne Dither).
int _stufe(double licht) => LightTable.levelLut[(licht * 1024).round()].round();

void _rahmen(PixelBuffer b, int x, int y, int w, int h) {
  b.fillRect(x, y, w, 1, Pal.darkGrey);
  b.fillRect(x, y + h - 1, w, 1, Pal.darkGrey);
  b.fillRect(x, y, 1, h, Pal.darkGrey);
  b.fillRect(x + w - 1, y, 1, h, Pal.darkGrey);
}

/// Palettenprüfung: Pixel mit Index ≥ paletteRgb.length plus Pixel der RGBA-Fassung,
/// deren Farbe nicht in der Palette liegt.
int _verstoesse(PixelBuffer b, Uint8List rgba) {
  var n = countOffPalette(rgba);
  for (final c in b.color) {
    if (c >= paletteRgb.length) n++;
  }
  return n;
}

void _fertig(String modus, PixelBuffer bild, int zellen, String pfad) {
  final rgba = bild.toRgbaBytes();
  final fehler = _verstoesse(bild, rgba);
  final datei = File(pfad);
  datei.parent.createSync(recursive: true);
  datei.writeAsBytesSync(encodePngRgba(bild.width, bild.height, rgba, zlib: zlib.encode));
  if (fehler == 0) {
    stdout.writeln('KONTAKTBOGEN $modus · $zellen Zellen · Palette OK');
  } else {
    stdout.writeln('KONTAKTBOGEN $modus · $zellen Zellen · PALETTE FEHLER $fehler');
    exitCode = 1;
  }
}

Never _abbruch(String meldung) {
  stderr.writeln('$meldung\n$_nutzung');
  exit(2);
}
