import 'dart:math' as math;

import 'bereich.dart';

/// Spurenarten des Detektivblicks (Z-05: mindestens sieben).
enum SpurArt { fussspur, wachs, faser, staub, fingerabdruck, schleifspur, verwischt }

/// Eine Spur in der Welt, sichtbar nur in einer Sichtschicht (z. B. Detektivblick).
/// Lage in Metern; [hoehe] 0 = am Boden, sonst an einer Fläche (Wand/Möbel) mit
/// Blickrichtung [drehung] (Radiant, Normale der Fläche in der xz-Ebene).
class Spur {
  final SpurArt art;
  final String bereich;
  final double x, z, hoehe, drehung;
  final String beschreibung;
  final String? station; // zugehörige Station (Hinweis beim Untersuchen)
  final int abPhase;
  final Set<String> sicht; // Sichtschichten, die sie zeigen ('detektiv', Rollen-IDs …)

  const Spur(this.art, this.bereich, this.x, this.z, this.beschreibung,
      {this.hoehe = 0, this.drehung = 0, this.station, this.abPhase = 1, this.sicht = const {'detektiv'}});
}

/// Spuren in der Burg – nur, was die öffentlichen Beschreibungen (BSO-*) und
/// Detektiv-Beobachtungen hergeben; keine Deutung, keine Lösung.
List<Spur> burgSpuren(Map<String, Bereich> welt) {
  final out = <Spur>[];
  (double, double)? station(String bereich, String id) {
    final d = welt[bereich]?.dinge.where((d) => d.legende.station == id).firstOrNull;
    return d == null ? null : (d.mitteX, d.mitteZ);
  }

  // BSO-01: Wachsspritzer neben der Eisentür, Absatzabdruck mit Stollenprofil, Spitze zur Eisentür (Norden)
  final w = station('speisekammer', 'BS-01');
  if (w != null) {
    for (final (dx, dz) in const [(-0.18, 0.1), (0.12, -0.05), (0.2, 0.18), (-0.05, 0.22)]) {
      out.add(Spur(SpurArt.wachs, 'speisekammer', w.$1 + dx, w.$2 + dz, 'Erstarrte Wachsspritzer', station: 'BS-01'));
    }
    out.add(Spur(SpurArt.fussspur, 'speisekammer', w.$1 + 0.02, w.$2 + 0.05, 'Absatzabdruck mit Stollenprofil, Spitze zur Eisentür',
        drehung: -math.pi / 2, station: 'BS-01'));
  }
  // BSO-09: Kerzenständer am Boden: Wachs am Fuß, Griff sauber
  final k = station('speisekammer', 'BS-09');
  if (k != null) {
    out.add(Spur(SpurArt.wachs, 'speisekammer', k.$1 - 0.1, k.$2, 'Wachs am Fuß des Kerzenständers', station: 'BS-09'));
  }
  // Eichentür (Speisekammer-Seite): Schleifspur – die Tür war von innen verkeilt (DET-B4)
  final sk = welt['speisekammer'];
  final eiche = sk?.dinge.where((d) => d.legende.art == KachelArt.tuer && d.legende.ziel == 'gewoelbe').firstOrNull;
  if (eiche != null) {
    out.add(Spur(SpurArt.schleifspur, 'speisekammer', (eiche.x1 + 1) * kKachel + 0.35, eiche.mitteZ, 'Schleifspur am Boden vor der Eichentür',
        drehung: 0));
  }
  // BSO-02: Leinenfaser am rechten Panzerhandschuh von Kunibert
  final kun = welt['absatz']?.dinge.where((d) => d.legende.station == 'Kunibert').firstOrNull;
  if (kun != null) {
    out.add(Spur(SpurArt.faser, 'absatz', kun.x0 * kKachel - 0.02, kun.mitteZ + 0.15, 'Weiße Leinenfaser am Panzerhandschuh',
        hoehe: 0.95, drehung: math.pi, station: 'Kunibert'));
  }
  // DET-B6: Rojda stand am offenen Sicherungskasten – Abdrücke am Hebel
  final kasten = welt['turmfuss']?.dinge.where((d) => d.legende.name.startsWith('Sicherungskasten')).firstOrNull;
  if (kasten != null) {
    out.add(Spur(SpurArt.fingerabdruck, 'turmfuss', kasten.x0 * kKachel - 0.02, kasten.mitteZ, 'Frische Fingerabdrücke am Haupthebel',
        hoehe: 1.35, drehung: math.pi, station: 'BS-04'));
  }
  // BSO-06 (ab Phase 2): Staub auf dem Truhendeckel aufgewirbelt
  final truhe = welt['turmfuss']?.dinge.where((d) => d.legende.station == 'BS-06').firstOrNull;
  if (truhe != null) {
    out.add(Spur(SpurArt.staub, 'turmfuss', truhe.mitteX, truhe.mitteZ, 'Staub auf dem Truhendeckel ist verwischt – frisch geöffnet',
        hoehe: truhe.legende.hoehe + 0.01, abPhase: 2, station: 'BS-06'));
  }
  // BSO-11: Raureif im Hof – Stiefelspuren Kellerhals ↔ Torhaus ↔ Hoftür; zwei frischere Spuren zum Tor; vor dem Tor unberührt
  final hof = welt['hof'];
  if (hof != null) {
    (double, double)? tuer(String ziel) {
      final d = hof.dinge.where((d) => d.legende.art == KachelArt.tuer && d.legende.ziel == ziel).firstOrNull;
      return d == null ? null : (d.mitteX, d.mitteZ);
    }

    final torhaus = hof.dinge.where((d) => d.legende.form == 'haus').firstOrNull;
    final kellerhals = tuer('gewoelbe'), hoftuer = tuer('hofebene'), tor = tuer('stadt');
    void pfad((double, double)? a, (double, double)? b, String text, {double versatz = 0}) {
      if (a == null || b == null) return;
      final dx = b.$1 - a.$1, dz = b.$2 - a.$2;
      final len = math.sqrt(dx * dx + dz * dz);
      final n = (len / 0.7).floor();
      final ang = math.atan2(dz, dx);
      for (var i = 1; i < n; i++) {
        final t = i / n;
        final seite = i.isEven ? 0.12 : -0.12;
        out.add(Spur(SpurArt.fussspur, 'hof', a.$1 + dx * t - math.sin(ang) * (seite + versatz), a.$2 + dz * t + math.cos(ang) * (seite + versatz),
            text, drehung: ang, station: 'BS-11'));
      }
    }

    final th = torhaus == null ? null : (torhaus.x0 * kKachel - 0.3, torhaus.mitteZ);
    pfad(kellerhals, th, 'Stiefelspur im Raureif (Kellerhals – Torhaus)');
    pfad(th, hoftuer, 'Stiefelspur im Raureif (Torhaus – Hoftür)');
    if (tor != null) {
      final vorTor = (tor.$1, tor.$2 - 1.2);
      pfad(kellerhals, vorTor, 'Frischere Spuren von zwei Personen zum Tor', versatz: 0.35);
      pfad(kellerhals, vorTor, 'Frischere Spuren von zwei Personen zum Tor', versatz: -0.35);
    }
  }
  return out;
}
