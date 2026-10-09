/// Layout-Prüfsumme: kanonische Textform einer gebauten Welt und ihr FNV-1a-64-Hash.
/// Werkzeug: `tool/layout_pruefsumme.dart`. Die Form deckt Kartenlayout, Kacheln,
/// Begehbarkeit, Marken, Dinge (Türen, Stationen, Lichter, Objekte), Grundwerte,
/// Texturen sowie die Haus- und Bewohner-Zuordnung ab.
library;

import 'dart:convert';

import '../fall/stadtleben.dart';
import 'bereich.dart';

/// Kanonische Textform der Welt: Bereiche nach id sortiert; je Bereich Kopf, jede
/// Kartenzeile, Art und Begehbarkeit jeder Kachel, Marken (sortiert) und Dinge
/// (sortiert nach z0, x0, zeichen).
String kanonischeForm(Map<String, Bereich> welt) {
  final out = StringBuffer();
  for (final id in welt.keys.toList()..sort()) {
    final b = welt[id]!;
    out
      ..writeln('BEREICH ${b.id}')
      ..writeln('innen ${b.innen}')
      ..writeln('raumHoehe ${b.raumHoehe}')
      ..writeln('groesse ${b.breite}x${b.tiefe}')
      ..writeln('grund warm=${b.grundWarm} kalt=${b.grundKalt}')
      ..writeln('textur wand=${b.wandTextur} boden=${b.bodenTextur} decke=${b.deckenTextur}');
    for (var z = 0; z < b.tiefe; z++) {
      out.writeln('karte $z ${b.karte[z]}');
    }
    for (var z = 0; z < b.tiefe; z++) {
      for (var x = 0; x < b.breite; x++) {
        out.writeln('kachel $x $z art=${b.art(x, z).index} begehbar=${b.begehbar(x, z)}');
      }
    }
    for (final m in b.marken.keys.toList()..sort()) {
      final (x, z) = b.marken[m]!;
      out.writeln('marke $m $x $z');
    }
    final dinge = [...b.dinge]
      ..sort((a, c) {
        final z = a.z0.compareTo(c.z0);
        if (z != 0) return z;
        final x = a.x0.compareTo(c.x0);
        if (x != 0) return x;
        return a.zeichen.compareTo(c.zeichen);
      });
    for (final d in dinge) {
      final l = d.legende;
      out.writeln('ding ${jsonEncode({
            'zeichen': d.zeichen,
            'x0': d.x0,
            'z0': d.z0,
            'x1': d.x1,
            'z1': d.z1,
            'art': l.art.name,
            'form': l.form,
            'hoehe': l.hoehe,
            'ziel': l.ziel,
            'zielMarke': l.zielMarke,
            'verschlossen': l.verschlossen,
            'offenAbPhase': l.offenAbPhase,
            'station': l.station,
            'lichtWarm': l.lichtWarm,
            'lichtKalt': l.lichtKalt,
            'lichtWeite': l.lichtWeite,
          })}');
    }
  }
  return out.toString();
}

/// Haus- und Bewohner-Zuordnung, wie das Spiel sie nutzt: Innenraum eines Hauses über
/// die gemeinsame Marke vor der Tür (wie `Simulation._innenraumVon`); Bewohner mit
/// Wohnhaus, dessen Marke in der Stadt liegt. Sortiert nach Haus- bzw. Bewohner-id.
String kanonischeZuordnung(
  Map<String, Bereich> welt, {
  List<Map<String, dynamic>>? haeuser,
  required List<Map<String, dynamic>> bewohner,
}) {
  final out = StringBuffer();
  final stadt = welt['stadt'];
  final hausListe = [...?haeuser]..sort((a, c) => (a['id'] as String).compareTo(c['id'] as String));
  for (final h in hausListe) {
    final id = h['id'] as String;
    final vor = stadt?.marken['vor-$id'];
    String? innen;
    if (stadt != null && vor != null) {
      for (final k in stadt.marken.keys.toList()..sort()) {
        if (k.startsWith('tuer-') && stadt.marken[k] == vor && welt.containsKey(k.substring(5))) {
          innen = k.substring(5);
          break;
        }
      }
    }
    final vorText = vor == null ? '-' : '${vor.$1},${vor.$2}';
    out.writeln('haus $id viertel=${h['viertel'] ?? ''} vor=$vorText innen=${innen ?? '-'}');
  }
  final bewohnerListe = [for (final j in bewohner) Bewohner.ausJson(j)]..sort((a, c) => a.id.compareTo(c.id));
  for (final b in bewohnerListe) {
    final platziert = stadt != null && stadt.marken.containsKey('vor-${b.wohnhaus}');
    out.writeln('bewohner ${b.id} wohnhaus=${b.wohnhaus} arbeitshaus=${b.arbeitshaus} platziert=$platziert');
  }
  return out.toString();
}

/// FNV-1a 64 Bit über die UTF-8-Bytes von [text], als 16 Hex-Ziffern.
/// Rechnet mit `int` der Dart-VM (64 Bit, Überlauf umbrechend); auf dem Web nicht gültig.
String fnv1a64(String text) {
  var h = (0xcbf29ce4 << 32) | 0x84222325; // Offset-Basis 0xcbf29ce484222325
  for (final b in utf8.encode(text)) {
    h ^= b;
    h *= 0x100000001b3; // FNV-Primzahl
  }
  final hi = (h >> 32) & 0xffffffff, lo = h & 0xffffffff;
  return hi.toRadixString(16).padLeft(8, '0') + lo.toRadixString(16).padLeft(8, '0');
}
