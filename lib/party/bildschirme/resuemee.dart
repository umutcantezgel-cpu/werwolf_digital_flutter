import 'package:flutter/material.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../erzaehler_ausgabe.dart';
import '../party_stil.dart';
import '../sitzung.dart';

/// Bonus-Hinweis (Phase bonus) und Zwischenresümee (Phase resuemee), Master 7.6
/// Schritt 5 und 7.12. Der Hinweis zeigt nie, ob er stimmt (E-024), und das
/// Resümee nennt keine Stimmen.
class ResuemeeBildschirm extends StatelessWidget {
  const ResuemeeBildschirm({super.key, required this.sitzung});

  final PartySitzung sitzung;

  @override
  Widget build(BuildContext context) => sitzung.phase == PartyPhase.bonus ? _bonus() : _resuemee();

  /// Rahmen und Hinweis aus dem Erzähler, ohne Angabe der Qualität.
  Widget _bonus() => PartyRahmen(
        marke: _runde,
        aktionen: [PartyKnopf(text: sitzung.ui('ui.allgemein.weiter'), onPressed: sitzung.weiter)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(sitzung.ui('ui.resuemee.bonus_titel'), style: Keller.ueberschrift),
            const SizedBox(height: 16),
            ErzaehlerFeld(sitzung: sitzung, kennungen: sitzung.erzaehler),
          ],
        ),
      );

  /// Drei Fächer in fester Reihenfolge: Gruppenergebnis, Stand, Lage.
  Widget _resuemee() => PartyRahmen(
        marke: _runde,
        titel: sitzung.ui('ui.resuemee.titel'),
        aktionen: [PartyKnopf(text: _weiterText, onPressed: sitzung.weiter)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _fach('ui.resuemee.fach_gruppe', 'resuemee.gruppe.'),
            _fach('ui.resuemee.fach_rest', 'resuemee.rest.'),
            _fach('ui.resuemee.fach_lage', 'resuemee.lage.'),
          ],
        ),
      );

  /// Ein Fach: Überschrift und genau ein Baustein mit dem Präfix.
  Widget _fach(String ueberschrift, String praefix) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(sitzung.ui(ueberschrift), style: Keller.ueberschrift),
            const SizedBox(height: 10),
            ErzaehlerFeld(sitzung: sitzung, kennungen: _bausteinVon(praefix)),
          ],
        ),
      );

  /// Der Baustein mit diesem Präfix. Die Reihenfolge der Erzählerbausteine ist egal.
  List<String> _bausteinVon(String praefix) => [for (final k in sitzung.erzaehler) if (k.startsWith(praefix)) k].take(1).toList();

  String get _runde => sitzung.ui('ui.allgemein.runde', {'nr': '${sitzung.runde}'});

  /// Nach der letzten Runde folgt die Anklage.
  String get _weiterText => sitzung.runde == _letzteRunde ? sitzung.ui('ui.resuemee.zur_anklage') : sitzung.ui('ui.resuemee.naechste_runde');

  int get _letzteRunde => (sitzung.kanon.fall['runden'] as List).length;
}
