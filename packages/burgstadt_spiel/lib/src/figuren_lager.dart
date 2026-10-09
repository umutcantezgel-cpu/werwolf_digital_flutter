import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

/// Figurenkarte aus einem Aussehen-Steckbrief (rollen.json, Auftrag A-601a).
/// Übergang, bis die vollständigen Figurenkarten (karten.json) vorliegen.
Figurenkarte karteAusSteckbrief(Map<String, dynamic> s) {
  Material m(Map<String, dynamic>? x, Material ersatz) =>
      x == null ? ersatz : Material((x['rampe'] as num?)?.toInt() ?? ersatz.rampe, (x['stufe'] as num?)?.toInt() ?? ersatz.stufe);
  final haar = s['haar'] as Map<String, dynamic>? ?? const {};
  final ober = s['oberteil'] as Map<String, dynamic>? ?? const {};
  final drunter = s['darunter'] as Map<String, dynamic>?;
  final unter = s['unterteil'] as Map<String, dynamic>? ?? const {};
  final schuhe = s['schuhe'] as Map<String, dynamic>? ?? const {};
  final teile = <String>[];
  teile.add(switch (haar['frisur']) {
    'kurz-locken' => 'frisur-locken',
    'schulterlang' || 'schulterlang-spange' => 'frisur-schulterlang',
    'lang-offen' => 'frisur-lang',
    'zopf' => 'frisur-zopf',
    'dutt' => 'frisur-dutt',
    'pferdeschwanz' => 'frisur-pferdeschwanz',
    'glatze' => 'frisur-glatze',
    'stoppel' => 'frisur-stoppel',
    _ => 'frisur-kurz',
  });
  switch (haar['bart']) {
    case 'voll':
      teile.add('bart-voll');
    case 'kurz' || 'stoppel':
      teile.add('bart-kurz');
    case 'schnurrbart':
      teile.add('bart-schnurr');
  }
  final typ = ober['typ'] as String? ?? '';
  final mats = <String, Material>{
    'haut': Material(7, (s['haut'] as num?)?.toInt() ?? 5),
    'haar': m(haar, const Material(2, 3)),
    'hose': m(unter, const Material(6, 2)),
    'schuhe': m(schuhe, const Material(0, 2)),
  };
  final oberM = m(ober, const Material(0, 4));
  final drunterM = drunter == null || drunter['typ'] == 'keins' ? oberM : m(drunter, const Material(0, 6));
  if (typ.startsWith('weste')) {
    teile.add('oberteil-weste');
    mats['weste'] = oberM;
    mats['oberteil'] = drunterM;
  } else {
    mats['oberteil'] = oberM;
    mats['darunter'] = drunterM;
    switch (typ) {
      case 'strickjacke-zopf' || 'strickjacke':
        teile.add('oberteil-strickjacke');
      case 'mantel' || 'jacke':
        teile.add('oberteil-mantel');
      case 'fleece':
        teile.add('oberteil-fleece');
      case 'hoodie':
        teile.add('oberteil-hoodie');
      case 'hemd' || 'bluse' || 'sakko':
        teile.add('oberteil-hemdkragen');
      case 'kleid':
        teile.add('unterteil-kleid');
      case 't-shirt':
        teile.add('aermel-kurz');
    }
  }
  if (unter['typ'] == 'rock' && typ != 'kleid') teile.add('unterteil-rock');
  if (schuhe['typ'] == 'wanderstiefel' || schuhe['typ'] == 'stiefel') teile.add('schuhe-stiefel');
  switch (s['kopf']) {
    case 'muetze':
      teile.add('kopf-muetze');
      mats['kopfbedeckung'] = const Material(3, 3);
    case 'hut':
      teile.add('kopf-hut');
      mats['kopfbedeckung'] = const Material(2, 2);
    case 'kappe':
      teile.add('kopf-kappe');
  }
  for (final z in (s['zubehoer'] as List? ?? const [])) {
    final id = z == 'halstuch' ? 'schal' : z as String;
    if (kTeileBasis.containsKey(id)) teile.add(id);
  }
  final statur = s['statur'] as String? ?? 'normal';
  return Figurenkarte(
    id: s['id'] as String,
    name: s['name'] as String? ?? s['id'] as String,
    groesse: (s['groesse'] as num?)?.toDouble() ?? 1.75,
    breite: statur == 'schmal' ? 0.9 : (statur == 'kräftig' ? 1.15 : 1.0),
    materialien: mats,
    teile: teile,
  );
}

/// Brennt Figuren schrittweise (Zeitbudget je Bild) und liefert Sprites.
class FigurenLager {
  final FigurBaker baker;
  final Map<String, Figurenkarte> karten = {};
  final Map<String, Map<String, List<List<SpriteImage>>>> _fertig = {};
  final List<(String, String, int)> _warteschlange = [];
  static const animationen = ['stehen', 'gehen', 'sprechen', 'untersuchen'];

  FigurenLager(Map<String, Teil> teile) : baker = FigurBaker(teile);

  void karte(Figurenkarte k) {
    karten[k.id] = k;
    _fertig.remove(k.id);
    _warteschlange.removeWhere((w) => w.$1 == k.id);
    for (final a in animationen) {
      for (var i = 0; i < kAnimationen[a]!.length; i++) {
        _warteschlange.add((k.id, a, i));
      }
    }
  }

  int get offen => _warteschlange.length;

  /// Halb gebrannte Animationsbilder (Richtungen 0…7 werden einzeln gebrannt).
  final Map<(String, String, int), List<SpriteImage>> _teilweise = {};

  /// Längster einzelner Aufruf von [backe] (ms) – für die Leistungsmessung.
  double maxBackMs = 0;

  /// Verteilung der Aufrufdauern von [backe] in ganzen Millisekunden (letzter Eimer: ≥ 63 ms).
  final List<int> backVerteilung = List.filled(64, 0);

  /// Brennt höchstens [budgetMs] Millisekunden lang weiter (je Schritt eine Richtung).
  void backe(double budgetMs) {
    if (_warteschlange.isEmpty) return;
    final uhr = Stopwatch()..start();
    while (_warteschlange.isNotEmpty && uhr.elapsedMicroseconds < budgetMs * 1000) {
      final w = _warteschlange.first;
      final (id, anim, nr) = w;
      final k = karten[id];
      if (k == null) {
        _warteschlange.removeAt(0);
        continue;
      }
      final bilder = _teilweise.putIfAbsent(w, () => []);
      bilder.add(baker.backeEinzel(k, kAnimationen[anim]![nr], bilder.length));
      if (bilder.length < 8) continue;
      _warteschlange.removeAt(0);
      _teilweise.remove(w);
      final a = _fertig.putIfAbsent(id, () => {}).putIfAbsent(anim, () => []);
      while (a.length <= nr) {
        a.add(const []);
      }
      a[nr] = bilder;
    }
    final ms = uhr.elapsedMicroseconds / 1000;
    if (ms > maxBackMs) maxBackMs = ms;
    backVerteilung[ms.floor().clamp(0, 63)]++;
  }

  void alleBacken() => backe(1e9);

  /// Sprite für Figur [id] in [animation] zur Zeit [t] (s), Richtung relativ zum Betrachter.
  SpriteImage? bild(String id, String animation, double t, int richtung) {
    final f = _fertig[id];
    if (f == null) return null;
    final a = f[animation] ?? f['stehen'];
    if (a == null || a.isEmpty) return null;
    final fps = animation == 'gehen' ? 6.0 : 1.6;
    final frame = a[(t * fps).floor() % a.length];
    if (frame.isEmpty) return f['stehen']?.first.elementAtOrNull(richtung & 7);
    return frame[richtung & 7];
  }

  /// Richtung 0–7 einer Figur mit Blick [yaw] an ([fx],[fz]), gesehen von ([cx],[cz]).
  static int richtung(double yaw, double fx, double fz, double cx, double cz) {
    final rel = math.atan2(cz - fz, cx - fx) - yaw;
    return ((rel / (math.pi / 4)).round() % 8 + 8) % 8;
  }
}
