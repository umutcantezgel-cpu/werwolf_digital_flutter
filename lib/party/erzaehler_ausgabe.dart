import 'package:flutter/material.dart';

import 'party_stil.dart';
import 'sitzung.dart';

/// Erzählerfeld (F4-BAUMEISTER-05): zeigt Bausteine wortgleich als Text und
/// liest sie auf Wunsch mit einer lokalen Stimme vor. Stub von ORCH; der
/// Baumeister baut Stimme, Schreibmaschinen-Effekt und Wortgleich-Prüfung aus.
class ErzaehlerFeld extends StatelessWidget {
  const ErzaehlerFeld({super.key, required this.sitzung, required this.kennungen});

  final PartySitzung sitzung;

  /// Baustein-Kennungen in Lesereihenfolge.
  final List<String> kennungen;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final k in kennungen) ...[
            PartyTafel(child: Text(sitzung.text(k), style: Keller.erzaehler)),
            const SizedBox(height: 12),
          ],
        ],
      );
}
