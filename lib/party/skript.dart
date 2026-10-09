import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mordakte_core/mordakte_core.dart';

import 'sitzung.dart';

/// Entwickler-Einstieg des Partymodus (F4-ORCH-02):
/// `?party=schlosskeller&pfad=ahmet&n=7&detektiv=w&skript=best,a,richtig&dauer=20&takt=700&zeitraffer=60`.
///
/// - `code` oder `pfad`: Fall-Code bzw. Täter-Pfad (für Testläufe)
/// - `n`: Personenzahl, `detektiv`: m oder w, `dauer`: Rundendauer in Sekunden
/// - `skript`: Entscheidungen (`best`, `schlecht`, `erste`), Gruppe (`a`, `b`,
///   `gemischt`), Anklage (`richtig`, `falsch` oder eine Kennung)
/// - `takt`: Pause zwischen zwei Schritten in Millisekunden
/// - `zeitraffer`: Spielsekunden je echter Sekunde in der Rückblende
/// - `fotos=0`: Fotostellen nur melden, ohne auf den Fotografen zu warten
class PartyDev {
  final String fall;
  final String? code;
  final String? pfad;
  final int? rollen;
  final String detektiv;
  final List<String>? skript;
  final int? dauerSekunden;
  final int takt;
  final double? zeitraffer;
  final bool fotos;

  const PartyDev({
    this.fall = 'schlosskeller',
    this.code,
    this.pfad,
    this.rollen,
    this.detektiv = 'w',
    this.skript,
    this.dauerSekunden,
    this.takt = 700,
    this.zeitraffer,
    this.fotos = true,
  });

  /// Aus den URL-Parametern; `null` ohne `party=`.
  static PartyDev? ausUrl(Map<String, String> q) {
    final fall = q['party'];
    if (fall == null) return null;
    return PartyDev(
      fall: fall.isEmpty ? 'schlosskeller' : fall,
      code: q['code'],
      pfad: q['pfad'],
      rollen: int.tryParse(q['n'] ?? ''),
      detektiv: q['detektiv'] == 'm' ? 'm' : 'w',
      skript: q['skript']?.split(','),
      dauerSekunden: int.tryParse(q['dauer'] ?? ''),
      takt: int.tryParse(q['takt'] ?? '') ?? 700,
      zeitraffer: double.tryParse(q['zeitraffer'] ?? ''),
      fotos: q['fotos'] != '0',
    );
  }

  /// Fall-Code aus `code` oder `pfad`.
  String? fallCode(Kanon kanon) => code ?? (pfad == null ? null : FallCode.fuerPfad(pfad!, kanon.pfade).code);
}

/// Spielt einen Abend automatisch durch (E2E-Läufe). Benutzt nur die
/// öffentliche API der Sitzung und meldet Fotostellen als `PARTY foto=<name>`.
class PartySkript {
  PartySkript(this.sitzung, this.dev);

  final PartySitzung sitzung;
  final PartyDev dev;
  bool _laeuft = false;

  String get _entscheidungen => (dev.skript?.elementAtOrNull(0) ?? 'best');
  String get _gruppe => (dev.skript?.elementAtOrNull(1) ?? 'a');
  String get _anklage => (dev.skript?.elementAtOrNull(2) ?? 'richtig');

  Future<void> _warte([double faktor = 1]) => Future<void>.delayed(Duration(milliseconds: (dev.takt * faktor).round()));

  /// Fotostelle melden und dem Fotografen Zeit lassen (mindestens 1,2 s).
  Future<void> _foto(String name) {
    debugPrint('PARTY foto=$name');
    return Future<void>.delayed(Duration(milliseconds: dev.fotos && dev.takt < 1200 ? 1200 : dev.takt));
  }

  Future<void> starten() async {
    if (_laeuft) return;
    _laeuft = true;
    try {
      while (sitzung.phase != PartyPhase.ende) {
        await _schritt();
        await _warte();
      }
      await _foto('ende');
      final s = sitzung.spiel;
      debugPrint('PARTY fertig pfad=${s.pfad} ende=${s.ende.id} punkte=${s.punkte} rollen=${s.einstellungen.rollen}');
    } catch (e, st) {
      debugPrint('PARTY fehler $e\n$st');
    }
  }

  Future<void> _schritt() async {
    final s = sitzung;
    switch (s.phase) {
      case PartyPhase.titel:
        await _foto('titel');
        s.zurEinrichtung();
      case PartyPhase.einrichtung:
        await _foto('einrichtung');
        s.einrichten(rollen: dev.rollen ?? 7, detektiv: dev.detektiv, code: dev.fallCode(s.kanon));
        if (dev.dauerSekunden != null) s.rundendauer = Duration(seconds: dev.dauerSekunden!);
        if (dev.zeitraffer != null) s.zeitraffer = dev.zeitraffer!;
      case PartyPhase.rollen:
        await _foto('rollen');
        s.zeigeVerdeckt(s.besetzt.last);
        await _warte();
        await _foto('dossier');
        s.verdecken();
        s.weiter();
      case PartyPhase.entscheidungen:
        await _entscheiden();
      case PartyPhase.gruppenwahl:
        if (s.verdeckt != null) {
          final i = s.besetzt.indexOf(s.verdeckt!);
          final a = switch (_gruppe) { 'b' => false, 'gemischt' => i.isEven, _ => true };
          if (i == 0) {
            await _foto('wahl_verdeckt_r${s.runde}');
          }
          s.stimme(s.verdeckt!, kooperativ: a);
        } else if (s.offeneWaehler.isNotEmpty) {
          s.zeigeVerdeckt(s.offeneWaehler.first);
        } else {
          await _foto('gruppenwahl_r${s.runde}');
          s.weiter();
        }
      case PartyPhase.anklage:
        if (s.angeklagt == null) {
          await _foto('anklage');
          final pfad = s.spiel.pfad;
          final wer = switch (_anklage) {
            'richtig' => pfad,
            'falsch' => s.kernverdaechtige.firstWhere((p) => p != pfad),
            final x => x,
          };
          s.anklagen(wer);
        } else {
          s.weiter();
        }
      case PartyPhase.finale:
        await _foto('finale');
        final dauer = s.rueckblende.schritte.last.minus(s.rueckblende.schritte.first) / (dev.zeitraffer ?? 25);
        for (var i = 1; i <= 3; i++) {
          await Future<void>.delayed(Duration(milliseconds: (dauer * 1000 * 0.2).round()));
          await _foto('rueckblende_$i');
        }
        await Future<void>.delayed(Duration(milliseconds: (dauer * 1000 * 0.45).round()));
        s.weiter();
      case PartyPhase.ende:
        return;
      default:
        await _foto('${s.phase.name}${s.runde > 0 ? '_r${s.runde}' : ''}');
        s.weiter();
    }
  }

  Future<void> _entscheiden() async {
    final s = sitzung;
    final fund = s.letzterFund;
    if (fund != null) {
      await _foto('fund_${fund.entscheidung}');
      s.fundGelesen();
      return;
    }
    final v = s.vorschlag;
    if (v != null) {
      await _foto('endgueltig_${v.entscheidung}');
      s.bestaetigen();
      return;
    }
    final e = s.laufendeEntscheidung;
    if (e == null) {
      await _foto('entscheidungen_fertig_r${s.runde}');
      s.weiter();
      return;
    }
    final pfad = s.spiel.pfad;
    final richtig = e.richtig[pfad]!;
    final option = switch (_entscheidungen) {
      'schlecht' => e.optionen.firstWhere((o) => o.id != richtig).id,
      'erste' => s.optionen(e.id).first.id,
      _ => richtig,
    };
    final ziel = s.karte.ziele[option]!;
    s.detektivSetzen.value = ziel;
    await _warte(1.5);
    await _foto('ziel_${e.id}');
    s.detektivSetzen.value = null;
    s.schlageVor(option);
  }
}
