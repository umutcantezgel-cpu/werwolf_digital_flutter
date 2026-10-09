/// Leitplanken-Scanner für „Burgstadt Schartenfels“ (Auftrag A-406).
///
/// Prüft Spieltexte auf Wörter, die nach VERBOTE-LEITPLANKEN und Master-Prompt §3
/// nicht vorkommen dürfen. Ein Treffer ist ein Fehler (Verstoß) oder eine
/// Warnung (von Hand prüfen, z. B. „Kater“ als Tier). Reines Dart, ohne Flutter.
library;

import 'dart:convert';
import 'dart:io';

import '../io/repo.dart';

const _ausnahmenPfad = 'nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md';

/// Ein Fund im Text.
class LeitplankenTreffer {
  const LeitplankenTreffer({
    required this.datei,
    required this.zeile,
    required this.wort,
    required this.fehler,
    required this.ausschnitt,
  });

  /// Dateipfad; bei Text ohne Datei `-`.
  final String datei;

  /// Zeilennummer, ab 1.
  final int zeile;

  /// Das gefundene Wort, so wie es im Text steht.
  final String wort;

  /// `true` für einen Fehler, `false` für eine Warnung.
  final bool fehler;

  /// Ausschnitt der Zeile rund um das Wort.
  final String ausschnitt;

  @override
  String toString() =>
      '$datei:$zeile · ${fehler ? 'Fehler' : 'Warnung'} · $wort · „$ausschnitt“';
}

/// Ausnahmen aus `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md`.
///
/// Format je Zeile: `Datei | Wort | Begründung`. Zeilen ohne Begründung,
/// Kommentarzeilen (`#`) und die Kopfzeile werden ignoriert.
class LeitplankenAusnahmen {
  LeitplankenAusnahmen._(this._schluessel);

  /// Liest die Ausnahmen aus dem Inhalt der Ausnahmen-Datei.
  factory LeitplankenAusnahmen.parse(String inhalt) {
    final schluessel = <String>{};
    for (final roh in inhalt.split('\n')) {
      final zeile = roh.trim();
      if (zeile.isEmpty || zeile.startsWith('#')) continue;
      final teile = zeile.split('|').map((t) => t.trim()).toList();
      if (teile.length < 3) continue;
      final datei = _normPfad(teile[0]);
      final wort = teile[1];
      final begruendung = teile.sublist(2).join('|').trim();
      if (datei.isEmpty || wort.isEmpty || begruendung.isEmpty) continue;
      if (datei == 'Datei' && wort == 'Wort') continue;
      schluessel.add('$datei\n${_falte(wort)}');
    }
    return LeitplankenAusnahmen._(schluessel);
  }

  final Set<String> _schluessel;

  /// Ob ein Treffer durch eine Ausnahme abgedeckt ist (gleiche Datei, gleiches Wort).
  bool befreit(LeitplankenTreffer t) =>
      _schluessel.contains('${_normPfad(t.datei)}\n${_falte(t.wort)}');
}

/// Eine Verbotsregel. Ein Wort trifft zu, wenn es genau (`gross`), als ganzes
/// Wort (`formen`, klein geschrieben), mit einem Wortanfang (`praefix`) oder
/// einem Wortende (`suffix`) übereinstimmt. Die Ausnahmen heben einen Treffer
/// über Wortanfang bzw. Wortende wieder auf. Alle Angaben außer `gross` sind
/// gefaltet (ß zu ss; ț, ș, ş, ă, â, î zu t, s, s, a, a, i).
class _Regel {
  const _Regel(
    this.fehler, {
    this.gross = const <String>{},
    this.formen = const <String>{},
    this.praefix = const <String>[],
    this.suffix = const <String>[],
    this.ausnahmen = const <String>{},
    this.ausnahmenPraefix = const <String>[],
    this.ausnahmenSuffix = const <String>[],
  });

  final bool fehler;
  final Set<String> gross;
  final Set<String> formen;
  final List<String> praefix;
  final List<String> suffix;
  final Set<String> ausnahmen;
  final List<String> ausnahmenPraefix;
  final List<String> ausnahmenSuffix;

  /// [wort] ist das Wort wie geschrieben, [k] seine gefaltete Kleinform.
  bool passt(String wort, String k) {
    if (gross.contains(wort)) return true;
    if (formen.contains(k)) return true;
    if (ausnahmen.contains(k)) return false;
    if (ausnahmenPraefix.any(k.startsWith)) return false;
    if (ausnahmenSuffix.any(k.endsWith)) return false;
    return praefix.any(k.startsWith) || suffix.any(k.endsWith);
  }
}

/// Mehrwort-Verbot, z. B. „auf ex“. Das zweite Wort steht gefaltet fest.
class _Phrase {
  const _Phrase(this.erster, this.zweiter, this.fehler);

  final Set<String> erster;
  final String zweiter;
  final bool fehler;
}

/// Verbotstabelle. Die Reihenfolge ist ohne Wirkung: Ein Fehler-Treffer schlägt
/// jede Warnung. Ausnahmen gelten nur für die eigene Regel. Harmlose Wörter mit
/// Fehlalarm-Potenzial sind ausdrücklich ausgenommen („weinen“, „Schwein“,
/// „Bargeld“, „Drogerie“, „alkoholfrei“ …).
const _regeln = <_Regel>[
  // ---- Alkohol: Wortstämme mit Flexion und Komposita (Fehler) ----
  _Regel(
    true,
    praefix: ['wein'],
    suffix: ['wein'],
    ausnahmen: {
      'weinen', 'weine', 'weint', 'weinet', 'weinte', 'weinten', //
      'weinest', 'weintest', 'weintet', 'weinend', 'weinende',
      'weinenden', 'weinender', 'weinendes', 'weinst', 'weinerlich',
      'weinerliche', 'weinerlichen', 'weinerlicher', 'weinerliches',
    },
    ausnahmenPraefix: ['weinkr'],
    ausnahmenSuffix: ['schwein'],
  ),
  _Regel(
    true,
    praefix: ['bier'],
    suffix: ['bier'],
    ausnahmenPraefix: ['bierernst'],
  ),
  _Regel(
    true,
    praefix: ['sekt'],
    suffix: ['sekt'],
    ausnahmenPraefix: ['sektion', 'sektor', 'sekte', 'sektier'],
    ausnahmenSuffix: ['insekt'],
  ),
  _Regel(
    true,
    praefix: ['schnaps', 'schnapps'],
    suffix: ['schnaps', 'schnapps'],
    ausnahmenPraefix: ['schnapszahl'],
  ),
  _Regel(true, praefix: ['likör', 'likoer'], suffix: ['likör', 'likoer']),
  _Regel(true, praefix: ['cocktail'], suffix: ['cocktail']),
  _Regel(
    true,
    praefix: ['glühwein', 'gluehwein'],
    suffix: ['glühwein', 'gluehwein'],
  ),
  _Regel(
    true,
    praefix: ['kneipe'],
    suffix: ['kneipe'],
    formen: {'kneipier', 'kneipiers'},
  ),
  _Regel(
    true,
    gross: {'Bar', 'Bars'},
    praefix: [
      'barkeeper', 'barhocker', 'bartresen', 'barbesuch', 'barbetrieb', //
      'barbesitz', 'barabend', 'barmann', 'barfrau', 'barkellner',
    ],
  ),
  _Regel(true, gross: {'Met', 'Mets'}, formen: {'honigmet', 'honigmets'}),
  _Regel(
    true,
    gross: {'Rum', 'Rums'},
    praefix: ['rumpunsch', 'rumtopf', 'rumverschnitt'],
  ),
  _Regel(true, gross: {'Gin', 'Gins'}),
  _Regel(
    true,
    formen: {'raki', 'ouzo', 'grog', 'beer', 'wine'},
    praefix: [
      'whisky', 'whiskey', 'wodka', 'vodka', 'tequila', 'absinth', //
      'rakija', 'palinka', 'pálinka', 'slibo', 'slivo', 'sliwo',
      'champagner', 'champagne', 'prosecco', 'kognak', 'cognac', 'brandy',
      'spirituos',
    ],
  ),
  _Regel(
    true,
    formen: {
      'prost',
      'prosit',
      'prosten',
      'prostet',
      'prostete',
      'prostetet',
      'zuprost',
      'zuprosten',
      'zuprostet',
    },
  ),
  _Regel(true, formen: {'joint', 'joints'}),
  _Regel(true, praefix: ['betrunk', 'beschwips', 'promill', 'trinkspruch']),
  _Regel(true, praefix: ['alkohol'], ausnahmenPraefix: ['alkoholfrei']),
  _Regel(true, formen: {'zecht', 'gezecht', 'zechte', 'zechten'}),

  // ---- Rausch und Drogen (Fehler) ----
  _Regel(
    true,
    formen: {'rausch', 'rausches', 'rausche', 'lsd', 'ecstasy', 'meth'},
    suffix: ['rausch'],
  ),
  _Regel(
    true,
    praefix: ['rauschgift', 'rauschmittel', 'rauschzustand', 'rauschdroge'],
  ),
  _Regel(true, praefix: ['kiff'], formen: {'gekifft'}),
  _Regel(true, praefix: ['droge'], ausnahmenPraefix: ['drogerie']),
  _Regel(
    true,
    praefix: [
      'betäubungsmittel', 'haschisch', 'haschich', 'marihuana', 'marijuana', //
      'cannabis', 'kokain', 'heroin', 'opium',
    ],
  ),

  // ---- Film-Vampire und Gruselfiguren aus Filmen (Fehler) ----
  _Regel(
    true,
    praefix: ['dracula', 'nosferatu'],
    formen: {'orlok', 'alucard', 'lestat', 'helsing', 'tepes'},
  ),
  // ---- Hexen, Walpurgis, Teufel (Fehler) ----
  _Regel(true, praefix: ['hexe'], ausnahmenPraefix: ['hexenschuss']),
  _Regel(true, praefix: ['hexer', 'walpurgis', 'teufel', 'teufl']),

  // ---- Blut und Leiche (Fehler) ----
  _Regel(
    true,
    formen: {'blut', 'blutes'},
    praefix: ['blut'],
    ausnahmenPraefix: _blutMedizin,
  ),
  _Regel(true, praefix: ['leiche', 'leichnam']),

  // ---- Herkunftsklischees, Begriffe wie „Zigeuner“ (Fehler) ----
  _Regel(
    true,
    praefix: ['zigeuner', 'kanak', 'polack', 'neger', 'ehrenmord', 'ehrenmörd'],
  ),

  // ---- anstoßen und Katerstimmung (Fehler) ----
  _Regel(
    true,
    formen: {
      'anstossen', 'anstosst', 'anstösst', 'anstiess', 'anstiessen', //
      'angestossen', 'anzustossen', 'anstosse', 'anstossend',
    },
  ),
  _Regel(true, praefix: ['katerstimm', 'katerfrüh', 'katermorg']),

  // ---- Warnungen: von Hand prüfen ----
  _Regel(false, formen: {'kater', 'katers', 'katern', 'anstoss', 'anstosses'}),
  _Regel(false, praefix: _blutMedizin),
  _Regel(
    false,
    formen: {'schänke', 'schenke', 'wirt', 'wirts', 'wirte', 'wirtin'},
  ),
  _Regel(
    false,
    formen: {'bowle', 'bowlen', 'drink', 'drinks', 'pub', 'ghetto'},
  ),
  _Regel(
    false,
    praefix: [
      'hexenschuss', 'vampir', 'gaststätte', 'gasthaus', 'wirtshaus', //
      'taverne', 'brauerei', 'winzer', 'ausschank', 'clan',
      'grossfamilie', 'parallelgesellschaft',
    ],
  ),
  _Regel(false, praefix: ['gelage'], suffix: ['gelage']),
];

/// Blut-Zusammensetzungen aus Medizin und Alltag: Warnung statt Fehler.
const _blutMedizin = [
  'blutdruck',
  'blutzucker',
  'blutgruppe',
  'blutsverwandt',
  'blutspend',
  'bluttest',
  'blutbild',
  'blutwert',
];

/// Mehrwort-Verbote. Die Prüfung läuft vor der Einzelwortprüfung.
const _phrasen = <_Phrase>[
  _Phrase(
    {'stossen', 'stosst', 'stösst', 'stiess', 'stiessen', 'stoss', 'stosse'},
    'an',
    false,
  ),
  _Phrase({'auf'}, 'ex', true),
];

/// Ein Wort sind Buchstaben, Zeichen mit Akzent und Unterstriche. Kennungen wie
/// `h_leiche` gelten damit als ein Wort und treffen keine Verbote.
final _wortRe = RegExp(r'[\p{L}\p{M}_]+', unicode: true);
final _wortzeichen = RegExp(r'[A-Za-z0-9_]');
final _escapeRe = RegExp(
  r'\\u\{([0-9a-fA-F]+)\}|\\u([0-9a-fA-F]{4})|\\x([0-9a-fA-F]{2})|\\(.)',
);
final _leerraum = RegExp(r'\s+');

/// Prüft Text auf Leitplanken-Verstöße. Zeilen, die ein Verbots-Zitat sind
/// (Beginn `- Kein Alkohol` oder `Verboten sind`), werden übersprungen.
/// Unicode-Escapes wie `\u00fc` werden vorher aufgelöst.
List<LeitplankenTreffer> scanneText(String text, {String datei = '-'}) =>
    _scanneZeilen(_entescape(text).split('\n'), datei);

/// Prüft nur den Inhalt der String-Literale eines Dart-Quelltexts; Code und
/// Kommentare bleiben außen vor.
List<LeitplankenTreffer> scanneDart(String quelltext, {String datei = '-'}) =>
    _scanneZeilen(_entescape(_maskiereDart(quelltext)).split('\n'), datei);

/// Liest Dateien und prüft sie. Ordner werden rekursiv mit Textdateien
/// aufgenommen. Die Ausnahmen stehen in [ausnahmenDatei]; ohne Angabe wird
/// `nachtlauf/kanon/LEITPLANKEN-AUSNAHMEN.md` im Repo gesucht, falls vorhanden.
/// Unbekannte Pfade lösen eine [FileSystemException] aus.
List<LeitplankenTreffer> scanneDateien(
  Iterable<String> pfade, {
  String? ausnahmenDatei,
}) {
  final wurzel = findeRepoWurzel();
  final ausnahmen = _ladeAusnahmen(
    ausnahmenDatei ?? (wurzel == null ? null : '$wurzel/$_ausnahmenPfad'),
  );
  final out = <LeitplankenTreffer>[];
  for (final pfad in sammleDateien(pfade)) {
    final quelle = _lese(pfad);
    final anzeige = _anzeige(pfad, wurzel);
    final treffer = pfad.endsWith('.dart')
        ? scanneDart(quelle, datei: anzeige)
        : scanneText(quelle, datei: anzeige);
    out.addAll(treffer.where((t) => !ausnahmen.befreit(t)));
  }
  return out;
}

/// Der wirksame Spieltext-Bestand, den `bin/leitplanken.dart` ohne Argumente
/// prüft (absolute Pfade, sortiert):
/// - `nachtlauf/kanon/ANPASSUNG.md`
/// - `krimidinner/spuk-im-gewoelbe/10_kanon/K*.md` (ohne FORMAT.md)
/// - `packages/burgstadt_core/data/**`
/// - `lib/burgstadt/**.dart`, `packages/burgstadt_spiel/lib/**.dart`
/// - `packages/burgstadt_spiel/data/**` (Erzähler, Tutorial) und `packages/pixel_engine/data/figuren/**`
/// - `content/**`, sofern vorhanden, ohne `content/party/**`: Der Partymodus gehört zum Strang
///   „Finalisierung Schlosskeller“ und hat einen eigenen Textprüfer mit eigener Regeldatei
///   (`content/party/textregeln.json`, E51).
List<String> spieltextBestand(String wurzel) {
  final out = <String>[];
  void datei(String rel) {
    final f = File('$wurzel/$rel');
    if (f.existsSync()) out.add(f.path);
  }

  void rekursiv(String rel, bool Function(String) passt) {
    final d = Directory('$wurzel/$rel');
    if (!d.existsSync()) return;
    for (final e in d.listSync(recursive: true)) {
      if (e is File && passt(e.path)) out.add(e.path);
    }
  }

  datei('nachtlauf/kanon/ANPASSUNG.md');
  final kanon = Directory('$wurzel/krimidinner/spuk-im-gewoelbe/10_kanon');
  if (kanon.existsSync()) {
    for (final e in kanon.listSync()) {
      final name = e.path.split('/').last;
      if (e is File &&
          name.startsWith('K') &&
          name.endsWith('.md') &&
          name != 'FORMAT.md') {
        out.add(e.path);
      }
    }
  }
  rekursiv('packages/burgstadt_core/data', (_) => true);
  rekursiv('lib/burgstadt', (p) => p.endsWith('.dart'));
  rekursiv('packages/burgstadt_spiel/lib', (p) => p.endsWith('.dart'));
  rekursiv('packages/burgstadt_spiel/data', (p) => p.endsWith('.json'));
  rekursiv('packages/pixel_engine/data/figuren', (p) => p.endsWith('.json'));
  rekursiv('content', (p) => !p.contains('/content/party/'));
  // Bestand „Klassische Fälle“: Spieltexte der Oberfläche
  datei('lib/l10n/app_de.arb');
  rekursiv('lib/ui', (p) => p.endsWith('.dart'));
  rekursiv('lib/game', (p) => p.endsWith('.dart'));
  out.sort();
  return out;
}

/// Löst Pfade auf: Dateien bleiben, Ordner liefern ihre Textdateien (sortiert).
List<String> sammleDateien(Iterable<String> pfade) {
  final out = <String>[];
  for (final pfad in pfade) {
    final typ = FileSystemEntity.typeSync(pfad);
    if (typ == FileSystemEntityType.file) {
      out.add(pfad);
    } else if (typ == FileSystemEntityType.directory) {
      final liste =
          Directory(pfad)
              .listSync(recursive: true)
              .whereType<File>()
              .map((f) => f.path)
              .where(_istTextdatei)
              .toList()
            ..sort();
      out.addAll(liste);
    } else {
      throw FileSystemException('Pfad nicht gefunden', pfad);
    }
  }
  return out;
}

const _textEndungen = [
  '.md',
  '.txt',
  '.json',
  '.dart',
  '.yaml',
  '.yml',
  '.arb',
];

bool _istTextdatei(String pfad) => _textEndungen.any(pfad.endsWith);

LeitplankenAusnahmen _ladeAusnahmen(String? pfad) {
  if (pfad == null || !File(pfad).existsSync()) {
    return LeitplankenAusnahmen.parse('');
  }
  return LeitplankenAusnahmen.parse(_lese(pfad));
}

String _lese(String pfad) {
  var s = utf8.decode(File(pfad).readAsBytesSync(), allowMalformed: true);
  if (s.startsWith('\uFEFF')) s = s.substring(1);
  return s;
}

String _anzeige(String pfad, String? wurzel) {
  final abs = File(pfad).absolute.path.replaceAll('\\', '/');
  if (wurzel != null && abs.startsWith('$wurzel/')) {
    return abs.substring(wurzel.length + 1);
  }
  return abs;
}

String _normPfad(String p) =>
    p.replaceAll('\\', '/').replaceFirst(RegExp(r'^\./'), '').trim();

/// Faltung für den Vergleich: klein, ß zu ss, Grundbuchstaben für ț ș ă â î.
String _falte(String s) => s
    .toLowerCase()
    .replaceAll('ß', 'ss')
    .replaceAll('ț', 't')
    .replaceAll('ţ', 't')
    .replaceAll('ș', 's')
    .replaceAll('ş', 's')
    .replaceAll('ă', 'a')
    .replaceAll('â', 'a')
    .replaceAll('î', 'i');

/// Löst `\uXXXX`, `\u{…}`, `\xXX` und einfache Escapes auf. Zeilenumbrüche
/// bleiben erhalten, `\n`, `\t` u. a. werden zu Leerzeichen.
String _entescape(String s) => s.replaceAllMapped(_escapeRe, (m) {
  final hex = m[1] ?? m[2] ?? m[3];
  if (hex != null) {
    final code = int.parse(hex, radix: 16);
    return code > 0x10FFFF ? ' ' : String.fromCharCode(code);
  }
  final c = m[4]!;
  return 'ntrbf'.contains(c) ? ' ' : c;
});

/// Ersetzt in einem Dart-Quelltext alles außerhalb der String-Literale durch
/// Leerzeichen (Zeilenumbrüche bleiben), damit Zeilen und Spalten stimmen.
String _maskiereDart(String q) {
  final out = StringBuffer();
  final n = q.length;
  var i = 0;
  while (i < n) {
    final c = q[i];
    final naechstes = i + 1 < n ? q[i + 1] : '';
    if (c == '/' && naechstes == '/') {
      while (i < n && q[i] != '\n') {
        out.write(' ');
        i++;
      }
    } else if (c == '/' && naechstes == '*') {
      var tiefe = 0;
      while (i < n) {
        if (q.startsWith('/*', i)) {
          tiefe++;
          out.write('  ');
          i += 2;
        } else if (q.startsWith('*/', i)) {
          tiefe--;
          out.write('  ');
          i += 2;
          if (tiefe == 0) break;
        } else {
          out.write(q[i] == '\n' ? '\n' : ' ');
          i++;
        }
      }
    } else if (c == "'" || c == '"') {
      final roh =
          i > 0 &&
          q[i - 1] == 'r' &&
          (i < 2 || !_wortzeichen.hasMatch(q[i - 2]));
      final dreifach = q.startsWith(c * 3, i);
      final ende = dreifach ? c * 3 : c;
      out.write(' ' * ende.length);
      i += ende.length;
      while (i < n) {
        if (!roh && q[i] == '\\' && i + 1 < n) {
          out.write(q[i]);
          out.write(q[i + 1]);
          i += 2;
        } else if (q.startsWith(ende, i)) {
          out.write(' ' * ende.length);
          i += ende.length;
          break;
        } else if (!dreifach && q[i] == '\n') {
          break; // unbeendetes einzeiliges Literal
        } else {
          out.write(q[i]);
          i++;
        }
      }
    } else {
      out.write(c == '\n' ? '\n' : ' ');
      i++;
    }
  }
  return out.toString();
}

List<LeitplankenTreffer> _scanneZeilen(List<String> zeilen, String datei) {
  final out = <LeitplankenTreffer>[];
  for (var i = 0; i < zeilen.length; i++) {
    final zeile = zeilen[i].replaceAll('\r', '');
    if (_istVerbotszitat(zeile)) continue;
    out.addAll(_scanneZeile(zeile, i + 1, datei));
  }
  return out;
}

bool _istVerbotszitat(String zeile) {
  final t = zeile.trimLeft();
  return t.startsWith('- Kein Alkohol') || t.startsWith('Verboten sind');
}

List<LeitplankenTreffer> _scanneZeile(String zeile, int nr, String datei) {
  final worte = _wortRe.allMatches(zeile).toList();
  final out = <LeitplankenTreffer>[];
  var i = 0;
  while (i < worte.length) {
    final erster = worte[i];
    if (i + 1 < worte.length) {
      final phrase = _phraseAn(erster[0]!, worte[i + 1][0]!);
      if (phrase != null) {
        out.add(
          _treffer(
            zeile,
            nr,
            datei,
            erster.start,
            worte[i + 1].end,
            phrase.fehler,
          ),
        );
        i += 2;
        continue;
      }
    }
    final fehler = _schwere(erster[0]!);
    if (fehler != null) {
      out.add(_treffer(zeile, nr, datei, erster.start, erster.end, fehler));
    }
    i++;
  }
  return out;
}

_Phrase? _phraseAn(String a, String b) {
  final ka = _falte(a);
  final kb = _falte(b);
  for (final p in _phrasen) {
    if (p.erster.contains(ka) && kb == p.zweiter) return p;
  }
  return null;
}

/// `true` für Fehler, `false` für Warnung, `null` für keinen Treffer.
bool? _schwere(String wort) {
  final k = _falte(wort);
  bool? warnung;
  for (final r in _regeln) {
    if (r.passt(wort, k)) {
      if (r.fehler) return true;
      warnung = false;
    }
  }
  return warnung;
}

LeitplankenTreffer _treffer(
  String zeile,
  int nr,
  String datei,
  int start,
  int ende,
  bool fehler,
) => LeitplankenTreffer(
  datei: datei,
  zeile: nr,
  wort: zeile.substring(start, ende),
  fehler: fehler,
  ausschnitt: _ausschnitt(zeile, start, ende),
);

String _ausschnitt(String zeile, int start, int ende) {
  const rand = 40;
  final a = start - rand < 0 ? 0 : start - rand;
  final b = ende + rand > zeile.length ? zeile.length : ende + rand;
  final mitte = zeile.substring(a, b).replaceAll(_leerraum, ' ').trim();
  return '${a > 0 ? '…' : ''}$mitte${b < zeile.length ? '…' : ''}';
}
