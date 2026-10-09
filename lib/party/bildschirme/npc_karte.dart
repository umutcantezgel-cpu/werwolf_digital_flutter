import 'package:flutter/material.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../party_stil.dart';
import '../sitzung.dart';

/// Fundkarte nach einer Entscheidung (F4-BAUMEISTER-09): Was die Handlung
/// zeigt, wortgleich aus dem Kanon. Bei Personen als Personenkarte mit Name,
/// Farbcode und Hinweis, ob ein Gast die Rolle spielt. Stub von ORCH.
class FundKarte extends StatelessWidget {
  const FundKarte({super.key, required this.sitzung, required this.ziel, required this.funde, required this.onGelesen});

  final PartySitzung sitzung;
  final KartenZiel ziel;
  final List<Aufdeckung> funde;
  final VoidCallback onGelesen;

  @override
  Widget build(BuildContext context) => PartyTafel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(sitzung.ui('ui.karte.fund').toUpperCase(), style: Keller.marke),
            const SizedBox(height: 8),
            Text(ziel.name, style: Keller.ueberschrift),
            const SizedBox(height: 10),
            for (final f in funde) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(f.text, style: Keller.text)),
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerRight, child: PartyKnopf(text: sitzung.ui('ui.karte.gelesen'), onPressed: onGelesen)),
          ],
        ),
      );
}
