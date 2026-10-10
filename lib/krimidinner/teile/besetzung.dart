import 'package:flutter/material.dart';
import 'package:krimidinner_kanon/krimidinner_kanon.dart' show Abschnitt, Gewoelbe, GewoelbeTexte;

import '../../party/party_stil.dart';
import '../gewoelbe_stil.dart';

/// Besetzung: Zahl der Rollen (4 bis 20) und die Rollen in fester Reihenfolge.
class BesetzungTeil extends StatelessWidget {
  const BesetzungTeil({super.key, required this.gewoelbe, required this.rollen, required this.onRollen});

  final Gewoelbe gewoelbe;
  final int rollen;
  final ValueChanged<int> onRollen;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PartyTafel(
            akzent: K9.akzent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(GewoelbeTexte.rollenZahl.toUpperCase(), style: Keller.marke),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _RundKnopf(
                      icon: Icons.remove_rounded,
                      tooltip: GewoelbeTexte.weniger,
                      onPressed: rollen > Gewoelbe.minRollen ? () => onRollen(rollen - 1) : null,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '$rollen',
                          key: const ValueKey('gewoelbe-rollenzahl'),
                          style: Keller.titel.copyWith(fontSize: 52, height: 1.05),
                        ),
                      ),
                    ),
                    _RundKnopf(
                      icon: Icons.add_rounded,
                      tooltip: GewoelbeTexte.mehr,
                      onPressed: rollen < Gewoelbe.maxRollen ? () => onRollen(rollen + 1) : null,
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: K9.akzent,
                    inactiveTrackColor: Keller.steinHell,
                    thumbColor: Keller.kerzeHell,
                    overlayColor: K9.akzent.withValues(alpha: 0.18),
                    valueIndicatorColor: K9.akzent,
                    valueIndicatorTextStyle: const TextStyle(fontFamily: Keller.schrift, color: Color(0xFF1A1006), fontWeight: FontWeight.w700),
                    activeTickMarkColor: const Color(0x00000000),
                    inactiveTickMarkColor: const Color(0x00000000),
                  ),
                  child: Slider(
                    value: rollen.toDouble(),
                    min: Gewoelbe.minRollen.toDouble(),
                    max: Gewoelbe.maxRollen.toDouble(),
                    divisions: Gewoelbe.maxRollen - Gewoelbe.minRollen,
                    label: '$rollen',
                    semanticFormatterCallback: (v) => GewoelbeTexte.personen(v.round()),
                    onChanged: (v) => onRollen(v.round()),
                  ),
                ),
                Text(
                  GewoelbeTexte.personen(rollen),
                  style: Keller.text.copyWith(fontWeight: FontWeight.w700, color: Keller.kerzeHell),
                ),
                const SizedBox(height: 4),
                const Text(GewoelbeTexte.reihenfolge, style: Keller.leise),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final a in gewoelbe.besetzung(rollen)) ...[
            _BesetzungsZeile(a),
            const SizedBox(height: 10),
          ],
        ],
      );
}

class _RundKnopf extends StatelessWidget {
  const _RundKnopf({required this.icon, required this.tooltip, required this.onPressed});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(icon, size: 28),
        style: IconButton.styleFrom(
          minimumSize: const Size(56, 56),
          backgroundColor: Keller.steinHell,
          foregroundColor: Keller.kerzeHell,
          disabledBackgroundColor: Keller.stein,
          disabledForegroundColor: Keller.papierGedaempft.withValues(alpha: 0.4),
          side: const BorderSide(color: Keller.linieStark),
        ),
      );
}

/// Eine Rolle der Besetzung: Namensschild, Name, Aussprache, Geschlecht, Alter, Beruf.
class _BesetzungsZeile extends StatelessWidget {
  const _BesetzungsZeile(this.a);

  final Abschnitt a;

  @override
  Widget build(BuildContext context) => PartyTafel(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NamensSchild(initiale: a.initiale, groesse: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 10,
                    runSpacing: 2,
                    children: [
                      Text(a.titel, style: Keller.ueberschrift.copyWith(fontSize: 19)),
                      if (a.kopfzeile != null) Text(a.kopfzeile!, style: Keller.leise.copyWith(color: Keller.kerzeHell)),
                    ],
                  ),
                  if (a.untertitel != null) Text(a.untertitel!, style: Keller.leise),
                  const SizedBox(height: 4),
                  for (final e in a.eintraege) Text(e.text, style: Keller.text.copyWith(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      );
}
