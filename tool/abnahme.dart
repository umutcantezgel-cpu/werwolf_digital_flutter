// Abnahme Z-01 … Z-14 (Nachtlauf „Burgstadt Schartenfels“).
//
// Rechnet jedes Kriterium aus ABNAHME.md nach: Messwert gegen Grenze, aus einem vollständigen
// Lauf von `tool/alle_tests.sh` (alle elf Ebenen), aus den Daten selbst und aus den Berichten der
// unabhängigen Prüfer. Nur dieses Werkzeug darf am Ende „ZIEL ERREICHT“ ausgeben.
//
// Aufruf (Repo-Wurzel): `dart run tool/abnahme.dart [--log <datei>]`
// Ohne `--log` läuft `tool/alle_tests.sh` vollständig (dauert einige Minuten); das Protokoll steht
// danach in `nachtlauf/belege/alle_tests_voll.txt`. Mit `--log` wird ein Protokoll nur dann
// wiederverwendet, wenn es zum aktuellen Commit gehört und der Code seither unverändert ist.
// Das Ergebnis steht zusätzlich in `nachtlauf/belege/abnahme.txt`.
import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';

late final String wurzel;
final ergebnisse = <(String, bool, String)>[];

void kriterium(String id, bool ok, String beleg) => ergebnisse.add((id, ok, beleg));

String _git(List<String> args) => (Process.runSync('git', args, workingDirectory: wurzel).stdout as String).trim();

Map<String, dynamic> _json(String rel) => jsonDecode(File('$wurzel/$rel').readAsStringSync()) as Map<String, dynamic>;

Future<void> main(List<String> args) async {
  wurzel = File.fromUri(Platform.script).parent.parent.path;
  final head = _git(['rev-parse', '--short=12', 'HEAD']);
  // Code-Stand: Änderungen außerhalb von nachtlauf/ (Berichte, Belege) machen ein Protokoll ungültig
  final sauber = _git(['status', '--porcelain', '--', '.', ':!nachtlauf']).isEmpty;
  final logPfad = '$wurzel/nachtlauf/belege/alle_tests_voll.txt';
  String? log;
  final i = args.indexOf('--log');
  if (i >= 0 && i + 1 < args.length && File(args[i + 1]).existsSync()) {
    final l = File(args[i + 1]).readAsStringSync();
    // Gültig, wenn sich seit dem Commit des Protokolls außerhalb von nachtlauf/ (Berichte,
    // Belege) nichts geändert hat und der Baum sauber ist
    final m = RegExp(r'^HEAD ([0-9a-f]+) · .* · Exit 0\n').firstMatch(l);
    final gleich = m != null &&
        Process.runSync('git', ['diff', '--quiet', m[1]!, 'HEAD', '--', '.', ':!nachtlauf'], workingDirectory: wurzel).exitCode == 0;
    if (sauber && gleich) {
      log = l;
      stdout.writeln('Protokoll wiederverwendet: ${args[i + 1]} (Lauf auf ${m[1]}, Code seither unverändert)');
    } else {
      stdout.writeln('Protokoll ${args[i + 1]} passt nicht zum aktuellen Code-Stand – neuer Lauf.');
    }
  }
  if (log == null) {
    stdout.writeln('Vollständiger Testlauf: bash tool/alle_tests.sh (alle Ebenen) …');
    final p = await Process.start('bash', ['tool/alle_tests.sh'], workingDirectory: wurzel);
    final puffer = StringBuffer();
    // Die Futures vor dem Warten anlegen: ein später angehängtes asFuture() an einen schon
    // beendeten Strom erfüllt sich nie, und die VM endet dann still mit Code 0
    final aus = p.stdout.transform(utf8.decoder).forEach(puffer.write);
    final fehler = p.stderr.transform(utf8.decoder).forEach(puffer.write);
    final code = await p.exitCode;
    await Future.wait([aus, fehler]);
    final zeit = DateTime.now().toIso8601String().substring(0, 16);
    log = 'HEAD $head · $zeit · Exit $code${sauber ? '' : ' · Code-Stand nicht eingecheckt'}\n$puffer';
    File(logPfad).writeAsStringSync(log);
  }
  final l = log;
  final gruen = l.contains('ALLE TESTS GRÜN');
  bool hat(String s) => l.contains(s);
  Iterable<RegExpMatch> alle(String re) => RegExp(re, multiLine: true).allMatches(l);
  String? erste(String re, [int gruppe = 0]) => RegExp(re, multiLine: true).firstMatch(l)?.group(gruppe);

  // ------------------------------------------------------------------ Z-01 Bestand
  final bestandSchritte = ['Ebene 11 · Bestand: mordakte_core', 'Ebene 11 · Server-Smoke', 'Ebene 11 · Mordakte simulate'];
  final fehlend = bestandSchritte.where((s) => !hat(s)).toList();
  kriterium('Z-01', gruen && fehlend.isEmpty && File('$wurzel/nachtlauf/belege/phase0_ausgangstests.txt').existsSync(),
      'Gesamtlauf ${gruen ? 'grün' : 'NICHT grün'}; Bestand: Core-Tests, validate, Server-Smoke, simulate${fehlend.isEmpty ? ' gelaufen' : ' fehlt: ${fehlend.join(', ')}'}; Ausgangswerte phase0_ausgangstests.txt');

  // ------------------------------------------------------------------ Z-02 Pixel
  final beleg = alle(r'^BELEGFOTOS OK \((\d+) Bilder\)').toList();
  kriterium('Z-02', gruen && beleg.length >= 2,
      'Belegfotos (6 Viertel, 10 Innenräume, alle Menüs; Palette + Blocktest): ${beleg.length} Formate OK (${beleg.map((m) => m[1]).join(' + ')} Bilder); Browser-Fotos pixel_pruef im Gesamtlauf; gleiche Pixeldichte: karten_test');

  // ------------------------------------------------------------------ Z-03 Figuren
  final karten = [for (final k in _json('packages/pixel_engine/data/figuren/karten.json')['karten'] as List) (k as Map)['id'] as String];
  final rollen = karten.where((k) => RegExp(r'^R\d\d$').hasMatch(k)).length;
  final bewohner = karten.where((k) => RegExp(r'^B\d\d$').hasMatch(k)).length;
  final kartenStand = _git(['hash-object', 'packages/pixel_engine/data/figuren/karten.json']).substring(0, 10);
  final pruefer = <String>[];
  for (final f in Directory('$wurzel/nachtlauf/auftraege/A-605').listSync().whereType<File>()) {
    final t = f.readAsStringSync();
    final m = RegExp(r'ERGEBNIS · Paare: (\d+) · Verstöße: (\d+) · Karten ([0-9a-f]{10})').firstMatch(t);
    if (m != null && m[1] == '0' && m[2] == '0' && m[3] == kartenStand) pruefer.add(f.uri.pathSegments.last);
  }
  kriterium('Z-03', gruen && rollen == 20 && bewohner >= 40 && pruefer.length >= 2,
      '$rollen Rollen, $bewohner Stadtbewohner (Grenze 20 / 40); Sprite-Prüfung und Porträts (4 Ausdrücke) in den Tests; '
      'Sichtprüfer ohne Paare und Verstöße am Kartenstand $kartenStand: ${pruefer.length} (Grenze 2)${pruefer.isEmpty ? '' : ' – ${pruefer.join(', ')}'}');

  // ------------------------------------------------------------------ Z-04 Stadt
  final daten = 'packages/burgstadt_core/data';
  final innen = [
    for (final f in Directory('$wurzel/$daten/innenraeume').listSync().whereType<File>())
      if (f.path.endsWith('.json')) jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
  ];
  final haeuser = [for (final h in _json('$daten/stadt/haeuser.json')['haeuser'] as List) h as Map<String, dynamic>];
  final welt = baueWelt(innen, haeuser: haeuser);
  final viertel = {for (final h in haeuser) h['viertel']};
  final innenraeume = welt.values.where((b) => b.innen).length;
  final fallorte = [for (final b in _json('$daten/innenraeume/fallorte.json')['bereiche'] as List) b].length;
  final netz = welt.keys.where((k) => k.contains('keller') || k.contains('gang')).toList();
  final wehrgang = welt.containsKey('wehrgang');
  final tueren = RegExp(r'^Türen (\d+)/(\d+) erreicht', multiLine: true).firstMatch(l);
  final nichtErreicht = erste(r'^Nicht erreicht: (\d+)', 1);
  final stecken = erste(r'^Steckenbleiber: (\d+)', 1);
  final erkundungOk = tueren != null && tueren[1] == tueren[2] && nichtErreicht == '0' && stecken == '0';
  kriterium(
      'Z-04',
      viertel.length == 6 && haeuser.length >= 150 && innenraeume >= 40 && fallorte == 12 && netz.isNotEmpty && wehrgang && erkundungOk,
      '${viertel.length} Viertel, ${haeuser.length} Gebäude (≥ 150), $innenraeume betretbare Innenräume (≥ 40), $fallorte Fall-Orte (12), '
      'Keller/Gänge ${netz.length}, Wehrgang ${wehrgang ? 'ja' : 'nein'}; Erkundungsbots: Türen ${tueren?[1]}/${tueren?[2]}, nicht erreicht $nichtErreicht, Steckenbleiber $stecken');

  // ------------------------------------------------------------------ Z-05 Blicke
  final faehig = faehigkeitenAusJson(_json('$daten/rollen/faehigkeiten.json'));
  final mitSicht = faehig.values.where((f) => f.sichtschicht.trim().isNotEmpty).length;
  kriterium('Z-05', gruen && SpurArt.values.length >= 7 && mitSicht >= 20,
      'Detektivblick: ${SpurArt.values.length} Spurenarten (≥ 7: ${SpurArt.values.map((s) => s.name).join(', ')}); '
      '$mitSicht von 20 Rollen mit eigener Sichtschicht/Fähigkeit; Sichtregeln je Rolle: faehigkeiten_test, burgstadt_raum_test');

  // ------------------------------------------------------------------ Z-06 Teilen
  final latenzen = [for (final m in alle(r'Latenz max (\d+) ms')) int.parse(m[1]!)];
  final nutzen = erste(r'^Teilen-Nutzen: (-?\d+) %', 1);
  final nutzenOk = nutzen != null && int.parse(nutzen) >= 30;
  final latenzOk = latenzen.length >= 3 && latenzen.every((x) => x < 1000);
  kriterium('Z-06', gruen && latenzOk && nutzenOk,
      'Teilen an Einzelne und an die Akte im Mehrspielertest; Latenz max ${latenzen.join(' / ')} ms (Grenze 1000); Teilen-Nutzen $nutzen % weniger Schritte (Grenze 30)');

  // ------------------------------------------------------------------ Z-07 Fall
  final spieltests = alle(r'^SPIELTEST OK').length;
  kriterium('Z-07', gruen && hat('FAIRNESS OK') && hat('DURCHSPIEL OK') && spieltests >= 2,
      'Löser: ${hat('FAIRNESS OK') ? 'FAIRNESS OK für N = 4…20' : 'FAIRNESS fehlt'}; Durchspiel ${hat('DURCHSPIEL OK') ? 'OK' : 'fehlt'} (Endmatrix, Punkte); Spieltest über die echten Bildschirme bis zum Ende: $spieltests× OK');

  // ------------------------------------------------------------------ Z-08 Spielweisen
  final teilnehmer = [for (final m in alle(r'^Teilnehmer (\d+) · Rollen \d+ \(Bots (\d+)\) · Ende (\S+).*Abweichungen (\d+)')) (m[1], m[2], m[3], m[4])];
  final mpOk = hat('MP-SIM OK') && {for (final t in teilnehmer) t.$1}.containsAll(['4', '8', '20']) && teilnehmer.every((t) => t.$4 == '0' && t.$3 != 'null');
  kriterium('Z-08', gruen && mpOk && spieltests >= 1,
      'Solo mit Bots: Spieltest OK; Mehrspieler: ${[for (final t in teilnehmer) '${t.$1} Teilnehmer (Bots ${t.$2}, Abweichungen ${t.$4})'].join(', ')}; ${hat('MP-SIM OK') ? 'MP-SIM OK' : 'MP-SIM fehlt'}');

  // ------------------------------------------------------------------ Z-09 Leistung
  final spitze = erste(r'Nachladespitzen: .* × 4 = ([\d.]+) ms', 1);
  final logik = erste(r'Spiellogik je Bild .* × 4 = ([\d.]+) ms', 1);
  final speicher = erste(r'Wachstum ([\d.]+) %', 1);
  kriterium('Z-09', gruen && hat('LEISTUNG OK'),
      'AOT, Faktor 4 (Näherung): Spiellogik $logik ms (≤ 4), Nachladespitze $spitze ms (≤ 50), Speicherwachstum $speicher % (≤ 10), Budget je Ansicht im Rahmen; ${hat('LEISTUNG OK') ? 'LEISTUNG OK' : 'LEISTUNG nicht OK oder nicht gelaufen'}');

  // ------------------------------------------------------------------ Z-10 / Z-11 / Z-13 Browser
  final geraete = [
    for (final m in alle(r'^(desktop|handy-quer|handy-hoch) · .*Konsole (\d+) · fremde Abrufe (\d+)(.*)$')) (m[1]!, int.parse(m[2]!), int.parse(m[3]!), m[4]!),
  ];
  final profile = {for (final g in geraete) g.$1};
  final gamepad = geraete.any((g) => g.$1 == 'desktop' && g.$4.contains('Gamepad wirkt'));
  kriterium('Z-10', gruen && profile.length == 3 && gamepad,
      'Playwright-Durchläufe: ${profile.join(', ')} (3 Profile); Touch-Wischen, Tastatur + Maus, Gamepad-Simulation (${gamepad ? 'wirkt' : 'OHNE Wirkung'}); Fotos bestehen pixel_pruef');
  final konsole = geraete.fold(0, (n, g) => n + g.$2);
  final spielstandTest = File('$wurzel/packages/burgstadt_spiel/test/spielstand_test.dart').existsSync();
  kriterium('Z-11', gruen && profile.length == 3 && konsole == 0 && spielstandTest,
      'Konsolenfehler/-warnungen in allen Durchläufen: $konsole; Speichern und Fortsetzen: spielstand_test${spielstandTest ? '' : ' FEHLT'}');

  // ------------------------------------------------------------------ Z-12 Inhalt
  final berichte = [
    for (final f in Directory('$wurzel/nachtlauf/auftraege/A-702').listSync().whereType<File>())
      if (f.path.endsWith('_bericht.md')) f,
  ];
  int seit(String pfad) => int.tryParse(_git(['log', '-1', '--format=%ct', '--', pfad])) ?? 0;
  final datenStand = [
    seit('packages/burgstadt_core/data'),
    seit('packages/burgstadt_spiel/data/texte'),
    seit('nachtlauf/kanon'),
    seit('krimidinner/spuk-im-gewoelbe/10_kanon'),
  ].reduce((a, b) => a > b ? a : b);
  // Spieltexte: Stadt-, Spiel- und Figurendaten, das Overlay und der Kanon selbst (das Spiel zeigt
  // seine O-Datensätze; E41)
  const textPfade = [
    'packages/burgstadt_core/data',
    'packages/burgstadt_spiel/data/texte',
    'packages/pixel_engine/data/figuren',
    'nachtlauf/kanon',
    'krimidinner/spuk-im-gewoelbe/10_kanon',
  ];
  final gueltig = <String>[];
  for (final f in berichte) {
    final t = f.readAsStringSync();
    final rel = f.path.substring(wurzel.length + 1);
    final urteil = RegExp(r'Leitplanken eingehalten: \**ja').hasMatch(t) && RegExp(r'Kanontreu: \**ja').hasMatch(t) && RegExp(r'Plagiatsfrei: \**ja').hasMatch(t);
    if (!urteil) continue;
    // Nennt der Bericht den geprüften Stand (HEAD <hash>), müssen die Spieltexte seitdem
    // unverändert sein; sonst gilt die Commit-Zeit des Berichts gegen die letzte Textänderung.
    final stand = RegExp(r'HEAD `?([0-9a-f]{7,40})').firstMatch(t)?[1];
    final aktuell = stand != null
        ? Process.runSync('git', ['diff', '--quiet', stand, 'HEAD', '--', ...textPfade], workingDirectory: wurzel).exitCode == 0
        : seit(rel) >= datenStand;
    if (aktuell) gueltig.add('${f.uri.pathSegments.last}${stand == null ? '' : ' (geprüfter Stand $stand)'}');
  }
  final scanner = erste(r'Summe: (\d+) Treffer', 1);
  kriterium('Z-12', gruen && scanner == '0' && gueltig.isNotEmpty,
      'Leitplanken-Scanner: $scanner Treffer; Gegenprüfer-Bericht mit „Leitplanken ja · Kanontreu ja · Plagiatsfrei ja“, jünger als die letzte Textänderung: ${gueltig.isEmpty ? 'keiner' : gueltig.join(', ')}');

  // ------------------------------------------------------------------ Z-13 Lokal
  final remotes = _git(['remote']).split('\n').where((r) => r.isNotEmpty).toList();
  // Beginn des Nachtlaufs: der älteste Commit „Nachtlauf …“
  final start = int.tryParse(_git(['log', '--format=%ct', '--grep=^Nachtlauf', '--reverse']).split('\n').first) ?? 0;
  final fremdePushes = <String>[];
  // Erlaubte Push-Ziele: der Sicherungs-Branch (N-00) und – auf ausdrücklichen Wunsch des Nutzers,
  // alles auf main zu bringen (N-01, E41) – main und der Sitzungs-Branch
  const erlaubt = ['/nachtlauf/burgstadt', '/main', '/claude/nifty-gauss-s82y27'];
  for (final ref in _git(['for-each-ref', '--format=%(refname)', 'refs/remotes']).split('\n')) {
    if (ref.isEmpty || ref.endsWith('/HEAD') || erlaubt.any(ref.endsWith)) continue;
    for (final z in _git(['reflog', 'show', '--date=unix', ref]).split('\n')) {
      final m = RegExp(r'@\{(\d+)\}: update by push').firstMatch(z);
      if (m != null && int.parse(m[1]!) >= start) fremdePushes.add(ref);
    }
  }
  final fremdeAbrufe = geraete.fold(0, (n, g) => n + g.$3);
  kriterium('Z-13', remotes.length == 1 && remotes.first == 'origin' && fremdePushes.isEmpty && profile.length == 3 && fremdeAbrufe == 0,
      'Remotes: ${remotes.join(', ')}; Pushes seit Beginn nur auf nachtlauf/burgstadt, main und claude/nifty-gauss-s82y27 (N-00, N-01)${fremdePushes.isEmpty ? '' : ' – ABWEICHUNG: ${fremdePushes.join(', ')}'}; '
      'fremde Abrufe im Browser: $fremdeAbrufe (Web-Build ohne CDN)');

  // ------------------------------------------------------------------ Z-14 Übergabe
  final dokumente = {
    'Morgenbericht': 'nachtlauf/MORGENBERICHT.md',
    'Abschlussbericht': 'nachtlauf/ABSCHLUSSBERICHT.md',
    'Anleitung': 'nachtlauf/ANLEITUNG.md',
    'FÜR DEN NUTZER': 'nachtlauf/FUER-DEN-NUTZER.md',
  };
  final fehlt = [for (final e in dokumente.entries) if (!File('$wurzel/${e.value}').existsSync()) e.key];
  var bilderOk = false;
  final abschluss = File('$wurzel/nachtlauf/ABSCHLUSSBERICHT.md');
  final kaputt = <String>[];
  if (abschluss.existsSync()) {
    final t = abschluss.readAsStringSync();
    final bilder = [for (final m in RegExp(r'\]\(([^)]+\.png)\)').allMatches(t)) m[1]!];
    for (final b in bilder) {
      if (!File('${abschluss.parent.path}/$b').existsSync()) kaputt.add(b);
    }
    bilderOk = bilder.any((b) => b.contains('figuren_aufstellung')) && bilder.length >= 6 && kaputt.isEmpty;
  }
  kriterium('Z-14', fehlt.isEmpty && bilderOk,
      'Dokumente: ${fehlt.isEmpty ? 'alle vorhanden' : 'fehlt: ${fehlt.join(', ')}'}; Abschlussbericht mit Bildschirmfotos und Figuren-Aufstellung: ${bilderOk ? 'ja' : 'nein'}${kaputt.isEmpty ? '' : ' (fehlende Bilder: ${kaputt.join(', ')})'}');

  // ------------------------------------------------------------------ Ausgabe
  final out = StringBuffer()
    ..writeln('Abnahme · Stand $head${sauber ? '' : ' (+ nicht eingecheckte Änderungen)'} · ${DateTime.now().toIso8601String().substring(0, 16)}')
    ..writeln('Gesamtlauf aller Ebenen: ${gruen ? 'ALLE TESTS GRÜN' : 'NICHT GRÜN – Protokoll: nachtlauf/belege/alle_tests_voll.txt'}');
  for (final (id, ok, b) in ergebnisse) {
    out.writeln('$id · ${ok ? 'erfüllt' : 'OFFEN  '} · $b');
  }
  final offen = [for (final (id, ok, _) in ergebnisse) if (!ok) id];
  out.writeln(offen.isEmpty ? 'ZIEL ERREICHT' : 'ZIEL NICHT ERREICHT · offen: ${offen.join(', ')}');
  stdout.write(out);
  File('$wurzel/nachtlauf/belege/abnahme.txt').writeAsStringSync(out.toString());
  exitCode = offen.isEmpty ? 0 : 1;
}
