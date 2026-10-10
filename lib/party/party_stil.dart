import 'package:flutter/material.dart';

/// Gemeinsamer Stil aller Party-Bildschirme (Gewölbekeller bei Nacht, warmes
/// Kerzenlicht). Jeder Bildschirm baut nur aus diesen Bausteinen, damit der
/// Abend wie aus einem Guss wirkt.
abstract final class Keller {
  static const nacht = Color(0xFF0D0C11);
  static const nacht2 = Color(0xFF16141C);
  static const stein = Color(0xFF221E27);
  static const steinHell = Color(0xFF2E2833);
  static const linie = Color(0x33F1E4CC);
  static const linieStark = Color(0x66F1E4CC);
  static const kerze = Color(0xFFFF9329);
  static const kerzeHell = Color(0xFFFFC27A);
  static const kerzeSchwach = Color(0x33FF9329);
  static const papier = Color(0xFFF1EDE4);
  static const papierGedaempft = Color(0xFFB9AEA0);
  static const blaugrau = Color(0xFF6E7F92);
  static const gefahr = Color(0xFFB3263A);
  static const notlicht = Color(0xFF2FBF5A);

  static const schreibmaschine = 'SpecialElite';
  static const schrift = 'Inter';

  static const titel = TextStyle(fontFamily: schreibmaschine, fontSize: 30, height: 1.2, color: kerzeHell, letterSpacing: 0.5);
  static const ueberschrift = TextStyle(fontFamily: schreibmaschine, fontSize: 21, height: 1.25, color: papier);
  static const text = TextStyle(fontFamily: schrift, fontSize: 17, height: 1.5, color: papier);
  static const leise = TextStyle(fontFamily: schrift, fontSize: 14, height: 1.45, color: papierGedaempft);
  static const marke = TextStyle(fontFamily: schrift, fontSize: 12, height: 1.3, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: kerze);

  /// Erzählertext: groß und ruhig lesbar, auch für Vorlesende.
  static const erzaehler = TextStyle(fontFamily: schrift, fontSize: 20, height: 1.6, color: papier);

  /// Maximale Inhaltsbreite auf großen Bildschirmen.
  static const breite = 760.0;
}

/// Seitenrahmen: Hintergrund, Kopf (Marke, Titel, Untertitel), Inhalt, Fuß mit Aktionen.
/// Rollbarer Inhalt mit sichtbarer Leiste und einem Hinweis am unteren Rand,
/// solange unten noch etwas folgt: Nichts wirkt abgeschnitten (B7).
class RollFlaeche extends StatefulWidget {
  const RollFlaeche({super.key, required this.child, this.padding = EdgeInsets.zero});

  final Widget child;
  final EdgeInsets padding;

  @override
  State<RollFlaeche> createState() => _RollFlaecheState();
}

class _RollFlaecheState extends State<RollFlaeche> {
  final _rolle = ScrollController();
  bool _mehr = false;

  void _pruefe() {
    if (!mounted || !_rolle.hasClients) return;
    final mehr = _rolle.position.extentAfter > 8;
    if (mehr != _mehr) setState(() => _mehr = mehr);
  }

  @override
  void initState() {
    super.initState();
    _rolle.addListener(_pruefe);
  }

  @override
  void dispose() {
    _rolle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _pruefe());
    return Stack(
      children: [
        Scrollbar(
          controller: _rolle,
          thumbVisibility: true,
          child: SingleChildScrollView(controller: _rolle, padding: widget.padding, child: widget.child),
        ),
        // Ein flacher Verlauf am Rand und ein kleiner Pfeil rechts außen: Er zeigt,
        // dass unten mehr folgt, ohne Buchstaben zu verdecken (E-038).
        if (_mehr) ...[
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: SizedBox(
                height: 18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x000B0A0E), Color(0xCC0B0A0E)]),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 2,
            child: IgnorePointer(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(color: Keller.nacht, shape: BoxShape.circle, border: Border.all(color: Keller.kerze)),
                child: const Icon(Icons.keyboard_arrow_down_rounded, color: Keller.kerze, size: 16),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class PartyRahmen extends StatelessWidget {
  const PartyRahmen({
    super.key,
    required this.child,
    this.marke,
    this.titel,
    this.untertitel,
    this.aktionen = const [],
    this.scroll = true,
  });

  final Widget child;
  final String? marke;
  final String? titel;
  final String? untertitel;
  final List<Widget> aktionen;
  final bool scroll;

  @override
  Widget build(BuildContext context) {
    final inhalt = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: scroll ? MainAxisSize.min : MainAxisSize.max,
      children: [
        if (marke != null) Text(marke!.toUpperCase(), style: Keller.marke),
        if (marke != null) const SizedBox(height: 6),
        if (titel != null) Text(titel!, style: Keller.titel),
        if (untertitel != null) ...[const SizedBox(height: 6), Text(untertitel!, style: Keller.leise)],
        if (titel != null || untertitel != null) const SizedBox(height: 20),
        if (scroll) child else Expanded(child: child),
      ],
    );
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.6),
          radius: 1.3,
          colors: [Color(0xFF1E1A22), Keller.nacht],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Keller.breite),
                  child: scroll
                      ? RollFlaeche(padding: const EdgeInsets.fromLTRB(20, 24, 20, 24), child: inhalt)
                      : Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 12), child: inhalt),
                ),
              ),
            ),
            if (aktionen.isNotEmpty)
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: Color(0xF00B0A0E),
                  border: Border(top: BorderSide(color: Keller.linie)),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: Keller.breite),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Wrap(alignment: WrapAlignment.end, spacing: 12, runSpacing: 8, children: aktionen),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Knopf im Kellerstil. [haupt] ist der warme Hauptknopf, sonst ein ruhiger Rahmenknopf.
class PartyKnopf extends StatelessWidget {
  const PartyKnopf({super.key, required this.text, required this.onPressed, this.haupt = true, this.icon});

  final String text;
  final VoidCallback? onPressed;
  final bool haupt;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = haupt
        ? FilledButton.styleFrom(
            backgroundColor: Keller.kerze,
            foregroundColor: const Color(0xFF1A1006),
            disabledBackgroundColor: Keller.steinHell,
            disabledForegroundColor: Keller.papierGedaempft,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            textStyle: const TextStyle(fontFamily: Keller.schrift, fontSize: 16, fontWeight: FontWeight.w700),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          )
        : OutlinedButton.styleFrom(
            foregroundColor: Keller.papier,
            side: const BorderSide(color: Keller.linieStark),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            textStyle: const TextStyle(fontFamily: Keller.schrift, fontSize: 16, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
    final kind = icon == null
        ? Text(text)
        : Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 20), const SizedBox(width: 8), Flexible(child: Text(text))]);
    return haupt ? FilledButton(onPressed: onPressed, style: style, child: kind) : OutlinedButton(onPressed: onPressed, style: style, child: kind);
  }
}

/// Tafel: Fläche für zusammengehörige Inhalte.
class PartyTafel extends StatelessWidget {
  const PartyTafel({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.akzent});

  final Widget child;
  final EdgeInsets padding;

  /// Farbiger linker Rand (z. B. Farbcode einer Figur).
  final Color? akzent;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Keller.stein,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Keller.linie),
          boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 18, offset: Offset(0, 6))],
        ),
        clipBehavior: Clip.antiAlias,
        child: akzent == null
            ? Padding(padding: padding, child: child)
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(width: 6, color: akzent),
                    Expanded(child: Padding(padding: padding, child: child)),
                  ],
                ),
              ),
      );
}

/// Kleiner Farbpunkt mit dem Farbcode einer Figur.
class FarbPunkt extends StatelessWidget {
  const FarbPunkt(this.farbe, {super.key, this.groesse = 14});
  final Color farbe;
  final double groesse;

  @override
  Widget build(BuildContext context) => Container(
        width: groesse,
        height: groesse,
        // Heller Rand, damit auch sehr dunkle Farbcodes auf dem dunklen Grund sichtbar sind (B7).
        decoration: BoxDecoration(color: farbe, shape: BoxShape.circle, border: Border.all(color: Keller.papierGedaempft, width: 1.5)),
      );
}
