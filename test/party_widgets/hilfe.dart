// Testhilfe für die Party-Bildschirme (F4): Sitzung aus den Repo-Dateien,
// Rahmen mit MaterialApp. Tests laufen im Repo-Wurzelordner.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte/party/daten.dart';
import 'package:mordakte/party/sitzung.dart';

PartyDaten? _daten;

/// Einmal geladene Daten des Schlosskellers.
PartyDaten get partyDaten => _daten ??= PartyDaten.aus(
      (p) => jsonDecode(File('content/party/schlosskeller/$p').readAsStringSync()) as Map<String, Object?>,
      jsonDecode(File('content/scenarios/ravensmoor.json').readAsStringSync()) as Map<String, dynamic>,
    );

/// Neue Sitzung, auf Wunsch schon eingerichtet ([rollen] Personen, Pfad [pfad]).
PartySitzung neueSitzung({int? rollen, String pfad = 'ahmet', String detektiv = 'w'}) {
  final s = PartySitzung(partyDaten);
  if (rollen != null) s.einrichten(rollen: rollen, detektiv: detektiv, code: FallCode.fuerPfad(pfad, partyDaten.kanon.pfade).code);
  return s;
}

/// Spielt bis zur Phase [ziel] vor (Entscheidungen: beste Wahl, Gruppe: alle A).
void spieleBis(PartySitzung s, PartyPhase ziel, {int? runde}) {
  while (s.phase != ziel || (runde != null && s.runde != runde)) {
    switch (s.phase) {
      case PartyPhase.titel:
        s.zurEinrichtung();
      case PartyPhase.einrichtung:
        s.einrichten(rollen: 7, detektiv: 'w', code: FallCode.fuerPfad('ahmet', s.kanon.pfade).code);
      case PartyPhase.entscheidungen:
        final e = s.laufendeEntscheidung;
        if (e == null) {
          s.weiter();
        } else {
          s.schlageVor(e.richtig[s.spiel.pfad]!);
          s.bestaetigen();
          s.fundGelesen();
        }
      case PartyPhase.gruppenwahl:
        if (s.offeneWaehler.isEmpty) {
          s.weiter();
        } else {
          final r = s.offeneWaehler.first;
          s.zeigeVerdeckt(r);
          s.stimme(r, kooperativ: true);
        }
      case PartyPhase.anklage:
        if (s.angeklagt == null) s.anklagen(s.spiel.pfad);
        s.weiter();
      case PartyPhase.ende:
        throw StateError('Phase $ziel nicht erreicht');
      default:
        s.weiter();
    }
  }
}

/// Bildschirm in einer MaterialApp mit festem Format (Querformat 1280 × 800).
Widget rahmen(Widget kind) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(body: kind),
    );
