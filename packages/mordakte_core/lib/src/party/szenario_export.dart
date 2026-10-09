import 'dart:convert';

import 'kanon/kanon.dart';
import 'karte.dart';

/// Baut aus dem Party-Kanon ein Szenario im Format des Mordakte-Renderers
/// (`ScenarioDef`-JSON). Grundlage ist ein vorhandenes Szenario als Vorlage,
/// damit alle Pflichtfelder gefüllt sind; Karte, Thema und Figuren kommen aus
/// dem Kanon. Spiellogik der Vorlage wird nicht benutzt: Hotspots sind die
/// Ziele der neun Entscheidungen ([PartyKarte]), Gegenstände sind leer.
Map<String, dynamic> partySzenarioJson(Kanon kanon, Map<String, dynamic> vorlage, {String id = 'party_schlosskeller'}) {
  final j = jsonDecode(jsonEncode(vorlage)) as Map<String, dynamic>;
  final g = kanon.graph;
  final karte = g.karte;
  final setting = kanon.json['setting.json']!;
  final fall = kanon.fall;
  final spawnOrt = g.orte[(kanon.figurenJson['detektiv'] as Map)['ermittlungsOrt'] as String]!;

  j['id'] = id;
  j['title'] = {'de': fall['titel']};
  j['tagline'] = {'de': fall['untertitel']};
  j['synopsis'] = {'de': setting['schauplatz']};
  j['theme'] = {
    'palette': {
      'background': '#070608',
      'floor': '#4f4842',
      'floorAlt': '#454039',
      'wall': '#2b2521',
      'wallTop': '#4a4038',
      'trim': '#7d6242',
      'accent': '#ff9329',
      'light': '#ffc27a',
      'danger': '#b3263a',
      'text': '#f1ede4',
      'fog': '#15120f',
    },
    'weather': 'none',
    'lightning': false,
    'dayAmbient': 0.62,
    'nightAmbient': 0.06,
  };
  j['map'] = {
    'rows': karte.rows,
    'rooms': [
      for (final r in g.raeume.values)
        {'id': r.id, 'name': {'de': r.anzeigename}, 'x': r.x, 'y': r.y, 'w': r.b, 'h': r.l, 'floor': 'stone'},
    ],
    'props': [for (final p in karte.props) {'type': p.type, 'x': p.x, 'y': p.y}],
    'spawn': [
      [spawnOrt.x.floor(), spawnOrt.y.floor()],
    ],
    'councilRoom': 'thekensaal',
  };
  j['hotspots'] = PartyKarte(kanon).hotspotJson();
  j['items'] = <Object>[];
  final vorlageVerdaechtige = [for (final s in (vorlage['suspects'] as List)) s as Map<String, dynamic>];
  final figuren = _kartenFiguren(kanon);
  final suspects = <Map<String, dynamic>>[];
  for (var i = 0; i < figuren.length; i++) {
    final f = figuren[i];
    final ort = g.orte[f['ermittlungsOrt'] as String]!;
    // Die ersten Plätze übernehmen Kennungen der Vorlage, damit deren Querverweise gültig bleiben.
    final idVorlage = i < vorlageVerdaechtige.length ? vorlageVerdaechtige[i]['id'] as String : null;
    suspects.add({
      'id': idVorlage ?? f['id'],
      'name': {'de': f['name']},
      'role': {'de': f['roleTitle']},
      'bio': {'de': f['motiveAndConflict'] ?? ''},
      'look': renderLook(f),
      'x': ort.x.floor(),
      'y': ort.y.floor(),
      'traits': idVorlage != null ? vorlageVerdaechtige[i]['traits'] : <String, String>{},
      'candidate': f['isPotentialKiller'] == true,
      'motives': idVorlage != null ? vorlageVerdaechtige[i]['motives'] : <String>[],
      'weapons': idVorlage != null ? (vorlageVerdaechtige[i]['weapons'] ?? <String>[]) : <String>[],
      'witness': true,
      'lines': <String, Object>{},
    });
  }
  j['suspects'] = suspects;
  return j;
}

List<Map<String, Object?>> _kartenFiguren(Kanon kanon) => [
      (kanon.figurenJson['opfer'] as Map).cast<String, Object?>(),
      ...kanon.figuren,
    ];

/// Renderer-Kennung je Kanon-Person (Opfer und Rollen). Die ersten Plätze
/// tragen Kennungen der Vorlage (siehe [partySzenarioJson]).
Map<String, String> partyNpcKennungen(Kanon kanon, Map<String, dynamic> vorlage) {
  final v = [for (final s in (vorlage['suspects'] as List)) (s as Map)['id'] as String];
  final figuren = _kartenFiguren(kanon);
  return {for (var i = 0; i < figuren.length; i++) figuren[i]['id'] as String: i < v.length ? v[i] : figuren[i]['id'] as String};
}

/// Renderer-Aussehen einer Figur aus den Kanon-Feldern (`look`), mit
/// Farbcode als Mantelfarbe.
Map<String, String> renderLook(Map<String, Object?> f) {
  final look = (f['look'] as Map?)?.cast<String, Object?>() ?? const {};
  return {
    'coat': f['colorCode'] as String,
    'skin': look['haut'] as String? ?? '#d9b08c',
    'hair': look['haar'] as String? ?? '#3b2a20',
    'hat': switch (look['kopf'] as String?) {
      null || 'detektivhut' => 'fedora',
      final k => k,
    },
    'build': look['statur'] as String? ?? 'normal',
    'outfit': look['schnitt'] as String? ?? 'suit',
    if (look['kopftuchFarbe'] != null) 'headColor': look['kopftuchFarbe'] as String,
  };
}
