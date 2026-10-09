import 'dart:math' as math;
import 'dart:typed_data';

import '../palette.dart';
import '../raster/renderer.dart' show SpriteImage;
import 'baker.dart';
import 'figur.dart';

/// Figurenkarten der Stadtbewohner aus ihrem Steckbrief (`bewohner.json`, Feld `aussehen`).
///
/// Verbindlich aus dem Datensatz: Name, Kleidungsstücke mit Farbe (Rampe/Stufe), Haarfarbe,
/// Frisur-Art, Kopfbedeckungs-Art, Zubehör. Frei gewählt (erfunden) werden nur Größe, Statur,
/// Hautton, die Variante von Frisur/Kopfbedeckung/Jacke/Rock, Bart, Schuhe und eine fehlende
/// Hose. [bewohnerKarte] erzeugt zu jeder Varianten-Nummer eine andere freie Wahl; das Werkzeug
/// `bin/bewohnerkarten.dart` nimmt je Figur die Variante, die allen anderen am wenigsten ähnelt.

/// Rampen nach Namen (FORMAT-FIGUREN.md).
const Map<String, int> kRampeNamen = {
  'neutral': 0,
  'stein': 1,
  'holz': 2,
  'rot': 3,
  'bernstein': 4,
  'grün': 5,
  'blau': 6,
  'haut': 7,
};

const _aussen = {'Mantel', 'Jacke', 'Kittel'};

/// Material der Figurenkarte, das die Farbe des Kleidungsstücks [teil] trägt (alle Teile der
/// Figur in [alle]). Ein Hemd unter Jacke, Mantel oder Kittel liegt auf `darunter`.
String kleidungsMaterial(String teil, Set<String> alle) {
  switch (teil) {
    case 'Mantel' || 'Jacke' || 'Kittel' || 'Pullover' || 'Kleid' || 'Bluse':
      return 'oberteil';
    case 'Hemd':
      return alle.any(_aussen.contains) ? 'darunter' : 'oberteil';
    case 'Weste':
      return 'weste';
    case 'Rock' || 'Hose' || 'Overall':
      return 'hose';
    case 'Schürze':
      return 'schuerze';
    case 'Umhang' || 'Schal':
      return 'schal';
  }
  throw ArgumentError('Kleidungsstück „$teil“ unbekannt');
}

/// Haarfarbe aus dem Steckbrief → Material (nie [0,1], das ist die Augenfarbe).
const Map<String, Material> kHaarfarben = {
  'grau': Material(0, 5),
  'weiß': Material(0, 6), // nicht reinweiß: ein weißer Haarkranz unter dem Hut wirkt wie ein Tuch (Sichtprüfung A-605h: B08)
  'braun': Material(2, 3),
  'rot': Material(3, 4),
  'blond': Material(4, 6),
  'schwarz': Material(0, 2),
};

const _frisurenM = {
  'kurz': ['frisur-kurz', 'frisur-kurz-seitenscheitel', 'frisur-kurz-wuschel', 'frisur-igel', 'frisur-nackenlang'],
  'lang': ['frisur-nackenlang', 'frisur-lang-glatt', 'frisur-undercut-lang'],
  'locken': ['frisur-locken-kurz', 'frisur-locken'],
  'kraus': ['frisur-kraus-kurz', 'frisur-locken-kurz'],
  'glatze': ['frisur-haarkranz', 'frisur-glatze-seiten'],
};
const _frisurenW = {
  'kurz': ['frisur-bob', 'frisur-kinnlang', 'frisur-pagenkopf', 'frisur-kurz-wuschel'],
  'lang': ['frisur-lang-glatt', 'frisur-lang-wellig', 'frisur-lang'],
  'locken': ['frisur-locken-lang', 'frisur-locken'],
  'kraus': ['frisur-kraus-kurz', 'frisur-locken-kurz'],
  'glatze': ['frisur-haarkranz', 'frisur-glatze-seiten'],
};
const _frisurenAlle = {
  'dutt': ['frisur-dutt', 'frisur-hochsteck', 'frisur-knoten-tief'],
  'zopf': ['frisur-zopf', 'frisur-zwei-zoepfe', 'frisur-zopf-kranz', 'frisur-pferdeschwanz'],
};

const _baerte = [null, null, 'bart-kurz', 'bart-schnurr', 'bart-voll', 'bart-walross', 'bart-kinnbart', 'bart-dreitage'];
const _kopfFarben = [Material(3, 3), Material(6, 3), Material(0, 3), Material(2, 2), Material(4, 4), Material(1, 3), Material(3, 5), Material(6, 4)];
// keine Bernstein-/Hauttöne: sonst wirkt die Haube wie blondes Haar
const _haubenFarben = [Material(0, 6), Material(6, 5), Material(1, 6), Material(3, 5)];
const _hosen = [Material(0, 2), Material(1, 3), Material(0, 3), Material(6, 3), Material(1, 2)];
const _hemden = [Material(0, 6), Material(4, 6), Material(6, 5), Material(0, 5), Material(1, 6)];
// kein Gold/Bernstein: Beiwerk in Gold wirkt wie ein Taler (K9 §8)
const _akzente = [Material(0, 5), Material(0, 6), Material(1, 5), Material(1, 4)];
const _taschen = [Material(1, 3), Material(2, 3), Material(3, 2), Material(6, 3)];

/// Schuhe der Bewohner: nie Schaftstiefel, nie braun (Wanderstiefel-Anmutung nur R03/R04).
const _schuhe = <(String?, Material)>[
  (null, Material(0, 2)),
  (null, Material(1, 2)),
  ('schuhe-arbeitsschuhe', Material(0, 2)),
  ('schuhe-arbeitsschuhe', Material(1, 3)),
  ('schuhe-gummistiefel', Material(6, 3)),
  (null, Material(3, 2)),
];

const _uniformBerufe = ['Pförtner', 'Ratsdiener', 'Briefträger', 'Wärter'];

/// Zubehör aus dem Steckbrief → Teil (nicht jedes Zubehör hat eine sichtbare Form).
/// Papier in der Hand wirkt wie ein Zettel, ein Licht in der Hand wie eine Stablampe
/// (beides K9 §8, Sichtprüfung A-605): Bücher und Mappen werden zur Umhängetasche,
/// Notizbuch und Laterne bleiben unsichtbar.
const Map<String, String> kZubehoerTeile = {
  'Taschenuhr': 'taschenuhr-kette',
  'Gehstock': 'gehstock',
  'Brille': 'brille',
  'Lesebrille': 'brille',
  'Regenschirm': 'regenschirm-zu',
  'Nähkorb': 'korb',
  'Häkelbeutel': 'korb',
  'Eimer': 'korb',
  'Gießkanne': 'korb',
  'Strickzeug': 'korb',
  'Arzttasche': 'werkzeugtasche',
  'Umhängetasche': 'umhaengetasche',
  'Aktenmappe': 'umhaengetasche',
  'Notenmappe': 'umhaengetasche',
  'Samtbeutel': 'umhaengetasche',
  'Hutschachtel': 'umhaengetasche',
  'Zange': 'guertel-tasche',
  'Abisolierzange': 'guertel-tasche',
  'Zollstock': 'guertel-tasche',
  'Winkelmaß': 'guertel-tasche',
  'Glasschneider': 'guertel-tasche',
  'Ahle': 'guertel-tasche',
  'Drechseleisen': 'guertel-tasche',
  'Falzbein': 'guertel-tasche',
  'Maßband': 'guertel-tasche',
  'Garnrolle': 'guertel-tasche',
  'Skizzenbuch': 'umhaengetasche',
  'Kassenbuch': 'umhaengetasche',
  'Aktenordner': 'umhaengetasche',
  'Klemmbrett': 'umhaengetasche',
  'Ladeliste': 'umhaengetasche',
};

class _Zufall {
  int _s;
  _Zufall(int seed) : _s = (seed * 2654435761 + 0x9E3779B9) & 0x7FFFFFFF;
  int naechste(int n) {
    _s = (_s * 1103515245 + 12345) & 0x7FFFFFFF;
    return (_s >> 8) % n;
  }

  T waehle<T>(List<T> l) => l[naechste(l.length)];
  double zwischen(double a, double b) => a + (b - a) * naechste(1001) / 1000;
}

/// Erlaubte Kleiderfarben je Kleidungsstück für die Umfärbung (nie Grün, nie Neutral 1 =
/// Augenfarbe, nie Blau 2 = Nebelfarbe).
List<(String, int)> erlaubteFarben(String teil) {
  if (teil == 'Kittel') return const [('neutral', 5), ('neutral', 6), ('blau', 4), ('blau', 5), ('stein', 5), ('stein', 6)];
  if (teil == 'Hose' || teil == 'Rock' || teil == 'Overall') {
    return const [('neutral', 2), ('neutral', 3), ('neutral', 4), ('stein', 2), ('stein', 3), ('stein', 4), ('holz', 2), ('holz', 3), ('holz', 4), ('blau', 3), ('blau', 4), ('rot', 2)];
  }
  return const [
    ('neutral', 3), ('neutral', 4), ('neutral', 5), ('neutral', 6), ('stein', 3), ('stein', 4), ('stein', 5),
    ('holz', 2), ('holz', 3), ('holz', 4), ('rot', 2), ('rot', 3), ('rot', 4), ('rot', 5),
    ('bernstein', 3), ('bernstein', 4), ('bernstein', 5), ('blau', 3), ('blau', 4), ('blau', 5), ('blau', 6),
  ];
}

/// Zufällige Umfärbung der Kleidung von [b] (für die Variantensuche des Werkzeugs):
/// Kleidungsstück → (Rampe, Stufe); zwei Stücke nie in derselben Rampe.
Map<String, (String, int)> umfaerbung(Map<String, dynamic> b, int variante) {
  final z = _Zufall((int.tryParse((b['id'] as String).substring(1)) ?? 0) * 6151 + variante * 3299 + 7);
  final out = <String, (String, int)>{};
  for (final k in (b['aussehen'] as Map)['kleidung'] as List) {
    final teil = (k as Map)['teil'] as String;
    final frei = [for (final f in erlaubteFarben(teil)) if (!out.values.any((o) => o.$1 == f.$1)) f];
    out[teil] = z.waehle(frei.isEmpty ? erlaubteFarben(teil) : frei);
  }
  return out;
}

/// Figurenkarte für den Bewohner [b] (Eintrag aus `bewohner.json`) in der freien Variante [variante];
/// [farben] überschreibt die Kleiderfarben (Kleidungsstück → (Rampe, Stufe)).
Figurenkarte bewohnerKarte(Map<String, dynamic> b, int variante, {Map<String, (String, int)>? farben}) {
  final id = b['id'] as String;
  final nr = int.tryParse(id.substring(1)) ?? 0;
  final z = _Zufall(nr * 7919 + variante * 104729);
  final a = b['aussehen'] as Map<String, dynamic>;
  final mann = b['geschlecht'] == 'm';
  final alter = (b['alter'] as num).toInt();
  final beruf = b['beruf'] as String? ?? '';
  final mats = <String, Material>{};
  final teile = <String>[];

  // Körper (erfunden)
  final groesse = (mann ? z.zwischen(1.66, 1.90) : z.zwischen(1.55, 1.76)) - (alter >= 75 ? 0.04 : 0);
  final breite = z.zwischen(0.86, 1.24);
  final kopf = z.zwischen(0.94, 1.06);
  mats['haut'] = Material(7, 3 + z.naechste(4));

  // Haar
  final haar = a['haar'] as String;
  final frisur = a['frisur'] as String;
  final hm = kHaarfarben[haar];
  if (hm != null) mats['haar'] = hm;
  if (haar == 'keins' || hm == null) {
    teile.add('frisur-glatze');
  } else {
    final liste = _frisurenAlle[frisur] ?? (mann ? _frisurenM : _frisurenW)[frisur] ?? const ['frisur-kurz'];
    teile.add(z.waehle(liste));
    if (mann && alter >= 25) {
      final bart = z.waehle(_baerte);
      if (bart != null) {
        teile.add(bart);
        mats['bart'] = hm;
      }
    }
  }

  // Kopfbedeckung
  switch (a['kopf'] as String?) {
    case 'mütze':
      teile.add(z.waehle(const ['kopf-muetze', 'kopf-wollmuetze-bommel', 'kopf-schiebermuetze']));
      mats['kopfbedeckung'] = z.waehle(_kopfFarben);
    case 'hut':
      teile.add(z.waehle(const ['kopf-hut', 'kopf-filzhut']));
      mats['kopfbedeckung'] = z.waehle(_kopfFarben);
    case 'haube':
      teile.add(beruf.contains('Bäck') ? 'kopf-haube-baeckerin' : 'kopf-haube');
      mats['kopfbedeckung'] = beruf.contains('Bäck') ? const Material(0, 7) : z.waehle(_haubenFarben);
  }

  // Kleidung (Farben verbindlich)
  final kleidung = [for (final k in a['kleidung'] as List) k as Map<String, dynamic>];
  final alle = {for (final k in kleidung) k['teil'] as String};
  for (final k in kleidung) {
    final teil = k['teil'] as String;
    final f = farben?[teil];
    final m = f != null ? Material(kRampeNamen[f.$1]!, f.$2) : Material(kRampeNamen[k['rampe']]!, (k['stufe'] as num).toInt());
    mats[kleidungsMaterial(teil, alle)] = m;
    switch (teil) {
      case 'Mantel':
        teile.add('oberteil-mantel');
      case 'Jacke':
        teile.add(_uniformBerufe.any(beruf.contains)
            ? 'oberteil-uniformjacke'
            : z.waehle(const ['oberteil-arbeitsjacke', 'oberteil-strickjacke']));
      case 'Kittel':
        teile.add('kittel-oberteil');
      case 'Pullover':
        teile.add('oberteil-strickpulli-rolli');
      case 'Bluse':
        teile.add('oberteil-bluse-rueschen');
        mats['darunter'] = m;
      case 'Hemd':
        teile.add('oberteil-hemdkragen');
        if (alle.any(_aussen.contains)) teile.add('hemd-ausschnitt');
        mats.putIfAbsent('darunter', () => m);
      case 'Weste':
        teile.add('oberteil-weste');
      case 'Kleid':
        teile.add('unterteil-kleid');
      case 'Rock':
        // Unter einem Mantel nur ein langer Rock sichtbar (sonst verdeckt, Sichtprüfung A-605: B16)
        teile.add(alle.contains('Mantel')
            ? 'rock-lang-weit'
            : (alter >= 55 ? z.waehle(const ['unterteil-rock', 'rock-lang-weit']) : 'unterteil-rock'));
      case 'Overall':
        teile.add('latz-vorn');
      case 'Schürze':
        teile.add('schuerze-vorn');
      case 'Umhang':
        teile.add('umhang-tuch');
      case 'Schal':
        teile.add('schal');
    }
  }
  // Weste ohne Hemd im Datensatz: Hemd darunter (erfunden)
  if (!mats.containsKey('oberteil')) mats['oberteil'] = z.waehle(_hemden);
  // Hemd unter Jacke/Mantel/Kittel: Kragen in Hemdfarbe (oben gesetzt), sonst hell
  if (!mats.containsKey('darunter')) mats['darunter'] = const Material(0, 6);
  // Fehlende Hose (erfunden), nie gleich dem Oberteil
  if (!mats.containsKey('hose') && !alle.contains('Kleid')) {
    final ober = mats['oberteil'];
    final frei = [for (final h in _hosen) if (ober == null || h.rampe != ober.rampe || h.stufe != ober.stufe) h];
    mats['hose'] = z.waehle(frei);
  }
  // Schuhe (erfunden): nie Schaftstiefel, nie braun
  final (schuhTeil, schuhFarbe) = z.waehle(_schuhe);
  if (schuhTeil != null) teile.add(schuhTeil);
  mats['schuhe'] = schuhFarbe;
  mats['akzent'] = z.waehle(_akzente);
  mats['tasche'] = z.waehle(_taschen);
  if (alle.contains('Kleid') || alle.contains('Rock')) mats['strumpf'] = mats['haut']!;

  // Zubehör (eine Hand je Teil; doppelte weglassen)
  for (final s in a['zubehoer'] as List? ?? const []) {
    final t = kZubehoerTeile[s];
    if (t != null && !teile.contains(t)) teile.add(t);
  }
  return Figurenkarte(
    id: id,
    name: b['name'] as String,
    groesse: (groesse * 100).round() / 100,
    breite: (breite * 100).round() / 100,
    kopf: (kopf * 100).round() / 100,
    materialien: mats,
    teile: teile,
  );
}

/// Statur-Klassen der Rollen (`rollen.json`, Feld `statur`, erfunden) → Spanne des Breitenfaktors.
const Map<String, (double, double)> kStaturBreite = {
  'schmal': (0.86, 0.95),
  'normal': (0.96, 1.06),
  'kräftig': (1.10, 1.24),
};

/// Hosenfarben für Rollen, deren Hosenfarbe im Kanon nicht festliegt (`rollen.json`, „erfunden“).
List<Material> rollenHosen(String typ) => typ == 'jeans'
    ? const [Material(6, 3), Material(6, 4), Material(6, 5), Material(1, 4), Material(0, 3), Material(1, 3), Material(0, 5)]
    : const [Material(0, 2), Material(0, 3), Material(1, 2), Material(1, 3), Material(1, 4), Material(2, 2), Material(2, 3), Material(2, 4), Material(6, 3)];

/// Variante einer Rollenkarte: Kanon-Farben, Kleidung und Größe bleiben; frei sind nur die
/// Breite innerhalb der Statur-Klasse, die Kopfgröße (±6 %) und – ab Variante 8, falls
/// [hosen] angegeben (erfundene Hosenfarbe) – die Hosenfarbe. Variante 0 = unverändert.
Figurenkarte rollenVariante(Figurenkarte k, String statur, int variante, {List<Material>? hosen}) {
  if (variante == 0) return k;
  final nr = int.tryParse(k.id.substring(1)) ?? 0;
  final z = _Zufall(nr * 3571 + variante * 7727 + 99);
  final (b0, b1) = kStaturBreite[statur] ?? (0.9, 1.15);
  final breite = (z.zwischen(b0, b1) * 100).round() / 100, kopf = (z.zwischen(0.94, 1.06) * 100).round() / 100;
  final mats = hosen != null && variante >= 8 && k.materialien.containsKey('hose')
      ? {...k.materialien, 'hose': z.waehle(hosen)}
      : k.materialien;
  return Figurenkarte(id: k.id, name: k.name, groesse: k.groesse, breite: breite, kopf: kopf, materialien: mats, teile: k.teile);
}

/// Karte als JSON (eine Zeile, Format von `karten.json`).
Map<String, dynamic> karteAlsJson(Figurenkarte k) => {
      'id': k.id,
      'name': k.name,
      'groesse': k.groesse,
      'breite': k.breite,
      'kopf': k.kopf,
      'materialien': {for (final e in k.materialien.entries) e.key: [e.value.rampe, e.value.stufe]},
      'teile': k.teile,
    };

/// Sichtvergleich zweier Figuren nach dem Maß der Sichtprüfer (A-605): Silhouetten-Überlappung
/// (IoU) vorne und seitlich, Farbabstand je Zone vorne (Haar/Kopfbedeckung, Gesicht, Oberkörper,
/// Hüfte, Beine) – Menschen unterscheiden Figuren gerade an Haar, Hut und Oberteil.
/// Obere Grenzen der Farbzonen als Anteil der Figurenhöhe (von oben).
const kZonen = [0.0, 0.10, 0.20, 0.45, 0.62];

class Figurenbild {
  final List<SpriteImage> ansichten; // vorne, seitlich
  late final List<Uint32List> _masken = [for (final s in ansichten) _maske(s)];
  late final List<int> _flaechen = [for (final m in _masken) _bits(m)];
  late final List<List<double>> _zonen = _zonenFarben(ansichten.first);
  late final List<double> _koerperHisto = _histogramm(ansichten.first);
  late final Uint32List _form = _formMaske(ansichten.first);

  /// Häufigste Farbe in der Körpermitte oben (Rumpf) und unten (Beine) und die Höhe in
  /// Pixeln – so vergleichen Sichtprüfer Figuren auf Abstand (A-605j).
  late final (int, int, int) _mitte = _mitteFarben(ansichten.first);

  static (int, int, int) _mitteFarben(SpriteImage s) {
    var y0 = s.height, y1 = -1, sx = 0, n = 0;
    for (var i = 0; i < s.pixels.length; i++) {
      if (s.pixels[i] == kTransparent) continue;
      final y = i ~/ s.width;
      if (y < y0) y0 = y;
      if (y > y1) y1 = y;
      sx += i % s.width;
      n++;
    }
    if (n == 0) return (-1, -1, 0);
    final h = y1 - y0 + 1, cx = sx ~/ n;
    int haeufigste(double von, double bis) {
      final zaehl = <int, int>{};
      for (var y = y0 + (h * von).round(); y <= y0 + (h * bis).round(); y++) {
        for (var x = cx - 2; x <= cx + 2; x++) {
          if (x < 0 || x >= s.width || y < 0 || y >= s.height) continue;
          final p = s.pixels[y * s.width + x];
          if (p != kTransparent) zaehl[p] = (zaehl[p] ?? 0) + 1;
        }
      }
      var best = -1, bestN = 0;
      zaehl.forEach((p, c) {
        if (c > bestN) {
          best = p;
          bestN = c;
        }
      });
      return best;
    }

    return (haeufigste(0.28, 0.45), haeufigste(0.62, 0.85), h);
  }

  /// Häufigste Farbklasse am Körper (Hauptfarbe der Kleidung).
  late final int _hauptfarbe = () {
    var best = 0;
    for (var i = 1; i < _koerperHisto.length; i++) {
      if (_koerperHisto[i] > _koerperHisto[best]) best = i;
    }
    return best;
  }();
  late final int _formFlaeche = _bits(_form);

  Figurenbild(this.ansichten);

  factory Figurenbild.backe(FigurBaker baker, Figurenkarte k) {
    final stehen = kAnimationen['stehen']!.first;
    return Figurenbild([baker.backeEinzel(k, stehen, 0), baker.backeEinzel(k, stehen, 2)]);
  }

  static Uint32List _maske(SpriteImage s) {
    final m = Uint32List((s.pixels.length + 31) >> 5);
    for (var i = 0; i < s.pixels.length; i++) {
      if (s.pixels[i] != kTransparent) m[i >> 5] |= 1 << (i & 31);
    }
    return m;
  }

  static final Uint8List _zaehl16 = () {
    final t = Uint8List(65536);
    for (var i = 1; i < 65536; i++) {
      t[i] = (i & 1) + t[i >> 1];
    }
    return t;
  }();

  static int _bits(Uint32List m) {
    var n = 0;
    for (final w in m) {
      n += _zaehl16[w & 0xFFFF] + _zaehl16[w >> 16];
    }
    return n;
  }

  /// Silhouette vorne auf 32 Zeilen Höhe normiert (gleiches Seitenverhältnis, mittig am
  /// Fußpunkt): vergleicht die Form unabhängig von der Körpergröße.
  static Uint32List _formMaske(SpriteImage s) {
    var y0 = s.height, y1 = 0;
    for (var i = 0; i < s.pixels.length; i++) {
      if (s.pixels[i] == kTransparent) continue;
      final y = i ~/ s.width;
      y0 = math.min(y0, y);
      y1 = math.max(y1, y);
    }
    final h = math.max(1, y1 - y0 + 1);
    final m = Uint32List(32);
    for (var gy = 0; gy < 32; gy++) {
      final sy = y0 + (gy + 0.5) * h / 32;
      for (var gx = 0; gx < 32; gx++) {
        final sx = s.footX + (gx - 16 + 0.5) * h / 32;
        final ix = sx.floor(), iy = sy.floor();
        if (ix < 0 || ix >= s.width || iy < 0 || iy >= s.height) continue;
        if (s.pixels[iy * s.width + ix] != kTransparent) m[gy] |= 1 << gx;
      }
    }
    return m;
  }

  /// Anteile der Farbklassen (Grau = Neutral+Stein, sonst je Rampe; × drei Helligkeiten)
  /// im Körper (unterhalb der Kopfzonen), vorne.
  static List<double> _histogramm(SpriteImage s) {
    var y0 = s.height, y1 = 0;
    for (var i = 0; i < s.pixels.length; i++) {
      if (s.pixels[i] == kTransparent) continue;
      final y = i ~/ s.width;
      y0 = math.min(y0, y);
      y1 = math.max(y1, y);
    }
    final ab = y0 + (y1 - y0 + 1) * kZonen[2];
    final h = List<double>.filled(24, 0);
    var n = 0;
    for (var y = ab.ceil(); y <= y1; y++) {
      for (var x = 0; x < s.width; x++) {
        final p = s.pixels[y * s.width + x];
        if (p == kTransparent || (p & 7) <= 1) continue; // Kontur und tiefste Schatten zählen nicht
        final rampe = p >> 3 == 1 ? 0 : p >> 3; // Stein zählt als Grau wie Neutral
        h[rampe * 3 + ((p & 7) >= 6 ? 2 : ((p & 7) >= 4 ? 1 : 0))]++;
        n++;
      }
    }
    return [for (final v in h) n == 0 ? 0 : v / n];
  }

  static List<List<double>> _zonenFarben(SpriteImage s) {
    var y0 = s.height, y1 = 0;
    for (var y = 0; y < s.height; y++) {
      for (var x = 0; x < s.width; x++) {
        if (s.pixels[y * s.width + x] != kTransparent) {
          y0 = math.min(y0, y);
          y1 = math.max(y1, y);
        }
      }
    }
    final h = math.max(1, y1 - y0 + 1);
    // Zonen: Haar/Kopfbedeckung, Gesicht, Oberkörper, Hüfte/Hände, Beine
    final grenzen = [for (final f in kZonen) y0 + h * f, y1 + 1.0];
    final out = <List<double>>[];
    for (var zone = 0; zone < kZonen.length; zone++) {
      var r = 0.0, g = 0.0, b = 0.0, n = 0;
      for (var y = grenzen[zone].ceil(); y < grenzen[zone + 1]; y++) {
        for (var x = 0; x < s.width; x++) {
          final p = s.pixels[y * s.width + x];
          if (p == kTransparent) continue;
          r += paletteR(p);
          g += paletteG(p);
          b += paletteB(p);
          n++;
        }
      }
      out.add(n == 0 ? [0, 0, 0] : [r / n, g / n, b / n]);
    }
    return out;
  }
}

class Aehnlichkeit {
  /// Mittlere Silhouetten-Überlappung (vorne, seitlich), 0…1.
  final double iou;

  /// Größter Farbabstand (RGB, euklidisch) der Zonen ([kZonen]).
  final double farbe;

  /// Überlappung der Körperfarben (Rampe × Helligkeit), 0…1 – gleiche Kleidung bei
  /// anderem Kopf werteten die Sichtprüfer als hohe Verwechslungsgefahr.
  final double koerper;

  /// Überlappung der höhennormierten Silhouetten vorne (Form unabhängig von der Größe).
  final double form;

  /// Gleiche Hauptfarbe der Kleidung (häufigste Farbklasse am Körper).
  final bool hauptfarbeGleich;

  /// Gleiche Farbe in der Körpermitte oben und unten (Rampe gleich, Stufe ±1) bei fast
  /// gleicher Höhe (±3 Pixel) – auf Abstand das stärkste Verwechslungszeichen (A-605j).
  final bool mitteGleich;
  const Aehnlichkeit(this.iou, this.farbe, this.koerper, this.form, this.hauptfarbeGleich, [this.mitteGleich = false]);

  /// Verwechselbar im Sinne der Sichtprüfung: fast gleiche Silhouette und kein deutlicher
  /// Farbunterschied – oder ähnliche Silhouette mit gleichfarbigem Körper.
  /// (Gleiche Hauptfarbe allein macht noch nicht verwechselbar, wirkt aber in [wert] als
  /// Druck auf die Variantenwahl.)
  bool get verwechselbar => (iou >= 0.84 && farbe <= 46) || (math.max(iou, form) >= 0.80 && koerper >= 0.62);

  /// Je größer, desto ähnlicher (für die Variantenwahl).
  double get wert => math.max(iou, form) + 0.5 * koerper + (hauptfarbeGleich ? 0.3 : 0) + (mitteGleich ? 0.5 : 0) - farbe / 160;

  @override
  String toString() =>
      'IoU ${iou.toStringAsFixed(2)} · Farbabstand ${farbe.toStringAsFixed(0)} · Körper gleich ${(koerper * 100).round()} % · Form ${form.toStringAsFixed(2)}${hauptfarbeGleich ? ' · gleiche Hauptfarbe' : ''}${mitteGleich ? ' · gleiche Körpermitte' : ''}';
}

Aehnlichkeit vergleiche(Figurenbild a, Figurenbild b) {
  var iou = 0.0;
  for (var v = 0; v < a.ansichten.length; v++) {
    final ma = a._masken[v], mb = b._masken[v];
    var schnitt = 0;
    for (var i = 0; i < ma.length && i < mb.length; i++) {
      final w = ma[i] & mb[i];
      schnitt += Figurenbild._zaehl16[w & 0xFFFF] + Figurenbild._zaehl16[w >> 16];
    }
    final vereint = a._flaechen[v] + b._flaechen[v] - schnitt;
    iou += vereint == 0 ? 1 : schnitt / vereint;
  }
  iou /= a.ansichten.length;
  var farbe = 0.0;
  for (var zone = 0; zone < kZonen.length; zone++) {
    final p = a._zonen[zone], q = b._zonen[zone];
    final d = math.sqrt((p[0] - q[0]) * (p[0] - q[0]) + (p[1] - q[1]) * (p[1] - q[1]) + (p[2] - q[2]) * (p[2] - q[2]));
    farbe = math.max(farbe, d);
  }
  var koerper = 0.0;
  for (var i = 0; i < a._koerperHisto.length; i++) {
    koerper += math.min(a._koerperHisto[i], b._koerperHisto[i]);
  }
  var schnitt = 0;
  for (var i = 0; i < 32; i++) {
    final w = a._form[i] & b._form[i];
    schnitt += Figurenbild._zaehl16[w & 0xFFFF] + Figurenbild._zaehl16[w >> 16];
  }
  final vereint = a._formFlaeche + b._formFlaeche - schnitt;
  bool nah(int p, int q) => p >= 0 && q >= 0 && p ~/ 8 == q ~/ 8 && (p % 8 - q % 8).abs() <= 1;
  final (ao, au, ah) = a._mitte;
  final (bo, bu, bh) = b._mitte;
  final mitte = nah(ao, bo) && nah(au, bu) && (ah - bh).abs() <= 3;
  return Aehnlichkeit(iou, farbe, koerper, vereint == 0 ? 1 : schnitt / vereint, a._hauptfarbe == b._hauptfarbe, mitte);
}
