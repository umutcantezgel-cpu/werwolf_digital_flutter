import 'package:pixel_engine/pixel_engine.dart';

/// Sprechblasen über den Figuren (Burgstadt HD, P7-AUTOR-04, HZ-11).
///
/// Reine Funktionen ohne Zeichnen: [ordneBlasen] wählt je Blase einen Platz aus festen
/// Kandidaten, [hudSperren] nennt die HUD-Flächen, die keine Blase verdecken darf.
/// Gezeichnet wird in `bildschirme/erkundung.dart`.

/// Abstand zwischen zwei Blasen (Pixel).
const kBlasenAbstand = 2;

/// Mindestabstand jeder Blase zum Bildrand (Pixel).
const kBildRand = 2;

/// Höhe des Zipfels (Pixel).
const kZipfelHoehe = 3;

/// Der Zipfel erscheint nur, wenn der Kopfpunkt seitlich höchstens so weit neben der Blase liegt (Pixel).
const kZipfelSeitlich = 20;

/// Kopfpunkt eines Sprechers in UI-Pixeln und Maße seiner Blase (mit Innenrand).
class BlasenWunsch {
  final double sx, sy;
  final int breite, hoehe;
  const BlasenWunsch(this.sx, this.sy, this.breite, this.hoehe);
}

/// Seite der Blase, an der der Zipfel sitzt.
enum Zipfel { keiner, unten, oben }

/// Zipfel einer Blase auf [r]: an der dem Kopf zugewandten Kante, nur wenn der Kopfpunkt
/// seitlich höchstens [kZipfelSeitlich] px neben der Blase liegt. Liegt die Blase über dem
/// Kopf, zeigt der Zipfel nach unten, sonst nach oben.
Zipfel zipfelVon(BlasenWunsch wunsch, Rechteck r) {
  if (wunsch.sx < r.x - kZipfelSeitlich || wunsch.sx > r.rechts + kZipfelSeitlich) return Zipfel.keiner;
  if (r.unten <= wunsch.sy) return Zipfel.unten;
  if (r.y >= wunsch.sy) return Zipfel.oben;
  return Zipfel.keiner;
}

/// Fläche, die eine Blase belegt: Körper, Zipfel und der 1 px breite Schlagschatten rechts und unten.
Rechteck blasenFlaeche(Rechteck r, Zipfel z) {
  final oben = z == Zipfel.oben ? kZipfelHoehe : 0;
  final unten = z == Zipfel.unten ? kZipfelHoehe : 0;
  return Rechteck(r.x, r.y - oben, r.w + 1, r.h + oben + unten + 1);
}

/// Knöpfe rechts (Aktion, Licht, Blick, Akte, Menü), untereinander am unteren Rand.
List<Rechteck> knopfSpalte(int w, int h) {
  final bw = h > w ? 56 : 48, bh = h > w ? 24 : 17;
  final by = h - (bh + 4) * 5 - 4;
  return [for (var i = 0; i < 5; i++) Rechteck(w - bw - 4, by + i * (bh + 4), bw, bh)];
}

/// Kompass draußen: quer oben in der Mitte, hochkant unten in der Mitte.
Rechteck kompassRechteck(int w, int h) {
  const kb = 120;
  return Rechteck((w - kb) ~/ 2, h > w ? h - 22 : 2, kb, 14);
}

/// Ortsplakette oben rechts: Fläche hinter dem Ortsnamen der Breite [ow].
Rechteck ortsPlakette(int w, int ow, int fh) => Rechteck(w - ow - 7, 1, ow + 6, fh + 3);

/// Zeitzeile oben links: Text der Breite [zw] mit 1 px Schatten.
Rechteck zeitZeile(int zw, int fh) => Rechteck(4, 3, zw + 1, fh + 1);

/// HUD-Flächen, die keine Sprechblase verdecken darf: Knopfspalte (mit Schlagschatten),
/// Kompass (nur draußen), Ortsplakette oben rechts und Zeitzeile oben links.
List<Rechteck> hudSperren(
  BitmapFont font,
  int w,
  int h, {
  required bool draussen,
  required String ort,
  required String zeit,
}) {
  final fh = font.height;
  return [
    for (final k in knopfSpalte(w, h)) Rechteck(k.x, k.y, k.w + 1, k.h + 1),
    if (draussen) kompassRechteck(w, h),
    ortsPlakette(w, font.measure(ort), fh),
    zeitZeile(font.measure(zeit), fh),
  ];
}

/// Platz je Blase, Reihenfolge = Priorität (nächster Sprecher zuerst). Feste Kandidaten:
/// zentriert über dem Kopf, dann nach oben verschoben (über Hindernissen), dann links und
/// rechts versetzt (±bw/2), dann unter dem Kopf, zuletzt die vier Bildecken. Jede Blase
/// liegt mit Zipfel und Schatten im Bild (mit [kBildRand]), berührt keine Fläche aus
/// [gesperrt] und hält [kBlasenAbstand] zu den schon platzierten Blasen. `null`: kein Platz.
List<Rechteck?> ordneBlasen(List<BlasenWunsch> wuensche, int w, int h, List<Rechteck> gesperrt) {
  final belegt = <Rechteck>[]; // belegte Flächen der bereits platzierten Blasen
  final platz = <Rechteck?>[];
  for (final wunsch in wuensche) {
    final r = _platz(wunsch, w, h, gesperrt, belegt);
    platz.add(r);
    if (r != null) belegt.add(blasenFlaeche(r, zipfelVon(wunsch, r)));
  }
  return platz;
}

/// Die vier Bildecken als Blasenkörper mit Randabstand: oben links, oben rechts, unten links, unten rechts.
List<Rechteck> eckPlaetze(int w, int h, int bw, int bh) => [
      Rechteck(kBildRand, kBildRand, bw, bh),
      Rechteck(w - kBildRand - 1 - bw, kBildRand, bw, bh),
      Rechteck(kBildRand, h - kBildRand - kZipfelHoehe - 1 - bh, bw, bh),
      Rechteck(w - kBildRand - 1 - bw, h - kBildRand - kZipfelHoehe - 1 - bh, bw, bh),
    ];

Rechteck? _platz(BlasenWunsch wunsch, int w, int h, List<Rechteck> gesperrt, List<Rechteck> belegt) {
  for (final k in _kandidaten(wunsch, w, h, [...gesperrt, ...belegt])) {
    final f = blasenFlaeche(k, zipfelVon(wunsch, k));
    if (!_imBild(f, w, h)) continue;
    if (gesperrt.any((g) => _ueberlappt(f, g, 0))) continue;
    if (belegt.any((b) => _ueberlappt(f, b, kBlasenAbstand))) continue;
    return k;
  }
  return null;
}

List<Rechteck> _kandidaten(BlasenWunsch wunsch, int w, int h, List<Rechteck> hindernisse) {
  final bw = wunsch.breite, bh = wunsch.hoehe;
  // über dem Kopf (Zipfel nach unten) und unter dem Kopf (Zipfel nach oben)
  final ueber = wunsch.sy.floor() - kZipfelHoehe - bh;
  final unter = wunsch.sy.ceil() + kZipfelHoehe;
  // horizontal: zentriert, dann um ±bw/2 versetzt (Kopf am rechten bzw. linken Rand)
  final xs = [(wunsch.sx - bw / 2).round(), (wunsch.sx - bw).round(), wunsch.sx.round()];
  // Oberkanten, die mit Zipfel und Abstand auf einem Hindernis stehen, nächste zuerst
  final hoch = <int>{
    for (final o in hindernisse)
      if (o.y - bh - 6 < ueber) o.y - bh - 6,
  }.toList()
    ..sort((a, b) => b.compareTo(a));
  final kandidaten = <Rechteck>[];
  for (final x in xs) {
    kandidaten.add(Rechteck(x, ueber, bw, bh));
    for (final y in hoch) {
      kandidaten.add(Rechteck(x, y, bw, bh));
    }
  }
  for (final x in xs) {
    kandidaten.add(Rechteck(x, unter, bw, bh));
  }
  final ecken = eckPlaetze(w, h, bw, bh)..sort((a, b) => _abstand(a, wunsch).compareTo(_abstand(b, wunsch)));
  kandidaten.addAll(ecken);
  return kandidaten;
}

double _abstand(Rechteck r, BlasenWunsch wunsch) {
  final dx = r.x + r.w / 2 - wunsch.sx, dy = r.y + r.h / 2 - wunsch.sy;
  return dx * dx + dy * dy;
}

/// Überlappen zweier Flächen; [abstand] vergrößert `a` nach allen Seiten (0 = echte Überlappung).
bool _ueberlappt(Rechteck a, Rechteck b, int abstand) =>
    a.x < b.rechts + abstand && b.x < a.rechts + abstand && a.y < b.unten + abstand && b.y < a.unten + abstand;

bool _imBild(Rechteck f, int w, int h) =>
    f.x >= kBildRand && f.y >= kBildRand && f.rechts <= w - kBildRand && f.unten <= h - kBildRand;
