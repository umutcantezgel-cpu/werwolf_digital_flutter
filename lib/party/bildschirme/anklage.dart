import 'package:flutter/material.dart';

import '../erzaehler_ausgabe.dart';
import '../party_stil.dart';
import '../sitzung.dart';

/// Anklage gegen eine der vier Kernpersonen (F4-BAUMEISTER-06). Stub von ORCH.
class AnklageBildschirm extends StatelessWidget {
  const AnklageBildschirm({super.key, required this.sitzung});

  final PartySitzung sitzung;

  @override
  Widget build(BuildContext context) => PartyRahmen(
        titel: sitzung.phase.name,
        aktionen: [PartyKnopf(text: sitzung.ui('ui.allgemein.weiter'), onPressed: sitzung.kannWeiter ? sitzung.weiter : null)],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ErzaehlerFeld(sitzung: sitzung, kennungen: sitzung.erzaehler),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in sitzung.kernverdaechtige)
                  PartyKnopf(text: sitzung.figurName(p), haupt: sitzung.angeklagt == p, onPressed: () => sitzung.anklagen(p)),
              ],
            ),
          ],
        ),
      );
}
