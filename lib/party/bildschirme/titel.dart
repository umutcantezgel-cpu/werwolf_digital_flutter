import 'package:flutter/material.dart';

import '../party_stil.dart';
import '../sitzung.dart';

/// Titelbildschirm (F4-BAUMEISTER-08). Stub von ORCH mit fester Schnittstelle; der Baumeister baut ihn aus.
class TitelBildschirm extends StatelessWidget {
  const TitelBildschirm({super.key, required this.sitzung});

  final PartySitzung sitzung;

  @override
  Widget build(BuildContext context) => PartyRahmen(
        titel: sitzung.kanon.fall['titel'] as String,
        untertitel: sitzung.kanon.fall['untertitel'] as String,
        aktionen: [PartyKnopf(text: sitzung.ui('ui.allgemein.weiter'), onPressed: sitzung.zurEinrichtung)],
        child: const SizedBox.shrink(),
      );
}
