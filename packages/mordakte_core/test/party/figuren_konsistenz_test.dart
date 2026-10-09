// F-13 figuren_konsistenz: Spiel (Renderer), Dossier und Bildprompt zeigen jede Figur aus denselben Kanon-Feldern.
// Rot-Proben laufen über Umgebungsvariablen auf Kopien in System-Temp, das Repo bleibt unverändert:
// FIGUREN_JSON (figuren.json), SZENARIO_JSON (Renderer-Szenario), TEXTE_ORDNER (texte/), BILDPROMPTS_JSON (bildprompts.json).
//
// Dossier-Regel: Die Stammregel („Kleidungsfarbwort nur mit dem eigenen Stamm“) ist nicht sauber prüfbar.
// „schwarz“ und „weiß“ gehören zwei Figuren (Ahmet, Damir); Farbwörter stehen auch bei Accessoires (schwarze
// Ledermappe) und bei Kleidung ohne Bezug zum Farbnamen (Emines schwarze Stiefel, Olli mit grauem Kapuzenpulli).
// Geprüft wird deshalb die Ersatzregel: Jede Rolle mit Dossier hat einen Farbnamen, und dessen eindeutige
// Farbwörter stehen in keinem Dossier und keiner Täterfassung einer anderen Figur.
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

void main() {
  final k = _kanon();
  final vorlage = leseJson('$repoWurzel/content/scenarios/ravensmoor.json');
  final szenario = _szenario(k, vorlage);
  final kennungen = partyNpcKennungen(k, vorlage);
  final bildPersonen = _nachId(leseJson('$repoWurzel/content/party/schlosskeller/bild.json')['personen'] as List);
  final prompts = _prompts();
  final texte = _texteintraege();
  final dossierRollen = [for (final t in texte) if (t.datei.startsWith('dossiers-')) t.rolle];
  final taeterRollen = [for (final t in texte) if (t.datei.startsWith('taeter-')) t.rolle];

  final detektiv = k.figurenJson['detektiv'] as Map<String, Object?>;
  final detektivId = detektiv['id'] as String;
  final ohneDetektiv = [for (final id in k.personen) if (id != detektivId) k.figur(id)!];

  group('Renderer (partySzenarioJson)', () {
    test('Detektiv: Mantelfarbe ist seine colorCode, Hut ist Fedora bei kopf detektivhut', () {
      final look = renderLook(detektiv);
      expect(_kanonLook(detektiv)['kopf'], 'detektivhut', reason: 'Kanon: der Detektiv trägt den Detektivhut');
      expect(look['coat'], detektiv['colorCode']);
      expect(look['hat'], 'fedora');
    });

    test('Kopftuchfarbe steht als headColor nur bei Figuren mit kopftuchFarbe', () {
      for (final f in ohneDetektiv) {
        final kanonLook = _kanonLook(f);
        final look = _look(_einzeln(szenario, kennungen[f['id']]!));
        if (kanonLook.containsKey('kopftuchFarbe')) {
          expect(look['headColor'], kanonLook['kopftuchFarbe'], reason: '${f['id']}: headColor');
        } else {
          expect(look.containsKey('headColor'), isFalse, reason: '${f['id']}: ohne kopftuchFarbe keine headColor');
        }
      }
    });

    test('je Person außer dem Detektiv genau ein Eintrag mit ihrer Kennung, keine weiteren Einträge', () {
      for (final f in ohneDetektiv) {
        expect(_eintraege(szenario, kennungen[f['id']]!), hasLength(1), reason: '${f['id']}');
      }
      expect(szenario['suspects'] as List, hasLength(ohneDetektiv.length), reason: 'Einträge ohne Person');
    });

    test('Anzeigename je Person ist der Name aus figuren.json', () {
      for (final f in ohneDetektiv) {
        final e = _einzeln(szenario, kennungen[f['id']]!);
        expect((e['name'] as Map)['de'], f['name'], reason: '${f['id']}');
      }
    });

    test('Mantelfarbe je Person ist die colorCode der Figur', () {
      for (final f in ohneDetektiv) {
        final look = _look(_einzeln(szenario, kennungen[f['id']]!));
        expect(look['coat'], f['colorCode'], reason: '${f['id']}');
      }
    });

    test('Haut- und Haarfarbe je Person stammen aus look.haut und look.haar', () {
      for (final f in ohneDetektiv) {
        final kanonLook = _kanonLook(f);
        final look = _look(_einzeln(szenario, kennungen[f['id']]!));
        if (kanonLook.containsKey('haut')) expect(look['skin'], kanonLook['haut'], reason: '${f['id']}: haut');
        if (kanonLook.containsKey('haar')) expect(look['hair'], kanonLook['haar'], reason: '${f['id']}: haar');
      }
    });

    test('Statur und Kleidungsschnitt je Person stammen aus look.statur und look.schnitt', () {
      for (final f in ohneDetektiv) {
        final kanonLook = _kanonLook(f);
        final look = _look(_einzeln(szenario, kennungen[f['id']]!));
        expect(look['build'], kanonLook['statur'], reason: '${f['id']}: statur');
        expect(look['outfit'], kanonLook['schnitt'], reason: '${f['id']}: schnitt');
      }
    });

    test('Position je Person ist der Ermittlungsort, abgerundet auf das Raster', () {
      for (final f in ohneDetektiv) {
        final ort = k.graph.orte[f['ermittlungsOrt']]!;
        final e = _einzeln(szenario, kennungen[f['id']]!);
        expect(e['x'], ort.x.floor(), reason: '${f['id']}: x');
        expect(e['y'], ort.y.floor(), reason: '${f['id']}: y');
      }
    });
  });

  group('Bildprompt (bildprompts.json gegen den Kanon)', () {
    test('Signaturfarbe steht genau an der Kleidung (E-028) in jedem Personenprompt', () {
      for (final p in prompts.where((p) => p.art == 'person')) {
        final id = _figurId(p.id);
        final kleidung = bildPersonen[id]!['kleidung'] as String;
        final farbe = farbnameFuer(k.figur(id)!['colorCode'] as String);
        final mitFarbe = kleidung.contains('{farbe}') ? kleidung.replaceAll('{farbe}', farbe) : '$farbe $kleidung';
        expect(p.prompt, contains('wearing $mitFarbe'), reason: p.id);
      }
    });

    test('Farbname einer Figur aus demselben Startraum steht im Prompt nur, wenn er im Quelltext dieser Figur steht', () {
      final fehler = <String>[];
      for (final p in prompts.where((p) => p.art == 'person')) {
        final id = _figurId(p.id);
        final figur = k.figur(id)!;
        final eigen = farbnameFuer(figur['colorCode'] as String);
        final quelltext = _textteile(bildPersonen[id]).join(' ');
        for (final andere in k.personen) {
          final af = k.figur(andere)!;
          if (andere == id || af['startRoom'] != figur['startRoom']) continue;
          final name = farbnameFuer(af['colorCode'] as String);
          if (name == eigen) continue;
          if (_kommtVor(p.prompt, name) && !_kommtVor(quelltext, name)) {
            fehler.add('${p.id} nennt „$name“ aus dem Farbnamen von $andere');
          }
        }
      }
      expect(fehler, isEmpty, reason: fehler.join('\n'));
    });
  });

  group('Deutscher Farbname', () {
    test('jede Person hat einen nicht leeren farbname', () {
      for (final id in k.personen) {
        expect(_hatText(k.figur(id)!['farbname']), isTrue, reason: id);
      }
    });

    test('jede Person hat einen anderen farbname als jede andere Person mit anderem colorCode', () {
      final figuren = [for (final id in k.personen) k.figur(id)!];
      final fehler = <String>[];
      for (var i = 0; i < figuren.length; i++) {
        for (var j = i + 1; j < figuren.length; j++) {
          final a = figuren[i];
          final b = figuren[j];
          if (a['colorCode'] == b['colorCode']) continue;
          if (_norm(a['farbname']) == _norm(b['farbname'])) {
            fehler.add('${a['id']} / ${b['id']}: „${a['farbname']}“');
          }
        }
      }
      expect(fehler, isEmpty, reason: fehler.join('\n'));
    });
  });

  group('Dossier und Täterfassung', () {
    test('jede der 20 Rollen des Kanons hat genau ein Dossier, Täterfassungen nur bei Rollen mit Dossier', () {
      expect(dossierRollen, unorderedEquals([for (final f in k.figuren) f['id'] as String]));
      expect(taeterRollen, everyElement(isIn(dossierRollen)));
    });

    test('jede Rolle mit Dossier hat einen Farbnamen', () {
      for (final rolle in dossierRollen) {
        expect(_hatText(k.figur(rolle)!['farbname']), isTrue, reason: rolle);
      }
    });

    test('ein eindeutiges Farbwort aus dem Farbnamen einer Figur steht in keinem Dossier einer anderen Figur', () {
      final besitzer = <String, Set<String>>{};
      for (final id in k.personen) {
        for (final wort in _farbworte(k.figur(id)!['farbname'])) {
          besitzer.putIfAbsent(wort, () => {}).add(id);
        }
      }
      final eindeutig = {for (final e in besitzer.entries) if (e.value.length == 1) e.key: e.value.single};
      final fehler = <String>[];
      for (final t in texte) {
        for (final text in _textteile(t.eintrag)) {
          for (final e in eindeutig.entries) {
            if (e.value != t.rolle && _beginntWort(text, e.key)) {
              fehler.add('${e.key} (Farbname von ${e.value}) in ${t.datei}, Rolle ${t.rolle}: „$text“');
            }
          }
        }
      }
      expect(fehler, isEmpty, reason: fehler.join('\n'));
    });
  });
}

/// Kanon des Falls; FIGUREN_JSON ersetzt figuren.json (Rot-Probe).
Kanon _kanon() {
  final figuren = Platform.environment['FIGUREN_JSON'];
  if (figuren == null) return ladeKanon();
  return Kanon.lade((p) => p == 'figuren.json' ? leseJson(figuren) : leseJson('$repoWurzel/content/party/schlosskeller/$p'));
}

/// Renderer-Szenario aus dem Kanon; SZENARIO_JSON ersetzt es (Rot-Probe).
Map<String, dynamic> _szenario(Kanon k, Map<String, Object?> vorlage) {
  final datei = Platform.environment['SZENARIO_JSON'];
  if (datei != null) return jsonDecode(File(datei).readAsStringSync()) as Map<String, dynamic>;
  return jsonDecode(jsonEncode(partySzenarioJson(k, vorlage))) as Map<String, dynamic>;
}

/// Prompts aus bildprompts.json; BILDPROMPTS_JSON ersetzt die Datei (Rot-Probe).
List<({String id, String art, String prompt})> _prompts() {
  final datei = Platform.environment['BILDPROMPTS_JSON'] ?? '$repoWurzel/content/party/schlosskeller/bildprompts.json';
  return [
    for (final p in (leseJson(datei)['prompts'] as List).cast<Map<String, Object?>>())
      (id: p['id'] as String, art: p['art'] as String, prompt: p['prompt'] as String),
  ];
}

/// Einträge aus dossiers-*.json und taeter-*.json, nach Dateiname sortiert; TEXTE_ORDNER ersetzt den Ordner (Rot-Probe).
List<({String datei, String rolle, Map<String, Object?> eintrag})> _texteintraege() {
  final ordner = Platform.environment['TEXTE_ORDNER'] ?? '$repoWurzel/content/party/schlosskeller/texte';
  final dateien = [
    for (final f in Directory(ordner).listSync().whereType<File>())
      if (_istDossierOderTaeter(f.uri.pathSegments.last)) f,
  ]..sort((a, b) => a.path.compareTo(b.path));
  return [
    for (final f in dateien)
      for (final e in (leseJson(f.path)['eintraege'] as List).cast<Map<String, Object?>>())
        (datei: f.uri.pathSegments.last, rolle: e['rolle'] as String, eintrag: e),
  ];
}

bool _istDossierOderTaeter(String name) =>
    name.endsWith('.json') && (name.startsWith('dossiers-') || name.startsWith('taeter-'));

/// Renderer-Einträge zu einer Kennung.
List<Map<String, dynamic>> _eintraege(Map<String, dynamic> szenario, String kennung) => [
      for (final e in szenario['suspects'] as List)
        if ((e as Map)['id'] == kennung) e.cast<String, dynamic>(),
    ];

/// Genau ein Renderer-Eintrag zu einer Kennung.
Map<String, dynamic> _einzeln(Map<String, dynamic> szenario, String kennung) {
  final treffer = _eintraege(szenario, kennung);
  expect(treffer, hasLength(1), reason: 'Renderer-Kennung $kennung');
  return treffer.first;
}

Map<String, dynamic> _look(Map<String, dynamic> eintrag) => (eintrag['look'] as Map).cast<String, dynamic>();

Map<String, Object?> _kanonLook(Map<String, Object?> figur) => (figur['look'] as Map).cast<String, Object?>();

/// Figur-Kennung eines Prompts: die beiden Detektiv-Prompts gehören zu „detective“.
String _figurId(String promptId) => promptId.startsWith('detective_') ? 'detective' : promptId;

/// Alle Textstellen eines Eintrags; Rollenkennung und Querverweise (ref) zählen nicht dazu.
List<String> _textteile(Object? o) {
  if (o is String) return [o];
  if (o is List) return [for (final x in o) ..._textteile(x)];
  if (o is Map) return [for (final e in o.entries) if (e.key != 'rolle' && e.key != 'ref') ..._textteile(e.value)];
  return const [];
}

/// Ganzes Wort oder Wortphrase, ohne Groß- und Kleinschreibung.
bool _kommtVor(String text, String phrase) =>
    RegExp('(?<!\\p{L})${RegExp.escape(phrase)}(?!\\p{L})', caseSensitive: false, unicode: true).hasMatch(text);

/// Ein Wort beginnt mit der Phrase; so greifen Beugungen wie „olivgrünen“ auf „Olivgrün“.
bool _beginntWort(String text, String phrase) =>
    RegExp('(?<!\\p{L})${RegExp.escape(phrase)}', caseSensitive: false, unicode: true).hasMatch(text.toLowerCase());

/// Farbwörter eines Farbnamens („Karminrot mit Gold“ ergibt karminrot und gold).
List<String> _farbworte(Object? farbname) => [
      for (final w in ((farbname as String?) ?? '').toLowerCase().split(RegExp(r'\s+')))
        if (w.isNotEmpty && w != 'und' && w != 'mit') w,
    ];

bool _hatText(Object? s) => s is String && s.trim().isNotEmpty;

String _norm(Object? s) => ((s as String?) ?? '').trim().toLowerCase();

/// Einträge einer bild.json-Liste nach `id`.
Map<String, Map<String, Object?>> _nachId(List liste) {
  final ausgabe = <String, Map<String, Object?>>{};
  for (final e in liste) {
    final m = (e as Map).cast<String, Object?>();
    ausgabe[m['id'] as String] = m;
  }
  return ausgabe;
}
