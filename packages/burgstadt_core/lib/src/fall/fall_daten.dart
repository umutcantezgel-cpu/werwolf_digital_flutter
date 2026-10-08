import '../kanon/kanon.dart';
import 'faehigkeiten.dart';

/// Typisierte Falldaten aus dem wirksamen Kanon (Original + Overlay).
class Hinweis {
  /// Sortierschlüssel einer Hinweis-Kennung: Kanon H-1…H-257 zuerst, dann die
  /// Stadt-Hinweise H-S01… aus der Anpassung.
  static int reihenfolge(String id) =>
      id.startsWith('H-S') ? 100000 + (int.tryParse(id.substring(3)) ?? 0) : (int.tryParse(id.substring(2)) ?? 0);

  final String id;
  final Sicht sicht;
  final String inhalt, form, quelle;
  final int phase, min;
  final String? rolle; // nur für [G]-Hinweise einer Rolle
  // Wahrheit (HW, Sicht L – nur Bots/Löser/Auflösung)
  final String wahrheit, einstufung;
  final Set<String> stuetzt;
  final bool blockierbar;
  // Herkunft
  final String? gespraech; // G-Kennung
  final bool ersatzfall;
  final String? station; // Stations-Kennung in der Welt
  final bool meldekarte, erzaehler, detektivMappe, aufVerlangen;

  const Hinweis({
    required this.id,
    required this.sicht,
    required this.inhalt,
    required this.form,
    required this.quelle,
    required this.phase,
    required this.min,
    this.rolle,
    required this.wahrheit,
    required this.einstufung,
    required this.stuetzt,
    required this.blockierbar,
    this.gespraech,
    this.ersatzfall = false,
    this.station,
    this.meldekarte = false,
    this.erzaehler = false,
    this.detektivMappe = false,
    this.aufVerlangen = false,
  });

  bool get echt => einstufung.startsWith('echt');
}

class Gespraech {
  final String id;
  final int phase, nr, min;
  final String von;
  final String? ziel, ersatz;
  final String bedingung, frage, antwort, antwortart;
  final List<String> gibt;
  final String ersatzBedingung, ersatzFrage, ersatzAntwort, ersatzArt;
  final List<String> ersatzGibt;
  final String? zusammenfall;

  const Gespraech({
    required this.id,
    required this.phase,
    required this.nr,
    required this.min,
    required this.von,
    this.ziel,
    this.ersatz,
    required this.bedingung,
    required this.frage,
    required this.antwort,
    required this.antwortart,
    required this.gibt,
    required this.ersatzBedingung,
    required this.ersatzFrage,
    required this.ersatzAntwort,
    required this.ersatzArt,
    required this.ersatzGibt,
    this.zusammenfall,
  });
}

class Option {
  final String text, folge;
  const Option(this.text, this.folge);

  /// Hinweis-Kennungen, die die Folge nennt.
  List<String> get hinweise => [for (final m in RegExp(r'\bH-\d+\b').allMatches(folge)) m.group(0)!];

  /// Macht die Folge etwas öffentlich (laut sagen, offen legen, an den Detektiv)?
  bool get oeffentlich {
    final f = folge.toLowerCase();
    const leise = ['behältst', 'verschweigst', 'schweigst', 'sagst nichts', 'für dich', 'nicht weiter'];
    if (leise.any(f.contains)) return false;
    return true;
  }
}

class RollenEntscheidung {
  final String id, rolle, lage, umsetzung;
  final int phase;
  final List<Option> optionen;
  const RollenEntscheidung(this.id, this.phase, this.rolle, this.lage, this.optionen, this.umsetzung);
}

class DetektivEntscheidung {
  final String id, frage;
  final int phase;
  final Map<String, String> optionen; // A/B/C → Text
  final List<String> begruendbar;
  final String echte, falsche, ablenkung;
  final Map<String, int> punkte;
  final Map<String, String> ergebnisse;
  const DetektivEntscheidung(this.id, this.phase, this.frage, this.optionen, this.begruendbar, this.echte, this.falsche,
      this.ablenkung, this.punkte, this.ergebnisse);
}

class Rolle {
  final String id, name, aussprache, geschlecht, beruf, kleidung, sprechweise;
  final int alter;
  final String behauptetesAlibi, oeffentlicheBeziehung;
  final String darfLuegen;
  const Rolle(this.id, this.name, this.aussprache, this.geschlecht, this.alter, this.beruf, this.kleidung, this.sprechweise,
      this.behauptetesAlibi, this.oeffentlicheBeziehung, this.darfLuegen);
  int get nummer => int.parse(id.substring(1));
}

class FallDaten {
  final Kanon kanon;
  final Map<String, Hinweis> hinweise = {};

  /// Rollen-Fähigkeiten (aus `data/rollen/faehigkeiten.json`, vom Lader gesetzt).
  final Map<String, Faehigkeit> faehigkeiten = {};
  final Map<String, Gespraech> gespraeche = {};
  final Map<String, RollenEntscheidung> rollenEntscheidungen = {};
  final Map<String, DetektivEntscheidung> detektivEntscheidungen = {};
  final Map<String, Rolle> rollen = {};
  final Map<int, String> burgwartAussagen = {};
  final Map<String, String> meldekarten = {}; // MK1-R01 → Text
  final Map<String, Set<String>> schluesse = {}; // S-1 → Hinweise (notwendige)
  final Set<String> notwendig = {};
  final Map<String, String> schlussText = {};

  FallDaten(this.kanon) {
    _lese();
  }

  String _f(KanonDatensatz d, String name) => d.feld(name) ?? '';

  static int _zahl(String s, int ersatz) => int.tryParse(RegExp(r'\d+').firstMatch(s)?.group(0) ?? '') ?? ersatz;

  static List<String> _hs(String s) => [for (final m in RegExp(r'\bH-S?\d+\b').allMatches(s)) m.group(0)!];

  /// Ordnet eine Hinweis-Quelle einer Station in der Welt zu.
  static String? stationFuer(String quelle) {
    if (quelle.contains('Sohlenkarten')) return 'BW';
    // Stadt-Hinweise der Oberstadt (Overlay H-S…): Station am Fall-Ort ORT-nn
    final ort = RegExp(r'\bORT-\d\d\b').firstMatch(quelle);
    if (ort != null) return ort.group(0);
    final bs = RegExp(r'BS-(\d+)').firstMatch(quelle);
    if (bs != null) {
      final n = bs.group(0)!;
      if (n == 'BS-02' || n == 'BS-07') return 'Kunibert';
      if (n == 'BS-10' || n == 'BS-13') return 'BW';
      return n;
    }
    if (quelle.contains('Kunibert')) return 'Kunibert';
    if (quelle.contains('Station Speisekammer')) return 'BS-09';
    if (quelle.contains('Station Hof')) return 'BS-11';
    if (quelle.contains('Station Turm')) return 'BS-04';
    if (quelle.contains('Station Kamin-Gewölbe')) return 'BS-12';
    return null;
  }

  void _lese() {
    final k = kanon;
    for (final d in k.datensaetze.values) {
      final id = d.id;
      if (RegExp(r'^H-S?\d+$').hasMatch(id)) {
        final hw = k.datensaetze['HW-${id.substring(2)}'];
        final quelle = _f(d, 'Quelle');
        final g = RegExp(r'\b(G\d-\d+)\b').firstMatch(quelle)?.group(1);
        hinweise[id] = Hinweis(
          id: id,
          sicht: d.sicht,
          inhalt: _f(d, 'Inhalt'),
          form: _f(d, 'Form'),
          quelle: quelle,
          phase: _zahl(_f(d, 'Phase'), 1),
          min: _zahl(_f(d, 'Min'), 4),
          rolle: d.feld('Rolle'),
          wahrheit: hw == null ? '' : _f(hw, 'Wahrheit'),
          einstufung: hw == null ? '' : _f(hw, 'Einstufung'),
          stuetzt: hw == null ? {} : {for (final m in RegExp(r'\bS-\d+\b').allMatches(_f(hw, 'Stützt'))) m.group(0)!},
          blockierbar: hw != null && !_f(hw, 'Blockierbar durch').toLowerCase().startsWith('nein'),
          gespraech: g,
          ersatzfall: quelle.contains('Ersatzfall'),
          station: g == null ? stationFuer(quelle) : null,
          meldekarte: quelle.contains('Meldekarte'),
          erzaehler: quelle.startsWith('Erzähler'),
          detektivMappe: quelle.contains('Detektiv-Mappe'),
          aufVerlangen: quelle.contains('auf Verlangen'),
        );
      } else if (RegExp(r'^G\d-\d+$').hasMatch(id)) {
        final p = id.substring(1).split('-');
        String? r(String f) {
          final v = d.feld(f);
          return v == null || v.isEmpty || v == '–' ? null : v;
        }

        gespraeche[id] = Gespraech(
          id: id,
          phase: int.parse(p[0]),
          nr: int.parse(p[1]),
          min: _zahl(_f(d, 'Min'), 4),
          von: _f(d, 'Von'),
          ziel: r('Ziel'),
          ersatz: r('Ersatz'),
          bedingung: _f(d, 'Bedingung'),
          frage: _f(d, 'Frage'),
          antwort: _f(d, 'Antwort'),
          antwortart: _f(d, 'Antwortart'),
          gibt: _hs(_f(d, 'Gibt heraus')),
          ersatzBedingung: r('Ersatz-Bedingung') ?? '',
          ersatzFrage: r('Ersatz-Frage') ?? '',
          ersatzAntwort: r('Ersatz-Antwort') ?? '',
          ersatzArt: r('Ersatz-Antwortart') ?? '',
          ersatzGibt: _hs(_f(d, 'Ersatz gibt heraus')),
          zusammenfall: RegExp(r'G\d-\d+').firstMatch(_f(d, 'Zusammenfall'))?.group(0),
        );
      } else if (RegExp(r'^E\d-\d+$').hasMatch(id)) {
        final opts = <Option>[];
        for (var i = 1; i <= 4; i++) {
          final o = d.feld('Option $i');
          if (o == null) continue;
          final teile = o.split('→ Folge:');
          opts.add(Option(teile[0].trim(), teile.length > 1 ? teile[1].trim() : ''));
        }
        rollenEntscheidungen[id] = RollenEntscheidung(id, int.parse(id[1]), _f(d, 'Rolle'), _f(d, 'Lage'), opts, _f(d, 'Umsetzung'));
      } else if (RegExp(r'^D\d-\d+$').hasMatch(id)) {
        final w = k.datensaetze['DW${id.substring(1)}'];
        final punkte = <String, int>{};
        if (w != null) {
          for (final m in RegExp(r'([ABC])\s*=\s*(\d)').allMatches(_f(w, 'Punkte'))) {
            punkte[m.group(1)!] = int.parse(m.group(2)!);
          }
        }
        detektivEntscheidungen[id] = DetektivEntscheidung(
          id,
          _zahl(_f(d, 'Phase'), 1),
          _f(d, 'Frage'),
          {for (final o in ['A', 'B', 'C']) o: _f(d, 'Option $o')},
          _hs(_f(d, 'Begründbar durch')),
          w == null ? '' : _f(w, 'Echte Spur'),
          w == null ? '' : _f(w, 'Falsche Fährte'),
          w == null ? '' : _f(w, 'Ablenkung'),
          punkte,
          {for (final o in ['A', 'B', 'C']) o: w == null ? '' : _f(w, 'Ergebnis $o')},
        );
      } else if (RegExp(r'^R\d\d-STAMM$').hasMatch(id)) {
        final rid = id.substring(0, 3);
        final oe = k.datensaetze['$rid-ÖFFENTLICH'];
        final lu = k.datensaetze['$rid-LÜGE'];
        rollen[rid] = Rolle(
          rid,
          _f(d, 'Name'),
          _f(d, 'Aussprache'),
          _f(d, 'Geschlecht'),
          _zahl(_f(d, 'Alter'), 30),
          _f(d, 'Beruf'),
          _f(d, 'Kleidung'),
          _f(d, 'Sprechweise'),
          oe == null ? '' : _f(oe, 'Behauptetes Alibi'),
          oe == null ? '' : _f(oe, 'Beziehung zum Burgwart (bekannt)'),
          lu == null ? '' : _f(lu, 'Darf lügen über'),
        );
      } else if (RegExp(r'^BW-AUSSAGE-\d$').hasMatch(id)) {
        burgwartAussagen[int.parse(id.substring(11))] = _f(d, 'Aussage');
      } else if (RegExp(r'^MK\d-R\d\d$').hasMatch(id)) {
        meldekarten[id] = _f(d, 'Text');
      } else if (RegExp(r'^S-\d+$').hasMatch(id)) {
        schlussText[id] = _f(d, 'Schlussfolgerung');
        final hs = _hs(_f(d, 'Hinweise')).toSet();
        if (_f(d, 'Notwendig').toLowerCase() == 'ja') notwendig.add(id);
        schluesse[id] = hs;
      }
    }
    // Stützende Hinweise aus HW ergänzen (wie kanon.py)
    for (final h in hinweise.values) {
      for (final s in h.stuetzt) {
        schluesse.putIfAbsent(s, () => {}).add(h.id);
      }
    }
  }

  /// Rollen 1..n in fester Reihenfolge.
  List<String> rollenBis(int n) => [for (var i = 1; i <= n; i++) 'R${i.toString().padLeft(2, '0')}'];

  /// Bei Besetzung [n] tatsächlich stattfindende Gespräche einer Phase:
  /// (Gespräch, tatsächliches Ziel, Ersatzfall?).
  List<(Gespraech, String, bool)> gespraecheFuer(int phase, int n) {
    final out = <(Gespraech, String, bool)>[];
    for (final g in gespraeche.values.where((g) => g.phase == phase)) {
      final von = _nr(g.von);
      if (von == null || von > n) continue;
      final ziel = _nr(g.ziel), ers = _nr(g.ersatz);
      if (ziel != null && ziel <= n) {
        out.add((g, g.ziel!, false));
      } else if (ers != null && ers <= n) {
        out.add((g, g.ersatz!, true));
      }
    }
    out.sort((a, b) => a.$1.nr.compareTo(b.$1.nr));
    return out;
  }

  static int? _nr(String? r) {
    if (r == null) return null;
    final m = RegExp(r'^R(\d\d)').firstMatch(r);
    return m == null ? null : int.parse(m.group(1)!);
  }

  /// Ist Hinweis [h] bei Besetzung [n] im Spiel? (wie `verfuegbar` in kanon.py)
  bool imSpiel(Hinweis h, int n) {
    final g = h.gespraech == null ? null : gespraeche[h.gespraech];
    if (g != null) {
      final von = _nr(g.von);
      if (von == null || von > n) return false;
      final ziel = _nr(g.ziel);
      if (ziel != null && ziel <= n) return g.gibt.contains(h.id);
      return g.ersatzGibt.contains(h.id);
    }
    return h.min <= n;
  }
}
