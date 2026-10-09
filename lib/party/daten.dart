import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mordakte_core/mordakte_core.dart';

/// Alles, was ein Partyabend aus dem Kanon braucht: Kanon, Textsammlung,
/// Karte und das Renderer-Szenario. Wird einmal geladen und nie verändert.
class PartyDaten {
  final String fall;
  final Kanon kanon;
  final Texte texte;
  final PartyKarte karte;
  final ScenarioDef szenario;

  /// Renderer-Kennung je Kanon-Person (Opfer und Rollen).
  final Map<String, String> npcKennung;

  /// Kanon-Person je Renderer-Kennung.
  final Map<String, String> kanonKennung;

  PartyDaten._(this.fall, this.kanon, this.texte, this.karte, this.szenario, this.npcKennung)
      : kanonKennung = {for (final e in npcKennung.entries) e.value: e.key};

  /// Aus einem synchronen Leser (Tests) und der Szenario-Vorlage.
  factory PartyDaten.aus(KanonLeser lies, Map<String, dynamic> vorlage, {String fall = 'schlosskeller'}) {
    final kanon = Kanon.lade(lies);
    final texte = Texte(kanon, Textsammlung.lade(lies));
    final karte = PartyKarte(kanon);
    final szenario = ScenarioDef.fromJson(partySzenarioJson(kanon, vorlage));
    return PartyDaten._(fall, kanon, texte, karte, szenario, partyNpcKennungen(kanon, vorlage));
  }

  /// Lädt alle Dateien aus den Assets (`content/party/<fall>/`).
  static Future<PartyDaten> laden(AssetBundle bundle, {String fall = 'schlosskeller'}) async {
    final basis = 'content/party/$fall';
    Future<Map<String, Object?>> json(String pfad) async => jsonDecode(await bundle.loadString('$basis/$pfad')) as Map<String, Object?>;
    final dateien = <String, Map<String, Object?>>{};
    Future<void> lade(Iterable<String> pfade) async {
      final liste = pfade.where((p) => !dateien.containsKey(p)).toList();
      final inhalte = await Future.wait(liste.map(json));
      for (var i = 0; i < liste.length; i++) {
        dateien[liste[i]] = inhalte[i];
      }
    }

    await lade([...Kanon.dateien, 'texte/index.json']);
    final pfade = [for (final p in (dateien['fall.json']!['pfade'] as List)) p as String];
    final index = dateien['texte/index.json']!;
    await lade([
      for (final p in pfade) 'tatmatrix/$p.json',
      for (final d in index['dateien'] as List) 'texte/${(d as Map)['datei']}',
    ]);
    final vorlage = jsonDecode(await bundle.loadString('content/scenarios/ravensmoor.json')) as Map<String, dynamic>;
    return PartyDaten.aus((p) => dateien[p] ?? (throw StateError('Datei fehlt: $basis/$p')), vorlage, fall: fall);
  }
}
