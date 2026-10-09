import 'package:flutter/material.dart';

import '../erzaehler_ausgabe.dart';
import '../party_stil.dart';
import '../sitzung.dart';

/// Intro (Phase intro, Master 7.6 Schritt 4): Marke und Titel aus Bausteinen,
/// darunter die Erzählung mit den drei Lacher-Rückblicken und der Weg in die
/// erste Runde.
class IntroBildschirm extends StatelessWidget {
  const IntroBildschirm({super.key, required this.sitzung});

  final PartySitzung sitzung;

  @override
  Widget build(BuildContext context) => PartyRahmen(
        marke: sitzung.ui('ui.intro.marke'),
        titel: sitzung.ui('ui.intro.titel'),
        aktionen: [PartyKnopf(text: sitzung.ui('ui.intro.weiter'), onPressed: sitzung.weiter)],
        child: ErzaehlerFeld(sitzung: sitzung, kennungen: sitzung.erzaehler),
      );
}
