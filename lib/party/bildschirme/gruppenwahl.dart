import 'package:flutter/material.dart';

import '../party_stil.dart';
import '../sitzung.dart';

/// Gruppenwahl reihum und verdeckt (F4-BAUMEISTER-04). Nie eine Stimmenzahl.
/// Stub von ORCH mit fester Schnittstelle.
class GruppenwahlBildschirm extends StatelessWidget {
  const GruppenwahlBildschirm({super.key, required this.sitzung});

  final PartySitzung sitzung;

  @override
  Widget build(BuildContext context) {
    final v = sitzung.verdeckt;
    if (v != null) {
      final w = sitzung.wahl(v);
      return PartyRahmen(
        titel: sitzung.spielerName(v),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PartyKnopf(text: w.a, onPressed: () => sitzung.stimme(v, kooperativ: true)),
            const SizedBox(height: 12),
            PartyKnopf(text: w.b, haupt: false, onPressed: () => sitzung.stimme(v, kooperativ: false)),
          ],
        ),
      );
    }
    return PartyRahmen(
      titel: sitzung.phase.name,
      aktionen: [PartyKnopf(text: sitzung.ui('ui.allgemein.weiter'), onPressed: sitzung.kannWeiter ? sitzung.weiter : null)],
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final r in sitzung.offeneWaehler)
            PartyKnopf(text: sitzung.ui('ui.verdeckt.frage', {'name': sitzung.spielerName(r)}), haupt: false, onPressed: () => sitzung.zeigeVerdeckt(r)),
        ],
      ),
    );
  }
}
