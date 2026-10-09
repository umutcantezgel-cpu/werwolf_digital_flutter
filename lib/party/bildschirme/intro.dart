import 'package:flutter/material.dart';

import '../erzaehler_ausgabe.dart';
import '../party_stil.dart';
import '../sitzung.dart';

/// Intro mit den drei Lacher-Rückblicken (F4-BAUMEISTER-08). Stub von ORCH mit fester Schnittstelle; der Baumeister baut ihn aus.
class IntroBildschirm extends StatelessWidget {
  const IntroBildschirm({super.key, required this.sitzung});

  final PartySitzung sitzung;

  @override
  Widget build(BuildContext context) => PartyRahmen(
        titel: sitzung.phase.name,
        aktionen: [PartyKnopf(text: sitzung.ui('ui.allgemein.weiter'), onPressed: sitzung.kannWeiter ? sitzung.weiter : null)],
        child: ErzaehlerFeld(sitzung: sitzung, kennungen: sitzung.erzaehler),
      );
}
