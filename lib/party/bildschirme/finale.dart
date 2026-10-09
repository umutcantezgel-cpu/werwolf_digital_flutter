import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../erzaehler_ausgabe.dart';
import '../party_stil.dart';
import '../rueckblende_ansicht.dart';
import '../sitzung.dart';

/// Finale mit Rückblende (Master 7.6, Schritt 7): oben der Zeitraffer der Tat,
/// darunter Finaltext und Rückblende aus dem Erzähler. Die Überschrift ist das
/// Ende des Abends, das erst nach der Anklage feststeht.
class FinaleBildschirm extends StatelessWidget {
  const FinaleBildschirm({super.key, required this.sitzung});

  final PartySitzung sitzung;

  @override
  Widget build(BuildContext context) => PartyRahmen(
        marke: sitzung.ui('ui.finale.marke'),
        titel: sitzung.ende.name,
        aktionen: [PartyKnopf(text: sitzung.ui('ui.allgemein.weiter'), onPressed: sitzung.kannWeiter ? sitzung.weiter : null)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(sitzung.ui('ui.finale.rueckblende').toUpperCase(), style: Keller.marke),
            const SizedBox(height: 8),
            // Fester Kasten: mindestens 280 px, sonst 55 % der Höhe.
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: math.max(280.0, MediaQuery.sizeOf(context).height * 0.55),
                child: RueckblendeAnsicht(sitzung: sitzung),
              ),
            ),
            const SizedBox(height: 20),
            ErzaehlerFeld(sitzung: sitzung, kennungen: sitzung.erzaehler),
          ],
        ),
      );
}
