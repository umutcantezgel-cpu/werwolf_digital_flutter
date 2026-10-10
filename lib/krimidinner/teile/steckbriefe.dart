import 'package:flutter/material.dart';
import 'package:krimidinner_kanon/krimidinner_kanon.dart' show Abschnitt, Gewoelbe, GewoelbeTexte;

import '../../party/party_stil.dart';
import '../abschnitt_ansicht.dart';

/// Steckbriefe für alle: Geburtstagskind, Burgwart und je besetzter Rolle eine
/// aufklappbare Karte. Eine Spalte am Telefon, zwei ab 600 px.
class SteckbriefeTeil extends StatefulWidget {
  const SteckbriefeTeil({super.key, required this.gewoelbe, required this.rollen, required this.onBesetzung});

  final Gewoelbe gewoelbe;
  final int rollen;
  final VoidCallback onBesetzung;

  @override
  State<SteckbriefeTeil> createState() => _SteckbriefeTeilState();
}

class _SteckbriefeTeilState extends State<SteckbriefeTeil> {
  /// Alle Karten auf- oder zuklappen; neue Schlüssel setzen den Zustand jeder Karte.
  bool _alleOffen = false;
  int _runde = 0;

  @override
  Widget build(BuildContext context) {
    final karten = widget.gewoelbe.steckbriefe(widget.rollen);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(GewoelbeTexte.steckbriefeHinweis, style: Keller.leise),
        const SizedBox(height: 8),
        BesetzungsLeiste(rollen: widget.rollen, onBesetzung: widget.onBesetzung),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => setState(() {
              _alleOffen = !_alleOffen;
              _runde++;
            }),
            icon: Icon(_alleOffen ? Icons.unfold_less_rounded : Icons.unfold_more_rounded, color: Keller.kerze),
            label: Text(
              _alleOffen ? GewoelbeTexte.alleZuklappen : GewoelbeTexte.alleAufklappen,
              style: Keller.leise.copyWith(color: Keller.kerzeHell, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, box) {
            Widget karte(Abschnitt a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AbschnittAnsicht(a, key: ValueKey('${a.schluessel}-$_runde'), anfangsOffen: _alleOffen),
                );
            if (box.maxWidth < 600) {
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (final a in karten) karte(a)]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(children: [for (var i = 0; i < karten.length; i += 2) karte(karten[i])])),
                const SizedBox(width: 12),
                Expanded(child: Column(children: [for (var i = 1; i < karten.length; i += 2) karte(karten[i])])),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Kurze Zeile mit der aktuellen Besetzung und dem Weg zum Ändern.
class BesetzungsLeiste extends StatelessWidget {
  const BesetzungsLeiste({super.key, required this.rollen, required this.onBesetzung});

  final int rollen;
  final VoidCallback onBesetzung;

  @override
  Widget build(BuildContext context) => Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.groups_rounded, size: 18, color: Keller.kerze),
                  ),
                ),
                TextSpan(text: GewoelbeTexte.personen(rollen)),
              ],
            ),
            style: Keller.text.copyWith(fontSize: 15),
          ),
          TextButton(
            onPressed: onBesetzung,
            child: Text(
              GewoelbeTexte.besetzungAendern,
              style: Keller.leise.copyWith(color: Keller.kerzeHell, decoration: TextDecoration.underline, decorationColor: Keller.kerzeHell),
            ),
          ),
        ],
      );
}
