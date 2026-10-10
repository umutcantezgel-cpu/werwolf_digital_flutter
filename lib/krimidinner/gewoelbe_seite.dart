import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:krimidinner_kanon/krimidinner_kanon.dart' show Gewoelbe, GewoelbeTexte, Mappe;

import '../app/router.dart';
import '../party/party_stil.dart';
import 'abschnitt_ansicht.dart';
import 'gewoelbe_stil.dart';
import 'kanon_laden.dart';
import 'teile/besetzung.dart';
import 'teile/druck.dart';
import 'teile/mappen.dart';
import 'teile/steckbriefe.dart';
import 'teile/ueberblick.dart';

/// Die fünf Teile des Begleiters.
enum GewoelbeTeil { ueberblick, besetzung, steckbriefe, mappen, druck }

/// Begleiter zum Krimidinner „Spuk im Gewölbe“: Überblick, Besetzung,
/// Steckbriefe, Rollenmappen (Gerät reihum) und Druck.
///
/// Ein geführter Abend ist das bewusst nicht. Alle Spieltexte kommen zur
/// Laufzeit aus dem Kanon; der Zustand (Teil, Besetzung, offene Mappe, gesehen)
/// liegt nur im Speicher.
class GewoelbeSeite extends StatefulWidget {
  const GewoelbeSeite({super.key, this.laden = ladeGewoelbeKanon, this.startTeil, this.startRollen});

  /// Entwickler- und Fotoeinstieg: `?teil=ueberblick|besetzung|steckbriefe|mappen|druck`
  /// und `?n=4…20`.
  factory GewoelbeSeite.ausUrl(Map<String, String> query) => GewoelbeSeite(
        startTeil: GewoelbeTeil.values.where((t) => t.name == query['teil']).firstOrNull,
        startRollen: int.tryParse(query['n'] ?? ''),
      );

  final KanonLader laden;
  final GewoelbeTeil? startTeil;
  final int? startRollen;

  @override
  State<GewoelbeSeite> createState() => _GewoelbeSeiteState();
}

/// Wie lange die Meldung „wieder zugedeckt“ stehen bleibt.
const _meldungDauer = Duration(seconds: 4);

class _GewoelbeSeiteState extends State<GewoelbeSeite> {
  late final Future<Gewoelbe> _gewoelbe = widget.laden().then(Gewoelbe.new);

  late GewoelbeTeil _teil = widget.startTeil ?? GewoelbeTeil.ueberblick;
  late int _rollen = (widget.startRollen ?? Gewoelbe.startRollen).clamp(Gewoelbe.minRollen, Gewoelbe.maxRollen);

  /// Person, deren Mappe gerade offen ist (`DET` oder `R01` …).
  String? _offen;

  /// Person in der Zwischenstufe „Gib das Gerät an …“.
  String? _vorbereitet;

  /// Personen, deren Mappe schon gesehen wurde.
  final Set<String> _gesehen = {};

  /// Meldung „Die Mappe von … ist wieder zugedeckt.“
  String? _meldung;
  Timer? _meldungTimer;

  late final AppLifecycleListener _lebenszyklus;

  @override
  void initState() {
    super.initState();
    // Geht die App in den Hintergrund, deckt sich eine offene Mappe selbst zu.
    _lebenszyklus = AppLifecycleListener(onHide: _verdecken);
  }

  @override
  void dispose() {
    _lebenszyklus.dispose();
    _meldungTimer?.cancel();
    super.dispose();
  }

  /// Deckt eine offene Mappe zu, merkt sie als gesehen und meldet es kurz.
  void _zudecken(Gewoelbe g) {
    final person = _offen;
    if (person == null) return;
    _meldungTimer?.cancel();
    _meldungTimer = Timer(_meldungDauer, () {
      if (mounted) setState(() => _meldung = null);
    });
    setState(() {
      _gesehen.add(person);
      _offen = null;
      _vorbereitet = null;
      _meldung = person == 'DET' ? GewoelbeTexte.zugedecktGeburtstagskind : GewoelbeTexte.zugedeckt(g.vorname(person));
    });
  }

  /// Automatisches Zudecken (App verborgen): ohne Gewölbe-Zugriff, still.
  void _verdecken() {
    if (_offen == null && _vorbereitet == null) return;
    setState(() {
      if (_offen != null) _gesehen.add(_offen!);
      _offen = null;
      _vorbereitet = null;
    });
  }

  void _wechsleTeil(GewoelbeTeil teil) {
    setState(() {
      if (_offen != null) _gesehen.add(_offen!);
      _offen = null;
      _vorbereitet = null;
      _teil = teil;
    });
  }

  void _setzeRollen(int n) {
    final neu = n.clamp(Gewoelbe.minRollen, Gewoelbe.maxRollen);
    if (neu == _rollen) return;
    setState(() {
      // Mit der Besetzung ändern sich die Mappen: alles wieder zugedeckt und ungesehen.
      _rollen = neu;
      _offen = null;
      _vorbereitet = null;
      _gesehen.clear();
      _meldung = null;
    });
  }

  void _zurueck() {
    final router = GoRouter.maybeOf(context);
    if (router == null) {
      Navigator.of(context).maybePop();
    } else if (router.canPop()) {
      router.pop();
    } else {
      router.go(Routes.hub);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wie alle Kacheln im Hub öffnet „go“ die Seite; darunter liegt dann kein Hub.
    // Im Router übernimmt die Seite die Zurück-Geste selbst ([_zurueck]) und führt
    // in den Hub, statt die App zu verlassen. Das gilt auch beim Laden und bei Fehlern.
    final imRouter = GoRouter.maybeOf(context) != null;
    return FutureBuilder<Gewoelbe>(
      future: _gewoelbe,
      builder: (context, snap) {
        final g = snap.data;
        return PopScope(
          // Eine offene Mappe deckt die Zurück-Geste zuerst zu, statt die Seite zu verlassen.
          canPop: _offen == null && !imRouter,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            if (_offen != null && g != null) {
              _zudecken(g);
            } else if (imRouter) {
              _zurueck();
            }
          },
          child: snap.hasError
              ? _rahmen(child: _fehler(snap.error!))
              : g == null
                  ? _rahmen(child: _laden())
                  : _geladen(g),
        );
      },
    );
  }

  /// Hintergrund, Kopf und Inhalt; unten optional die Navigation.
  Widget _rahmen({required Widget child, Widget? navigation, bool kopf = true}) => Scaffold(
        backgroundColor: Keller.nacht,
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: K9.grund),
          child: SafeArea(
            bottom: navigation == null,
            child: Column(
              children: [
                if (kopf) _kopf(),
                Expanded(child: child),
              ],
            ),
          ),
        ),
        bottomNavigationBar: navigation,
      );

  Widget _kopf() => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Keller.breite),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 20, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: _zurueck,
                  tooltip: GewoelbeTexte.zurueck,
                  icon: const Icon(Icons.arrow_back_rounded, color: Keller.papier),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(GewoelbeTexte.marke.toUpperCase(), style: Keller.marke),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(GewoelbeTexte.titel, maxLines: 1, style: Keller.titel.copyWith(fontSize: 27)),
                      ),
                      Text(GewoelbeTexte.untertitel, style: Keller.leise),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _laden() => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2.5, color: K9.akzent)),
              SizedBox(height: 16),
              Text(GewoelbeTexte.laden, textAlign: TextAlign.center, style: Keller.text),
            ],
          ),
        ),
      );

  Widget _fehler(Object fehler) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Keller.breite),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: PartyTafel(
              akzent: Keller.gefahr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(GewoelbeTexte.ladeFehler, style: Keller.ueberschrift),
                  const SizedBox(height: 8),
                  Text('$fehler', style: Keller.leise),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: PartyKnopf(text: GewoelbeTexte.zurueck, haupt: false, icon: Icons.arrow_back_rounded, onPressed: _zurueck),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _geladen(Gewoelbe g) {
    final offen = _offen;
    final Widget inhalt;
    if (offen != null) {
      inhalt = MappeAnsicht(
        key: ValueKey('mappe-$offen-$_rollen'),
        mappe: g.mappeFuer(offen, _rollen),
        onZudecken: () => _zudecken(g),
      );
    } else {
      inhalt = _flaeche(
        key: ValueKey(_teil),
        child: switch (_teil) {
          GewoelbeTeil.ueberblick => UeberblickTeil(gewoelbe: g),
          GewoelbeTeil.besetzung => BesetzungTeil(gewoelbe: g, rollen: _rollen, onRollen: _setzeRollen),
          GewoelbeTeil.steckbriefe => SteckbriefeTeil(
              gewoelbe: g,
              rollen: _rollen,
              onBesetzung: () => _wechsleTeil(GewoelbeTeil.besetzung),
            ),
          GewoelbeTeil.mappen => MappenTeil(
              gewoelbe: g,
              rollen: _rollen,
              gesehen: _gesehen,
              vorbereitet: _vorbereitet,
              meldung: _meldung,
              onVorbereiten: (p) => setState(() => _vorbereitet = p),
              onOeffnen: (p) => setState(() {
                _vorbereitet = null;
                _meldung = null;
                _offen = p;
              }),
              onBesetzung: () => _wechsleTeil(GewoelbeTeil.besetzung),
            ),
          GewoelbeTeil.druck => DruckTeil(
              gewoelbe: g,
              rollen: _rollen,
              onBesetzung: () => _wechsleTeil(GewoelbeTeil.besetzung),
            ),
        },
      );
    }
    return _rahmen(kopf: offen == null, navigation: _navigation(), child: inhalt);
  }

  /// Rollbarer Inhalt, höchstens [Keller.breite] breit, immer oben angesetzt:
  /// Kurze Inhalte (etwa die Zwischenstufe „Gib das Gerät an …“) springen so
  /// nicht in die Mitte.
  Widget _flaeche({required Key key, required Widget child}) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Keller.breite),
          child: RollFlaeche(key: key, padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), child: child),
        ),
      );

  Widget _navigation() => DecoratedBox(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Keller.linie))),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: K9.leiste,
            surfaceTintColor: Colors.transparent,
            indicatorColor: K9.akzent.withValues(alpha: 0.22),
            height: 68,
            labelTextStyle: WidgetStateProperty.resolveWith(
              (s) => TextStyle(
                fontFamily: Keller.schrift,
                fontSize: 12,
                fontWeight: s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
                color: s.contains(WidgetState.selected) ? Keller.kerzeHell : Keller.papierGedaempft,
              ),
            ),
            iconTheme: WidgetStateProperty.resolveWith(
              (s) => IconThemeData(color: s.contains(WidgetState.selected) ? K9.akzent : Keller.papierGedaempft),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _teil.index,
            onDestinationSelected: (i) => _wechsleTeil(GewoelbeTeil.values[i]),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.auto_stories_rounded), label: GewoelbeTexte.teilUeberblick),
              NavigationDestination(icon: Icon(Icons.groups_rounded), label: GewoelbeTexte.teilBesetzung),
              NavigationDestination(icon: Icon(Icons.badge_rounded), label: GewoelbeTexte.teilSteckbriefe),
              NavigationDestination(icon: Icon(Icons.visibility_off_rounded), label: GewoelbeTexte.teilMappen),
              NavigationDestination(icon: Icon(Icons.print_rounded), label: GewoelbeTexte.teilDruck),
            ],
          ),
        ),
      );
}

/// Die offene Mappe füllt die Seite; „Mappe zudecken“ steht oben und unten.
class MappeAnsicht extends StatelessWidget {
  const MappeAnsicht({super.key, required this.mappe, required this.onZudecken});

  final Mappe mappe;
  final VoidCallback onZudecken;

  @override
  Widget build(BuildContext context) {
    final zudecken = PartyKnopf(text: GewoelbeTexte.zudecken, icon: Icons.visibility_off_rounded, onPressed: onZudecken);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Keller.breite),
        child: RollFlaeche(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${GewoelbeTexte.rollenmappe} · ${GewoelbeTexte.nurFuer(mappe.name)}'.toUpperCase(),
                      style: Keller.marke,
                    ),
                  ),
                  const Icon(Icons.lock_rounded, color: Keller.kerze, size: 18),
                ],
              ),
              const SizedBox(height: 6),
              Text(_gross(mappe.name), style: Keller.titel),
              const SizedBox(height: 14),
              Align(alignment: Alignment.centerLeft, child: zudecken),
              const SizedBox(height: 18),
              for (final a in mappe.abschnitte) ...[
                AbschnittAnsicht(a),
                const SizedBox(height: 14),
              ],
              const SizedBox(height: 4),
              Align(alignment: Alignment.centerLeft, child: zudecken),
            ],
          ),
        ),
      ),
    );
  }
}

String _gross(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
