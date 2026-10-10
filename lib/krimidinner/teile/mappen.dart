import 'package:flutter/material.dart';
import 'package:krimidinner_kanon/krimidinner_kanon.dart' show Gewoelbe, GewoelbeTexte;

import '../../party/party_stil.dart';
import '../gewoelbe_stil.dart';
import 'steckbriefe.dart' show BesetzungsLeiste;

/// Rollenmappen mit „Gerät reihum“: Die neutrale Liste zeigt nur Namen und das
/// Häkchen „gesehen“. Ein Tipp führt zur Zwischenstufe „Gib das Gerät an …“;
/// erst der Knopf darunter öffnet die Mappe.
class MappenTeil extends StatelessWidget {
  const MappenTeil({
    super.key,
    required this.gewoelbe,
    required this.rollen,
    required this.gesehen,
    required this.vorbereitet,
    required this.meldung,
    required this.onVorbereiten,
    required this.onOeffnen,
    required this.onBesetzung,
  });

  final Gewoelbe gewoelbe;
  final int rollen;
  final Set<String> gesehen;

  /// Person in der Zwischenstufe, sonst `null`.
  final String? vorbereitet;

  /// Meldung nach dem Zudecken, sonst `null`.
  final String? meldung;

  final ValueChanged<String?> onVorbereiten;
  final ValueChanged<String> onOeffnen;
  final VoidCallback onBesetzung;

  String _name(String person) => person == 'DET' ? GewoelbeTexte.geburtstagskind : gewoelbe.name(person);

  @override
  Widget build(BuildContext context) {
    final v = vorbereitet;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(GewoelbeTexte.mappenErklaerung, style: Keller.text),
        const SizedBox(height: 8),
        BesetzungsLeiste(rollen: rollen, onBesetzung: onBesetzung),
        const SizedBox(height: 8),
        if (meldung != null) ...[
          GewoelbeHinweis(text: meldung!, icon: Icons.visibility_off_rounded),
          const SizedBox(height: 14),
        ],
        if (v == null) ..._liste() else _zwischenstufe(v),
      ],
    );
  }

  List<Widget> _liste() => [
        for (final person in gewoelbe.mappenPersonen(rollen))
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PersonZeile(
              name: _name(person),
              gesehen: gesehen.contains(person),
              geburtstagskind: person == 'DET',
              onTap: () => onVorbereiten(person),
            ),
          ),
      ];

  Widget _zwischenstufe(String person) {
    final anrede = gewoelbe.vorname(person);
    return PartyTafel(
      akzent: K9.akzent,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.phonelink_lock_rounded, color: K9.akzent, size: 34),
          const SizedBox(height: 12),
          Text(GewoelbeTexte.weitergeben(anrede), style: Keller.ueberschrift),
          const SizedBox(height: 18),
          PartyKnopf(text: GewoelbeTexte.oeffnen(anrede), icon: Icons.lock_open_rounded, onPressed: () => onOeffnen(person)),
          const SizedBox(height: 10),
          PartyKnopf(text: GewoelbeTexte.zurueck, haupt: false, onPressed: () => onVorbereiten(null)),
        ],
      ),
    );
  }
}

/// Eine Person der neutralen Liste: nur der Name und, falls gesehen, das Häkchen.
class _PersonZeile extends StatelessWidget {
  const _PersonZeile({required this.name, required this.gesehen, required this.geburtstagskind, required this.onTap});

  final String name;
  final bool gesehen;
  final bool geburtstagskind;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              color: Keller.stein,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: gesehen ? Keller.linieStark : Keller.linie),
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              children: [
                Icon(geburtstagskind ? Icons.cake_rounded : Icons.folder_rounded, color: Keller.kerze, size: 22),
                const SizedBox(width: 12),
                Expanded(child: Text(name, style: Keller.text.copyWith(fontWeight: FontWeight.w600))),
                if (gesehen) ...[
                  const Icon(Icons.check_circle_rounded, color: Keller.notlicht, size: 20),
                  const SizedBox(width: 6),
                  Text(GewoelbeTexte.gesehen, style: Keller.leise.copyWith(color: Keller.notlicht)),
                  const SizedBox(width: 6),
                ],
                const Icon(Icons.chevron_right_rounded, color: Keller.papierGedaempft),
              ],
            ),
          ),
        ),
      );
}
