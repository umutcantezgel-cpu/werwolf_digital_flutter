import 'package:flutter/material.dart';

import '../party_stil.dart';
import '../sitzung.dart';

/// Einrichtung des Abends (F4-BAUMEISTER-01): Personenzahl und Namen,
/// Geschlecht des Detektivs, Fall-Code oder Zufall, Bildschirm- oder
/// Druckspiel, Rundendauer. Stub von ORCH mit fester Schnittstelle.
class EinrichtungBildschirm extends StatelessWidget {
  const EinrichtungBildschirm({super.key, required this.sitzung});

  final PartySitzung sitzung;

  @override
  Widget build(BuildContext context) => PartyRahmen(
        titel: sitzung.phase.name,
        aktionen: [PartyKnopf(text: sitzung.ui('ui.allgemein.weiter'), onPressed: () => sitzung.einrichten(rollen: 7, detektiv: 'w'))],
        child: const SizedBox.shrink(),
      );
}
