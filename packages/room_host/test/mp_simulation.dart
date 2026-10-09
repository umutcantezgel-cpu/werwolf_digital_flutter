import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:room_host/room_host.dart';

import 'burgstadt_adapter.dart';

/// Ergebnis einer Mehrspieler-Simulation.
class MpErgebnis {
  final int teilnehmer, n, bots;
  final String? ende;
  final int geteiltEinzeln, geteiltAkte;
  final double maxLatenzMs, mittelLatenzMs;
  final List<String> abweichungen;
  final Duration dauer;
  MpErgebnis(this.teilnehmer, this.n, this.bots, this.ende, this.geteiltEinzeln, this.geteiltAkte, this.maxLatenzMs,
      this.mittelLatenzMs, this.abweichungen, this.dauer);

  @override
  String toString() => 'Teilnehmer $teilnehmer · Rollen $n (Bots $bots) · Ende $ende · geteilt an Einzelne $geteiltEinzeln, '
      'an die Akte $geteiltAkte · Latenz max ${maxLatenzMs.toStringAsFixed(0)} ms, Mittel ${mittelLatenzMs.toStringAsFixed(0)} ms · '
      'Abweichungen ${abweichungen.length} · ${dauer.inMilliseconds / 1000} s';
}

const _stationen = ['BS-01', 'BS-03', 'BS-04', 'BS-05', 'BS-06', 'BS-08', 'BS-09', 'BS-11', 'BS-12', 'Kunibert'];

/// Host + [teilnehmer] echte WebSocket-Clients im selben Prozess; die Clients spielen
/// einfache Skripte (untersuchen, Gespräche führen, teilen an Einzelne und die Akte,
/// entscheiden; der Detektiv führt durch Lagerunden und klagt an).
Future<MpErgebnis> mpSimulation(FallDaten daten, int teilnehmer, {int seed = 1, double tempo = 12}) async {
  final uhr = Stopwatch()..start();
  late BurgstadtRaum raum;
  final host = RaumHost((code) {
    raum = BurgstadtRaum(daten, Welt(baueBurg()), seed: seed, tempo: tempo, wahlFrist: 3);
    return BurgstadtRaumSpiel(raum);
  }, seed: seed);
  final port = await host.starte(adresse: InternetAddress.loopbackIPv4);
  final code = host.erstelleRaum();
  final z = math.Random(seed);
  final clients = <RaumClient>[];
  for (var i = 0; i < teilnehmer; i++) {
    clients.add(await RaumClient.verbinde('127.0.0.1', port, raum: code, name: 'Spieler ${i + 1}'));
  }
  // Teilen-Latenz: Senden (hinweis|an) → Zeit; Empfang beim Empfänger
  final gesendet = <String, int>{};
  final latenzen = <double>[];
  var anEinzelne = 0, anAkte = 0;
  for (final c in clients) {
    c.beiEreignis = (e) {
      final art = e['art'], h = e['hinweis'] as String?;
      if (h == null) return;
      final rolle = c.zustand['rolle'] as String?;
      String? schluessel;
      if (art == 'teilen' && e['an'] == rolle) schluessel = '$h|$rolle';
      if (art == 'akte') schluessel = '$h|akte';
      final t0 = schluessel == null ? null : gesendet[schluessel];
      if (t0 != null) latenzen.add((uhr.elapsedMicroseconds - t0) / 1000);
    };
  }
  // N = Teilnehmerzahl: Detektiv + (N − 1) menschliche Rollen, ein Bot füllt die letzte Rolle
  clients.first.sende({'art': 'start', 'n': teilnehmer});
  final gemeldet = <String>{};
  final gezeigt = List.generate(clients.length, (_) => 0);
  // Spielschleife der Clients
  while (uhr.elapsed < const Duration(minutes: 4)) {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final f = raum.fall;
    if (f == null) continue;
    if (f.abschnitt == Abschnitt.ende) break;
    for (var i = 0; i < clients.length; i++) {
      final c = clients[i];
      final zs = c.zustand;
      final rolle = zs['rolle'] as String?;
      if (rolle == null) continue;
      final abschnitt = zs['abschnitt'];
      if (rolle == FallZustand.detektiv) {
        if (abschnitt == 'ermittlung' && z.nextDouble() < 0.2) c.sende({'art': 'untersuche', 'station': _stationen[z.nextInt(_stationen.length)]});
        if (abschnitt == 'lagerunde') c.sende({'art': 'weiter'});
        if (abschnitt == 'detektivWahl') {
          for (final d in (zs['detektivEntscheidungen'] as List?) ?? const []) {
            final opt = ((d as Map)['optionen'] as Map).keys.first;
            c.sende({'art': 'detektiv', 'entscheidung': d['id'], 'option': opt});
          }
          c.sende({'art': 'weiter'});
        }
        if (abschnitt == 'eingrenzung') {
          final v = [for (final x in (zs['verdaechtige'] as List?) ?? const []) x as String];
          if (v.isNotEmpty) c.sende({'art': 'anklage', 'rolle': v.contains('R03') ? 'R03' : v.first});
        }
        continue;
      }
      if (abschnitt == 'ermittlung') {
        if (z.nextDouble() < 0.15) c.sende({'art': 'untersuche', 'station': _stationen[z.nextInt(_stationen.length)]});
        final g = (zs['gespraeche'] as List?) ?? const [];
        if (g.isNotEmpty && z.nextDouble() < 0.3) c.sende({'art': 'gespraech', 'gespraech': (g.first as Map)['id']});
        // Neue eigene Funde teilen: abwechselnd an die Akte und an Einzelne
        final funde = [for (final e in c.ereignisse.skip(gezeigt[i])) if (e['art'] == 'fund' && e['hinweis'] != null) e['hinweis'] as String];
        gezeigt[i] = c.ereignisse.length;
        for (final h in funde) {
          if (!gemeldet.add('$rolle|$h')) continue;
          final mitspieler = [for (final m in (zs['mitspieler'] as List)) (m as Map)['rolle'] as String?].whereType<String>().where((x) => x != rolle).toList();
          final an = z.nextBool() ? 'akte' : mitspieler[z.nextInt(mitspieler.length)];
          gesendet['$h|$an'] = uhr.elapsedMicroseconds;
          if (an == 'akte') {
            anAkte++;
          } else {
            anEinzelne++;
          }
          c.sende({'art': 'teile', 'an': an, 'hinweis': h});
        }
      }
      if (abschnitt == 'lagerunde') {
        for (final e in (zs['entscheidungen'] as List?) ?? const []) {
          c.sende({'art': 'wahl', 'entscheidung': (e as Map)['id'], 'option': 0});
        }
      }
    }
  }
  // Letzten Zustand abwarten und vergleichen
  await Future<void>.delayed(const Duration(milliseconds: 400));
  final f = raum.fall!;
  final abw = <String>[];
  for (final c in clients) {
    final zs = c.zustand;
    final r = zs['rolle'] as String;
    if (zs['phase'] != f.phase) abw.add('$r: Phase ${zs['phase']} statt ${f.phase}');
    if (zs['abschnitt'] != f.abschnitt.name) abw.add('$r: Abschnitt ${zs['abschnitt']} statt ${f.abschnitt.name}');
    if (zs['ende'] != f.ende) abw.add('$r: Ende ${zs['ende']} statt ${f.ende}');
    final akte = [for (final x in zs['akte'] as List) x as String];
    if (akte.join(',') != (f.akte.toList()..sort()).join(',')) abw.add('$r: Fallakte weicht ab');
    final wissen = [for (final x in zs['wissen'] as List) x as String];
    if (wissen.join(',') != (f.wissen[r]!.toList()..sort()).join(',')) abw.add('$r: Wissen weicht ab');
    // Jeder bekannte Hinweis kam mit Text beim Client an
    final texte = <String>{
      for (final e in c.ereignisse)
        if (e['hinweis'] != null) e['hinweis'] as String,
      for (final e in c.ereignisse)
        if (e['art'] == 'texte') ...(e['texte'] as Map).keys.cast<String>(),
    };
    final ohneText = {...wissen, ...akte}.difference(texte);
    if (ohneText.isNotEmpty) abw.add('$r: ${ohneText.length} Hinweise ohne Text');
    if (c.fehler.isNotEmpty) abw.add('$r: Fehler ${c.fehler}');
  }
  final bots = raum.sim!.figuren.values.where((x) => !x.bewohner && x.bot && x.id != 'BW').length;
  for (final c in clients) {
    await c.trenne();
  }
  await host.stoppe();
  final mittel = latenzen.isEmpty ? 0.0 : latenzen.reduce((a, b) => a + b) / latenzen.length;
  return MpErgebnis(teilnehmer, f.n, bots, f.ende, anEinzelne, anAkte, latenzen.isEmpty ? 0 : latenzen.reduce(math.max), mittel, abw,
      uhr.elapsed);
}
