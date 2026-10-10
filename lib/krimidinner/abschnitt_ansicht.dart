import 'package:flutter/material.dart';
import 'package:krimidinner_kanon/krimidinner_kanon.dart' show Abschnitt, Eintrag, EintragArt, GewoelbeTexte;

import '../party/party_stil.dart';
import 'gewoelbe_stil.dart';

/// Ein Renderer für alle Ansichtsmodelle des Gewölbes: Tafel auf dem Kellergrund
/// oder Karte auf Papierweiß ([hell], Druckvorschau).
class AbschnittAnsicht extends StatefulWidget {
  const AbschnittAnsicht(this.abschnitt, {super.key, this.hell = false, this.anfangsOffen = false});

  final Abschnitt abschnitt;

  /// Papierweiß statt Kellergrund (Druckvorschau).
  final bool hell;

  /// Ist ein aufklappbarer Abschnitt anfangs offen?
  final bool anfangsOffen;

  @override
  State<AbschnittAnsicht> createState() => _AbschnittAnsichtState();
}

class _AbschnittAnsichtState extends State<AbschnittAnsicht> {
  late bool _offen = widget.anfangsOffen;

  Abschnitt get a => widget.abschnitt;
  bool get hell => widget.hell;

  TextStyle get _titel => hell ? Papier.titel : Keller.ueberschrift;
  TextStyle get _leise => hell ? Papier.leise : Keller.leise;

  @override
  Widget build(BuildContext context) {
    final aufklappbar = a.aufklappbar && !hell;
    final zeigeInhalt = !aufklappbar || _offen;
    final inhalt = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _kopf(aufklappbar),
        if (zeigeInhalt && a.eintraege.isNotEmpty) ...[
          const SizedBox(height: 12),
          EintraegeAnsicht(a.eintraege, hell: hell),
        ],
      ],
    );
    if (hell) {
      return Container(
        decoration: BoxDecoration(
          color: Papier.grund,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Papier.linie),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: inhalt,
      );
    }
    final tafel = PartyTafel(akzent: a.initiale != null || a.schluessel == 'DET' ? K9.akzent : null, child: inhalt);
    if (!aufklappbar || _offen) return tafel;
    // Zugeklappt öffnet ein Tipp irgendwo auf der Karte, auch auf den Rand.
    return GestureDetector(behavior: HitTestBehavior.opaque, onTap: _umschalten, child: tafel);
  }

  void _umschalten() => setState(() => _offen = !_offen);

  /// Kopf der Karte: Namensschild, Titel, Untertitel und Kurzzeile. Bei einer
  /// aufklappbaren Karte ist der ganze Kopf samt Kurzzeile die Schaltfläche.
  Widget _kopf(bool aufklappbar) {
    final mitSchild = a.initiale != null || a.schluessel == 'DET';
    final titel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(a.titel, style: _titel),
        if (a.untertitel != null) ...[
          const SizedBox(height: 2),
          Text(a.untertitel!, style: _leise),
        ],
      ],
    );
    final zeile = Row(
      children: [
        if (mitSchild) ...[
          NamensSchild(
            initiale: a.initiale,
            icon: Icons.cake_rounded,
            groesse: hell ? 34 : 44,
          ),
          const SizedBox(width: 12),
        ],
        Expanded(child: titel),
        if (aufklappbar)
          AnimatedRotation(
            turns: _offen ? 0.5 : 0,
            duration: const Duration(milliseconds: 180),
            child: const Icon(Icons.expand_more_rounded, color: Keller.kerze),
          ),
      ],
    );
    final kopf = a.kopfzeile == null
        ? zeile
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [zeile, const SizedBox(height: 8), Text(a.kopfzeile!, style: _leise)],
          );
    if (!aufklappbar) return kopf;
    return Semantics(
      button: true,
      expanded: _offen,
      hint: _offen ? GewoelbeTexte.zuklappen : GewoelbeTexte.aufklappen,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: _umschalten,
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: kopf),
      ),
    );
  }
}

/// Die Einträge eines Abschnitts untereinander.
class EintraegeAnsicht extends StatelessWidget {
  const EintraegeAnsicht(this.eintraege, {super.key, this.hell = false});

  final List<Eintrag> eintraege;
  final bool hell;

  TextStyle get _text => hell ? Papier.text : Keller.text;
  TextStyle get _leise => hell ? Papier.leise : Keller.leise;
  TextStyle get _marke => hell ? Papier.marke : Keller.marke;
  Color get _akzent => hell ? K9.punschbraun : Keller.kerzeHell;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < eintraege.length; i++) ...[
            if (eintraege[i].block && i > 0 && eintraege[i - 1].art != EintragArt.zwischentitel) ...[
              const SizedBox(height: 4),
              Divider(height: 18, thickness: 1, color: hell ? Papier.linie : Keller.linie),
            ],
            _eintrag(eintraege[i], i == 0),
          ],
        ],
      );

  Widget _eintrag(Eintrag e, bool erster) => switch (e.art) {
        EintragArt.zwischentitel => Padding(
            padding: EdgeInsets.only(top: erster ? 0 : 14, bottom: 8),
            child: Text(e.text.toUpperCase(), style: _marke),
          ),
        EintragArt.hinweis => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.tips_and_updates_outlined, size: 18, color: _akzent),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(e.text, style: _text.copyWith(fontStyle: FontStyle.italic, color: _akzent)),
                ),
              ],
            ),
          ),
        EintragArt.punkt => Padding(padding: const EdgeInsets.only(bottom: 8), child: _punkt(e)),
        EintragArt.absatz => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (e.label != null) Text(e.label!, style: _leise.copyWith(fontWeight: FontWeight.w600)),
                Text(e.text, style: _text),
              ],
            ),
          ),
      };

  Widget _punkt(Eintrag e) {
    final label = e.label;
    final fett = _text.copyWith(fontWeight: FontWeight.w700, color: _akzent);
    if (label == null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 9, right: 10, left: 2),
            child: Container(width: 6, height: 6, decoration: BoxDecoration(color: _akzent, shape: BoxShape.circle)),
          ),
          Expanded(child: Text(e.text, style: _text)),
        ],
      );
    }
    // Uhrzeiten stehen in einer eigenen Spalte, Namen und Optionen vor dem Text.
    if (RegExp(r'^\d').hasMatch(label)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 98, child: Text(label, style: fett.copyWith(fontFeatures: const [FontFeature.tabularFigures()]))),
          Expanded(child: Text(e.text, style: _text)),
        ],
      );
    }
    if (e.text.isEmpty) return Text(label, style: fett);
    return Text.rich(TextSpan(children: [TextSpan(text: '$label  ', style: fett), TextSpan(text: e.text, style: _text)]));
  }
}
