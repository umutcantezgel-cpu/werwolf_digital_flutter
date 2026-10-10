/// Zugriffsschicht des Begleiters „Spuk im Gewölbe“ mit Sichtklassen.
///
/// Die App liest den Kanon nur über [Gewoelbe]. Öffentliche Ansichten nehmen
/// nur Datensätze der Sicht `O`, Mappen zusätzlich die `G`-Datensätze der
/// eigenen Rolle. Für Sicht `L` gibt es keinen Zugriff.
library;

import 'ansichten.dart';
import 'kanon.dart';
import 'proben.dart' show tatsaechliche;
import 'texte.dart';
import 'textfilter.dart';

/// Im Kanon fehlen Pflichtkennungen (oder sie haben die falsche Sicht).
class GewoelbeFehler implements Exception {
  GewoelbeFehler(this.fehlend);

  /// Fehlende Kennungen, etwa `R07-LÜGE`, `G2-*` oder `K-005 (Sicht L statt O)`.
  final List<String> fehlend;

  @override
  String toString() =>
      'GewoelbeFehler: Im Kanon fehlen ${fehlend.length} Pflichtangaben: '
      '${fehlend.join(', ')}';
}

final _gespraech = RegExp(r'^G([1-3])-\d+$');
final _rollenKennung = RegExp(r'^R(\d\d)$');
final _ablaufZeit = RegExp(r'^(\d{1,2}:\d\d)\s+(.+)$');

String _nr2(int n) => n.toString().padLeft(2, '0');

/// Zugriffsschicht auf den Kanon mit Sichtklassen und Besetzungsfiltern.
class Gewoelbe {
  /// Prüft die Pflichtkennungen und wirft sonst [GewoelbeFehler].
  Gewoelbe(this._k) {
    final fehlend = pflichtBefunde(_k);
    if (fehlend.isNotEmpty) throw GewoelbeFehler(fehlend);
  }

  final KrimiKanon _k;

  static const minRollen = 4;
  static const maxRollen = 20;
  static const startRollen = 8;

  /// Pflichtdatensätze mit erwarteter Sicht und Pflichtfeldern.
  static Map<String, (Sicht, List<String>)> get pflicht {
    final p = <String, (Sicht, List<String>)>{
      'FÜNF-SÄTZE': (Sicht.o, ['Text']),
      for (var i = 1; i <= 11; i++) 'K-0${_nr2(i)}': (Sicht.o, ['Tatsache']),
      'ZM-1': (Sicht.o, ['Regel']),
      'ZM-2': (Sicht.o, ['Regel']),
      'ZM-3': (Sicht.o, ['Ablauf']),
      'ZM-4': (Sicht.o, ['Dauer']),
      for (final i in [1, 2, 3, 4, 5, 6, 8]) 'LR-$i': (Sicht.o, ['Regel']),
      for (var i = 1; i <= 4; i++) 'AK-$i': (Sicht.o, ['Schritt']),
      'DET-STAMM': (Sicht.o, ['Rolle im Spiel', 'Rolle im Streich']),
      'IF-7': (Sicht.o, ['Regel']),
      'DET-ALIBI': (Sicht.o, ['Alibi']),
      for (var i = 1; i <= 6; i++)
        'DET-B$i': (Sicht.g, ['Rolle', 'Beobachtung']),
      'BW-STAMM': (Sicht.o, ['Name', 'Aussprache', 'Alter', 'Herkunft']),
      'BW-ZUSTAND': (Sicht.o, ['Zustand']),
      for (var r = 1; r <= 20; r++) ...{
        'R${_nr2(r)}-STAMM': (
          Sicht.o,
          [
            'Name',
            'Aussprache',
            'Geschlecht',
            'Alter',
            'Wurzeln',
            'Familie',
            'Beruf',
            'Beziehung zum Geburtstagskind',
            'Kleidung',
            'Sprechweise',
          ],
        ),
        'R${_nr2(r)}-ÖFFENTLICH': (
          Sicht.o,
          [
            'Beziehung zum Burgwart (bekannt)',
            'Behauptetes Alibi',
            'Comedy-Beteiligung (sichtbar)',
          ],
        ),
        'R${_nr2(r)}-GEHEIM': (
          Sicht.g,
          [
            'Rolle',
            'Geheimnis',
            'Motiv',
            'Wahres Alibi',
            'Beziehung zum Burgwart (wahr)',
          ],
        ),
        'R${_nr2(r)}-WISSEN': (Sicht.g, ['Rolle', 'Wissen']),
        'R${_nr2(r)}-VERBINDUNGEN': (Sicht.g, ['Rolle', 'Verbindungen']),
        'R${_nr2(r)}-LÜGE': (
          Sicht.g,
          ['Rolle', 'Darf lügen über', 'Muss wahr sagen über'],
        ),
      },
      for (var p = 1; p <= 3; p++)
        for (var i = 1; i <= 3; i++)
          'D$p-$i': (Sicht.o, ['Frage', 'Option A', 'Option B', 'Option C']),
    };
    return p;
  }

  /// Was im Kanon für den Begleiter fehlt; leer, wenn alles da ist.
  static List<String> pflichtBefunde(KrimiKanon k) {
    final fehlend = <String>[];
    pflicht.forEach((id, soll) {
      final d = k.datensaetze[id];
      if (d == null) {
        fehlend.add(id);
        return;
      }
      if (d.sicht != soll.$1) {
        fehlend.add('$id (Sicht ${d.sicht.kuerzel} statt ${soll.$1.kuerzel})');
      }
      for (final feld in soll.$2) {
        if (d.feld(feld) == null) fehlend.add('$id.$feld');
      }
    });
    for (var p = 1; p <= 3; p++) {
      final da = k.datensaetze.values.any((d) {
        final m = _gespraech.firstMatch(d.id);
        return m != null && m.group(1) == '$p' && d.sicht == Sicht.g;
      });
      if (!da) fehlend.add('G$p-*');
    }
    return fehlend;
  }

  // Sichtklassen ---------------------------------------------------------------

  /// Datensatz der Sicht `O`; jede andere Sicht wirft [StateError].
  KanonDatensatz _o(String id) {
    final d = _k.datensaetze[id];
    if (d == null) throw StateError('Kennung $id fehlt im Kanon.');
    if (d.sicht != Sicht.o) {
      throw StateError('$id ist nicht öffentlich (Sicht ${d.sicht.kuerzel}).');
    }
    return d;
  }

  /// Datensatz der Sicht `G`, der zu [rolle] gehört; sonst [StateError].
  ///
  /// Gespräche gehören zu `Von`, `Ziel` und `Ersatz`, alle anderen zum Feld `Rolle`.
  KanonDatensatz _g(String id, String rolle) {
    final d = _k.datensaetze[id];
    if (d == null) throw StateError('Kennung $id fehlt im Kanon.');
    if (d.sicht != Sicht.g) {
      throw StateError(
        '$id ist kein Rollengeheimnis (Sicht ${d.sicht.kuerzel}).',
      );
    }
    final gehoert = _gespraech.hasMatch(d.id)
        ? [d.feld('Von'), d.feld('Ziel'), d.feld('Ersatz')].contains(rolle)
        : d.feld('Rolle') == rolle;
    if (!gehoert) throw StateError('$id gehört nicht zu $rolle.');
    return d;
  }

  String _wert(KanonDatensatz d, String feld) => d.feld(feld) ?? '';

  // Namen und Besetzung --------------------------------------------------------

  /// Die Rollen `R01` … `Rnn` bei Besetzung [n].
  List<String> rollen(int n) {
    _pruefeN(n);
    return [for (var r = 1; r <= n; r++) 'R${_nr2(r)}'];
  }

  /// Voller Name der Rolle oder „das Geburtstagskind“ für `DET`.
  String name(String rolle) => rolle == 'DET'
      ? GewoelbeTexte.geburtstagskindKlein
      : _wert(_o('$rolle-STAMM'), 'Name');

  /// Vorname der Rolle oder „das Geburtstagskind“ für `DET`.
  String vorname(String rolle) => rolle == 'DET'
      ? GewoelbeTexte.geburtstagskindKlein
      : name(rolle).split(' ').first;

  String _vornameNr(int nr) => vorname('R${_nr2(nr)}');

  void _pruefeN(int n) {
    if (n < minRollen || n > maxRollen) {
      throw ArgumentError.value(
        n,
        'n',
        'Die Besetzung muss zwischen $minRollen und $maxRollen Rollen liegen',
      );
    }
  }

  int _nummer(String rolle, int n) {
    final m = _rollenKennung.firstMatch(rolle);
    final nr = m == null ? null : int.parse(m.group(1)!);
    if (nr == null || nr < 1 || nr > n) {
      throw ArgumentError.value(
        rolle,
        'rolle',
        'Rolle ist bei $n Rollen nicht besetzt',
      );
    }
    return nr;
  }

  // Öffentliche Ansichten ------------------------------------------------------

  /// Überblick: Geschichte, Burg, Burgwart, Ablauf und Regeln (nur Sicht `O`).
  List<Abschnitt> get ueberblick {
    String o(String id, String feld) => ohneKennungen(_wert(_o(id), feld));
    final bw = _o('BW-STAMM');
    return [
      Abschnitt(
        titel: GewoelbeTexte.geschichte,
        eintraege: [Eintrag(o('FÜNF-SÄTZE', 'Text'))],
      ),
      Abschnitt(
        titel: GewoelbeTexte.burg,
        aufklappbar: true,
        eintraege: [
          for (var i = 1; i <= 8; i++) Eintrag(o('K-0${_nr2(i)}', 'Tatsache')),
        ],
      ),
      Abschnitt(
        titel: GewoelbeTexte.werInDerBurg,
        eintraege: [Eintrag(o('K-010', 'Tatsache'))],
      ),
      Abschnitt(
        titel: GewoelbeTexte.burgwart,
        eintraege: [
          for (final f in bw.felder.entries)
            Eintrag(
              _zeilen(ohneKennungen(f.value)),
              label: GewoelbeTexte.label(f.key),
            ),
          for (final f in _o('BW-ZUSTAND').felder.entries)
            Eintrag(ohneKennungen(f.value), label: GewoelbeTexte.label(f.key)),
        ],
      ),
      const Abschnitt(
        titel: GewoelbeTexte.werMitspielt,
        eintraege: [Eintrag(GewoelbeTexte.werMitspieltText)],
      ),
      Abschnitt(
        titel: GewoelbeTexte.ablauf,
        eintraege: [
          for (final teil in o('ZM-3', 'Ablauf').split(' · '))
            if (_ablaufZeit.firstMatch(teil.trim()) case final m?)
              Eintrag(m.group(2)!, label: m.group(1), art: EintragArt.punkt)
            else
              Eintrag(teil.trim(), art: EintragArt.punkt),
          const Eintrag(GewoelbeTexte.ablaufMinuten, art: EintragArt.hinweis),
        ],
      ),
      Abschnitt(
        titel: GewoelbeTexte.dauer,
        eintraege: [Eintrag(o('ZM-4', 'Dauer'))],
      ),
      Abschnitt(
        titel: GewoelbeTexte.gespraecheRegeln,
        eintraege: [Eintrag(o('ZM-1', 'Regel')), Eintrag(o('ZM-2', 'Regel'))],
      ),
      Abschnitt(
        titel: GewoelbeTexte.luegenRegeln,
        eintraege: [
          for (final i in [1, 2, 3, 4, 5, 6, 8])
            Eintrag(o('LR-$i', 'Regel'), art: EintragArt.punkt),
        ],
      ),
    ];
  }

  /// Besetzungsliste R01 … Rnn: Name, Aussprache, Geschlecht, Alter, Beruf.
  List<Abschnitt> besetzung(int n) => [
    for (final rolle in rollen(n)) _besetzungsZeile(rolle, n),
  ];

  Abschnitt _besetzungsZeile(String rolle, int n) {
    final st = _o('$rolle-STAMM');
    final name = _wert(st, 'Name');
    final geschlecht = switch (_wert(st, 'Geschlecht')) {
      final g when g.startsWith('w') => GewoelbeTexte.frau,
      final g when g.startsWith('m') => GewoelbeTexte.mann,
      _ => null,
    };
    return Abschnitt(
      schluessel: rolle,
      titel: name,
      untertitel: _wert(st, 'Aussprache'),
      initiale: _initiale(name),
      kopfzeile: [
        ?geschlecht,
        GewoelbeTexte.jahre(_wert(st, 'Alter')),
      ].join(' · '),
      eintraege: [Eintrag(filtereText(_wert(st, 'Beruf'), n))],
    );
  }

  /// Steckbriefe für alle: Geburtstagskind, Burgwart und je besetzter Rolle eine Karte.
  List<Abschnitt> steckbriefe(int n) => [
    detektivSteckbrief,
    burgwartSteckbrief,
    for (final rolle in rollen(n)) _steckbrief(rolle, n),
  ];

  /// Karte „Das Geburtstagskind“ (DET-STAMM, gekürzt auf „Rolle im Spiel“).
  ///
  /// Die übrigen Felder sind Produktionsangaben (Bezeichnung, Anrede, „werden nie
  /// genannt“) und erscheinen nicht als Spieltext.
  Abschnitt get detektivSteckbrief {
    final d = _o('DET-STAMM');
    return Abschnitt(
      schluessel: 'DET',
      titel: GewoelbeTexte.geburtstagskind,
      kopfzeile: ohneKennungen(_wert(d, 'Rolle im Spiel')),
    );
  }

  /// Karte „Der Burgwart“ (BW-STAMM).
  Abschnitt get burgwartSteckbrief {
    final d = _o('BW-STAMM');
    final name = _wert(d, 'Name');
    return Abschnitt(
      schluessel: 'BW',
      titel: GewoelbeTexte.burgwart,
      untertitel: name,
      initiale: _initiale(name),
      kopfzeile:
          '${GewoelbeTexte.jahre(_wert(d, 'Alter'))} · ${_wert(d, 'Herkunft')}',
      aufklappbar: true,
      eintraege: [
        for (final f in d.felder.entries)
          if (!const {'Name', 'Alter', 'Herkunft'}.contains(f.key))
            Eintrag(
              _zeilen(ohneKennungen(f.value)),
              label: GewoelbeTexte.label(f.key),
            ),
      ],
    );
  }

  /// Öffentlicher Steckbrief einer Rolle (STAMM und ÖFFENTLICH).
  Abschnitt _steckbrief(
    String rolle,
    int n, {
    bool mitKleidung = true,
    bool aufklappbar = true,
    String? titel,
  }) {
    final st = _o('$rolle-STAMM');
    final oe = _o('$rolle-ÖFFENTLICH');
    final name = _wert(st, 'Name');
    // F7: Ein Satz, der eine bei N unbesetzte Rolle nennt, fällt weg (etwa
    // „Zofia ruft …“ im Steckbrief von R17 bei N = 17 bis 19).
    final unbesetzt = [for (var r = n + 1; r <= maxRollen; r++) _vornameNr(r)];
    String t(KanonDatensatz d, String feld) =>
        ohneSaetzeMit(filtereText(_wert(d, feld), n), unbesetzt);
    Eintrag e(KanonDatensatz d, String feld) =>
        Eintrag(_zeilen(t(d, feld)), label: GewoelbeTexte.label(feld));
    return Abschnitt(
      schluessel: rolle,
      titel: titel ?? name,
      untertitel: _wert(st, 'Aussprache'),
      initiale: _initiale(name),
      kopfzeile: [
        GewoelbeTexte.jahre(_wert(st, 'Alter')),
        t(st, 'Wurzeln'),
        t(st, 'Beruf'),
      ].join(' · '),
      aufklappbar: aufklappbar,
      eintraege: [
        e(st, 'Beziehung zum Geburtstagskind'),
        if (mitKleidung) e(st, 'Kleidung'),
        e(st, 'Sprechweise'),
        e(st, 'Familie'),
        e(oe, 'Beziehung zum Burgwart (bekannt)'),
        e(oe, 'Behauptetes Alibi'),
        e(oe, 'Comedy-Beteiligung (sichtbar)'),
      ],
    );
  }

  // Mappen ---------------------------------------------------------------------

  /// Rollenmappe von [rolle] bei Besetzung [n]: Steckbrief, Geheimnis, Wissen,
  /// Verbindungen, Lügenregel und je Phase die Gespräche.
  Mappe mappe(String rolle, int n) {
    _pruefeN(n);
    final nr = _nummer(rolle, n);
    final st = _o('$rolle-STAMM');
    final geheim = _g('$rolle-GEHEIM', rolle);
    final wissen = _g('$rolle-WISSEN', rolle);
    final verbindungen = _g('$rolle-VERBINDUNGEN', rolle);
    final luege = _g('$rolle-LÜGE', rolle);
    String t(KanonDatensatz d, String feld) => filtereText(_wert(d, feld), n);
    Eintrag e(KanonDatensatz d, String feld) =>
        Eintrag(_zeilen(t(d, feld)), label: GewoelbeTexte.label(feld));

    return Mappe(
      schluessel: rolle,
      nummer: nr,
      name: name(rolle),
      anrede: vorname(rolle),
      abschnitte: [
        _steckbrief(
          rolle,
          n,
          mitKleidung: false,
          aufklappbar: false,
          titel: GewoelbeTexte.dossierSteckbrief,
        ),
        Abschnitt(
          titel: GewoelbeTexte.dossierKleidung,
          eintraege: [Eintrag(t(st, 'Kleidung'))],
        ),
        Abschnitt(
          titel: GewoelbeTexte.dossierGeheimnis,
          eintraege: [
            for (final feld in [
              'Geheimnis',
              'Motiv',
              'Wahres Alibi',
              'Beziehung zum Burgwart (wahr)',
            ])
              e(geheim, feld),
          ],
        ),
        Abschnitt(
          titel: GewoelbeTexte.dossierWissen,
          eintraege: [
            for (final punkt in filtereListe(_wert(wissen, 'Wissen'), n))
              if (uhrzeitVorne(punkt) case (final zeit, final rest))
                Eintrag(rest, label: zeit, art: EintragArt.punkt),
          ],
        ),
        Abschnitt(
          titel: GewoelbeTexte.dossierVerbindungen,
          eintraege: [
            for (final v in filtereVerbindungen(
              _wert(verbindungen, 'Verbindungen'),
              n,
              name: _vornameNr,
              geburtstagskind: GewoelbeTexte.geburtstagskindKlein,
              burgwart: GewoelbeTexte.burgwartKlein,
            ))
              // Jede Verbindung steht gleich: der Name als Label, dahinter die
              // Erläuterung, falls der Kanon eine nennt.
              Eintrag(
                v.erlaeuterung ?? '',
                label: _gross(v.name),
                art: EintragArt.punkt,
              ),
          ],
        ),
        Abschnitt(
          titel: GewoelbeTexte.dossierLuege,
          eintraege: [
            e(luege, 'Darf lügen über'),
            e(luege, 'Muss wahr sagen über'),
          ],
        ),
        for (var p = 1; p <= 3; p++) _gespraeche(rolle, nr, p, n),
      ],
    );
  }

  /// Abschnitt „Deine Gespräche“ einer Phase: Aufträge und Antworten.
  Abschnitt _gespraeche(String rolle, int nr, int phase, int n) {
    final auftraege = <Eintrag>[];
    final antworten = <Eintrag>[];
    for (final (von, an, roh, art) in tatsaechliche(_k, phase, n)) {
      if (von != nr && an != nr) continue;
      final g = _g(roh.id, rolle);
      final ersatz = art == 'ersatz';
      String t(String feld) =>
          filtereText(_wert(g, ersatz ? 'Ersatz-$feld' : feld), n);
      if (von == nr && an != null) {
        auftraege
          ..add(
            Eintrag(
              t('Frage'),
              label: GewoelbeTexte.frag(_vornameNr(an)),
              block: true,
            ),
          )
          ..add(Eintrag(t('Bedingung'), label: GewoelbeTexte.worumEsGeht));
      }
      if (an == nr) {
        antworten
          ..add(
            Eintrag(
              t('Frage'),
              label: GewoelbeTexte.fragt(_vornameNr(von)),
              block: true,
            ),
          )
          ..add(Eintrag(t('Antwort'), label: GewoelbeTexte.deineAntwort));
        final hinweis = _antwortHinweis(t('Antwortart'));
        if (hinweis != null) {
          antworten.add(Eintrag(hinweis, art: EintragArt.hinweis));
        }
      }
    }
    return Abschnitt(
      schluessel: 'P$phase',
      titel:
          '${GewoelbeTexte.dossierGespraeche} · ${GewoelbeTexte.phase(phase)}',
      neueSeite: true,
      eintraege: [
        const Eintrag(GewoelbeTexte.auftraege, art: EintragArt.zwischentitel),
        if (auftraege.isEmpty)
          const Eintrag(GewoelbeTexte.keineAuftraege)
        else
          ...auftraege,
        const Eintrag(
          GewoelbeTexte.wennManDichFragt,
          art: EintragArt.zwischentitel,
        ),
        if (antworten.isEmpty)
          const Eintrag(GewoelbeTexte.niemandFragt)
        else
          ...antworten,
      ],
    );
  }

  String? _antwortHinweis(String art) {
    if (art.startsWith('wahr')) return GewoelbeTexte.antwortWahr;
    if (art.startsWith('ausweichend')) return GewoelbeTexte.antwortAusweichend;
    if (art.startsWith('gelogen')) return GewoelbeTexte.antwortGelogen;
    return null;
  }

  /// Mappe des Geburtstagskinds: wer es ist, Alibi, Beobachtungen, wann die
  /// Entscheidungen fallen, Anklage.
  ///
  /// Die Mappe ist das, was zu Beginn auf dem Tisch liegt (IF-4): die eigenen
  /// Beobachtungen DET-B1 bis DET-B6. Die neun Entscheidungen D1-1 bis D3-3
  /// fallen erst in ihrer Phase nach der Lagerunde (IF-7) und verraten Inhalte
  /// späterer Phasen (etwa die Aussage des Burgwarts zum Start von Phase 2 oder
  /// die Sohlenkarten aus Phase 3). Deshalb stehen sie nicht in der Mappe.
  Mappe detektivMappe() {
    final stamm = _o('DET-STAMM');
    String o(String id, String feld) => ohneKennungen(_wert(_o(id), feld));
    return Mappe(
      schluessel: 'DET',
      nummer: 0,
      name: GewoelbeTexte.geburtstagskindKlein,
      anrede: GewoelbeTexte.geburtstagskindKlein,
      abschnitte: [
        Abschnitt(
          schluessel: 'DET',
          titel: GewoelbeTexte.detektivWer,
          eintraege: [
            for (final feld in ['Rolle im Spiel', 'Rolle im Streich'])
              Eintrag(
                ohneKennungen(_wert(stamm, feld)),
                label: GewoelbeTexte.label(feld),
              ),
          ],
        ),
        Abschnitt(
          titel: GewoelbeTexte.detektivAlibi,
          eintraege: [Eintrag(o('DET-ALIBI', 'Alibi'))],
        ),
        Abschnitt(
          titel: GewoelbeTexte.detektivBeobachtet,
          eintraege: [
            for (var i = 1; i <= 6; i++)
              Eintrag(
                ohneKennungen(_wert(_g('DET-B$i', 'DET'), 'Beobachtung')),
                art: EintragArt.punkt,
              ),
          ],
        ),
        Abschnitt(
          schluessel: 'D',
          titel: GewoelbeTexte.detektivEntscheidungen,
          eintraege: [
            Eintrag(o('IF-7', 'Regel')),
            const Eintrag(
              GewoelbeTexte.detektivEntscheidungenHinweis,
              art: EintragArt.hinweis,
            ),
          ],
        ),
        Abschnitt(
          titel: GewoelbeTexte.anklage,
          eintraege: [
            for (var i = 1; i <= 4; i++)
              Eintrag(
                o('AK-$i', 'Schritt'),
                label: GewoelbeTexte.schritt(i),
                art: EintragArt.punkt,
              ),
          ],
        ),
      ],
    );
  }

  /// Alle Personen mit Mappe bei Besetzung [n]: das Geburtstagskind, dann R01 … Rnn.
  List<String> mappenPersonen(int n) => ['DET', ...rollen(n)];

  /// Mappe für `DET` oder eine Rolle.
  Mappe mappeFuer(String person, int n) =>
      person == 'DET' ? detektivMappe() : mappe(person, n);
}

/// Erster Buchstabe eines Namens (für das Namensschild).
String _initiale(String name) =>
    name.isEmpty ? '?' : String.fromCharCode(name.runes.first).toUpperCase();

/// Erster Buchstabe groß (für Labels wie „Das Geburtstagskind“).
String _gross(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// Nummerierte Werte (`1) … 2) …`) stehen zeilenweise.
String _zeilen(String s) => nummerierteZeilen(s).join('\n');
