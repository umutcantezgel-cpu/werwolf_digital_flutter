import 'package:flutter/material.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../game/game_view.dart';
import '../karte_session.dart';
import '../party_stil.dart';
import '../sitzung.dart';
import 'npc_karte.dart';

/// Die Entscheidungen des Detektivs auf der Karte (F4-ORCH-01, Master 7.7):
/// Frage oben, die Ziele der laufenden Entscheidung leuchten auf der Karte.
/// Eine Handlung macht einen Vorschlag; erst „Das ist endgültig“ wählt.
class KartenBildschirm extends StatefulWidget {
  const KartenBildschirm({super.key, required this.sitzung});

  final PartySitzung sitzung;

  @override
  State<KartenBildschirm> createState() => _KartenBildschirmState();
}

class _KartenBildschirmState extends State<KartenBildschirm> {
  late final PartyKartenSession _session;
  late final TileGrid _raster;
  bool _hinweisOffen = true;

  PartySitzung get s => widget.sitzung;

  @override
  void initState() {
    super.initState();
    _session = PartyKartenSession(s);
    _raster = TileGrid(s.daten.szenario.map);
    s.detektivSetzen.addListener(_setzeDetektiv);
    s.detektivAn.addListener(_detektivAn);
    _detektivAn();
  }

  /// Entwickler-Einstieg `at=x,y`: Detektiv an eine feste Stelle.
  void _detektivAn() {
    final p = s.detektivAn.value;
    if (p != null) _session.setzeDetektiv(p.$1, p.$2);
  }

  @override
  void dispose() {
    s.detektivSetzen.removeListener(_setzeDetektiv);
    s.detektivAn.removeListener(_detektivAn);
    _session.dispose();
    super.dispose();
  }

  /// Entwickler-Skript: Detektiv neben ein Ziel stellen.
  void _setzeDetektiv() {
    final z = s.detektivSetzen.value;
    if (z == null) return;
    final (x, y) = _nebenZiel(z);
    _session.setzeDetektiv(x, y, facing: 0.8);
  }

  (double, double) _nebenZiel(KartenZiel z) {
    double zx, zy;
    if (z.person != null) {
      final f = s.karte.figuren.firstWhere((f) => f.id == z.person);
      (zx, zy) = (f.x, f.y);
    } else {
      (zx, zy) = (z.x! + 0.5, z.y! + 0.5);
    }
    const nachbarn = [(1, 0), (0, 1), (-1, 0), (0, -1), (1, 1), (-1, 1), (1, -1), (-1, -1)];
    for (final (dx, dy) in nachbarn) {
      final tx = zx.floor() + dx, ty = zy.floor() + dy;
      if (_raster.walkable(tx, ty) && s.kanon.graph.raumAn(tx + 0.5, ty + 0.5)?.id == z.raum) return (tx + 0.5, ty + 0.5);
    }
    return (zx, zy);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: s,
        builder: (context, _) {
          final e = s.laufendeEntscheidung;
          final fund = s.letzterFund;
          final vorschlag = s.vorschlag;
          return Stack(
            children: [
              Positioned.fill(child: GameView(session: _session)),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: Keller.breite),
                      // Bei offener Fundkarte zeigt der Kopf noch deren Entscheidung, nicht schon die nächste.
                      child: Padding(padding: const EdgeInsets.all(12), child: _kopf(fund != null ? s.spiel.ermittlung.entscheidung(fund.entscheidung) : e)),
                    ),
                  ),
                ),
              ),
              if (vorschlag != null) _abgedeckt(_bestaetigung(vorschlag)),
              if (fund != null) _abgedeckt(FundKarte(sitzung: s, ziel: fund.ziel, funde: fund.funde, onGelesen: s.fundGelesen)),
              if (e == null && fund == null && vorschlag == null) _abgedeckt(_fertig()),
            ],
          );
        },
      );

  Widget _kopf(Entscheidung? e) {
    if (e == null) return const SizedBox.shrink();
    final nr = (e.runde - 1) * 3 + e.nr;
    return PartyTafel(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text(s.ui('ui.karte.entscheidung', {'nr': '$nr'}).toUpperCase(), style: Keller.marke)),
              Text(s.ui('ui.allgemein.uhrzeit', {'uhrzeit': s.rundenUhrzeit}), style: Keller.leise),
            ],
          ),
          const SizedBox(height: 6),
          Text(e.frage, style: Keller.ueberschrift),
          if (_hinweisOffen) ...[
            const SizedBox(height: 6),
            Text(s.ui('ui.karte.hinweis'), style: Keller.leise),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              OutlinedButton.icon(
                style: _kleinerKnopf,
                onPressed: () => _liste(e),
                icon: const Icon(Icons.list_rounded, size: 18),
                label: Text(s.ui('ui.karte.liste')),
              ),
              OutlinedButton.icon(
                style: _kleinerKnopf,
                onPressed: _notizbuch,
                icon: const Icon(Icons.menu_book_rounded, size: 18),
                label: Text(s.ui('ui.karte.notizbuch')),
              ),
              IconButton(
                tooltip: s.ui('ui.allgemein.weiter'),
                onPressed: () => setState(() => _hinweisOffen = !_hinweisOffen),
                icon: Icon(_hinweisOffen ? Icons.expand_less : Icons.expand_more, color: Keller.papierGedaempft),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Kleine Knöpfe im Kopf: mit Rahmen, damit sie als Knöpfe erkennbar sind (B7).
  static final _kleinerKnopf = OutlinedButton.styleFrom(
    foregroundColor: Keller.kerzeHell,
    side: const BorderSide(color: Keller.linieStark),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    visualDensity: VisualDensity.compact,
  );

  Widget _abgedeckt(Widget kind) => Positioned.fill(
        child: ColoredBox(
          color: const Color(0x99000000),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(padding: const EdgeInsets.all(16), child: SingleChildScrollView(child: kind)),
            ),
          ),
        ),
      );

  Widget _bestaetigung(KartenZiel z) {
    final o = s.spiel.ermittlung.entscheidung(z.entscheidung).option(z.option);
    return PartyTafel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(z.name.toUpperCase(), style: Keller.marke),
          const SizedBox(height: 8),
          Text(o.text, style: Keller.ueberschrift),
          const SizedBox(height: 10),
          Text(s.ui('ui.karte.endgueltig'), style: Keller.text),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 10,
            runSpacing: 8,
            children: [
              PartyKnopf(text: s.ui('ui.karte.nein'), haupt: false, onPressed: s.verwerfen),
              PartyKnopf(text: s.ui('ui.karte.ja'), onPressed: s.bestaetigen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fertig() => PartyTafel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s.ui('ui.karte.fertig'), style: Keller.ueberschrift),
            const SizedBox(height: 16),
            Align(alignment: Alignment.centerRight, child: PartyKnopf(text: s.ui('ui.karte.zur_gruppenwahl'), onPressed: s.weiter)),
          ],
        ),
      );

  Future<void> _liste(Entscheidung e) => showDialog<void>(
        context: context,
        builder: (c) => Dialog(
          backgroundColor: Colors.transparent,
          child: PartyTafel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(s.ui('ui.karte.liste_titel').toUpperCase(), style: Keller.marke),
                const SizedBox(height: 8),
                Text(e.frage, style: Keller.ueberschrift),
                const SizedBox(height: 12),
                for (final o in s.optionen(e.id))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: PartyKnopf(
                      text: o.text,
                      haupt: false,
                      onPressed: () {
                        Navigator.of(c).pop();
                        s.schlageVor(o.id);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  Future<void> _notizbuch() => showDialog<void>(
        context: context,
        builder: (c) => Dialog(
          backgroundColor: Colors.transparent,
          child: PartyTafel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(s.ui('ui.karte.notizbuch').toUpperCase(), style: Keller.marke),
                const SizedBox(height: 10),
                if (s.funde.isEmpty) Text(s.ui('ui.karte.notizbuch_leer'), style: Keller.leise),
                for (final f in s.funde.entries) ...[
                  Text(s.spiel.ermittlung.entscheidung(f.key).frage, style: Keller.leise),
                  for (final a in f.value) Padding(padding: const EdgeInsets.only(top: 4, bottom: 8), child: Text(a.text, style: Keller.text)),
                ],
                Align(alignment: Alignment.centerRight, child: PartyKnopf(text: s.ui('ui.allgemein.zurueck'), haupt: false, onPressed: () => Navigator.of(c).pop())),
              ],
            ),
          ),
        ),
      );
}
