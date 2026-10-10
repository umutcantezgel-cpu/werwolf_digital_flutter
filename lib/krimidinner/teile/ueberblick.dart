import 'package:flutter/material.dart';
import 'package:krimidinner_kanon/krimidinner_kanon.dart' show Gewoelbe, GewoelbeTexte;

import '../abschnitt_ansicht.dart';
import '../gewoelbe_stil.dart';

/// Überblick: Hinweis auf den fehlenden geführten Abend, dann Geschichte, Burg,
/// Burgwart, Ablauf und Regeln (nur öffentliche Datensätze).
class UeberblickTeil extends StatelessWidget {
  const UeberblickTeil({super.key, required this.gewoelbe});

  final Gewoelbe gewoelbe;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const GewoelbeHinweis(text: GewoelbeTexte.hinweisStufe, icon: Icons.record_voice_over_outlined),
          const SizedBox(height: 16),
          for (final a in gewoelbe.ueberblick) ...[
            AbschnittAnsicht(a),
            const SizedBox(height: 14),
          ],
        ],
      );
}
