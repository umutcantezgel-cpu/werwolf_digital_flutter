import 'package:flutter/material.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../game/game_view.dart';
import 'karte_session.dart';
import 'party_stil.dart';
import 'sitzung.dart';

/// Rückblende im Finale (F4-ORCH-03, Master 7.13): Zeitraffer der Tatmatrix
/// des aktiven Pfads. Im Dunkeln nur Umrisse, hervorgehoben sind die Person
/// mit dem Schlag und Herr Schneider; das Licht folgt dem Stromausfall (B-04).
/// Erst nach dem Finale verwenden (die Sitzung prüft das).
class RueckblendeAnsicht extends StatefulWidget {
  const RueckblendeAnsicht({super.key, required this.sitzung, this.onFertig});

  final PartySitzung sitzung;

  /// Wird einmal aufgerufen, wenn der Zeitraffer am Ende ist.
  final VoidCallback? onFertig;

  @override
  State<RueckblendeAnsicht> createState() => _RueckblendeAnsichtState();
}

class _RueckblendeAnsichtState extends State<RueckblendeAnsicht> {
  late final PartyKartenSession _session;

  @override
  void initState() {
    super.initState();
    _session = PartyKartenSession(widget.sitzung, rueckblendeModus: true, zeitraffer: widget.sitzung.zeitraffer);
    _session.fertig.addListener(_fertig);
  }

  void _fertig() {
    if (_session.fertig.value) widget.onFertig?.call();
  }

  @override
  void dispose() {
    _session.fertig.removeListener(_fertig);
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(child: GameView(session: _session, steuerung: false)),
          Positioned(
            left: 12,
            top: 12,
            child: ValueListenableBuilder<Uhrzeit?>(
              valueListenable: _session.zeit,
              builder: (context, t, _) => t == null
                  ? const SizedBox.shrink()
                  : DecoratedBox(
                      decoration: BoxDecoration(color: const Color(0xCC0B0A0E), borderRadius: BorderRadius.circular(8), border: Border.all(color: Keller.linie)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Text(widget.sitzung.ui('ui.allgemein.uhrzeit', {'uhrzeit': t.mitSekunden}), style: Keller.text.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
                      ),
                    ),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: IconButton.filledTonal(
              tooltip: widget.sitzung.ui('ui.rueckblende.nochmal'),
              onPressed: _session.neuStarten,
              icon: const Icon(Icons.replay),
            ),
          ),
        ],
      );
}
