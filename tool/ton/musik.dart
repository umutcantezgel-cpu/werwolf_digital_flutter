/// Drei eigene Musikstücke als Schleifen (je 60 s, 80 BPM, 20 Takte à 4/4).
///
/// Melodien, Akkordfolgen und Stimmführung sind hier festgelegt, keine bekannten Stücke.
/// Instrumente sind synthetisch: Zither (Karplus-Strong), Streicher-Teppich und
/// Holzbläser (Wellentabellen mit Vibrato), Glocke (inharmonische Teiltöne).
/// Alles wird umlaufend gerendert: Ausklänge, die über das Schleifenende laufen,
/// setzen am Anfang fort, daher gibt es keine Naht.
library;

import 'dart:math' as math;
import 'dart:typed_data';

import 'klangwerk.dart';

const double _schlag = 0.75; // 80 BPM: eine Viertelnote = 0,75 s
const double _takt = 3.0; // ein Takt = 3,0 s
const double _laenge = 60.0; // 20 Takte

/// Art der Basslinie: keine, Zither-Grundton auf 1 und 3, Pizzicato im Viertelschlag.
enum Bass { keiner, zitherGrund, pizzicato }

double _hz(num midi) => 440.0 * math.pow(2, (midi - 69) / 12).toDouble();

final Float64List _streicher = wellenform([for (var k = 1; k <= 10; k++) math.pow(k, -1.3).toDouble()]);
final Float64List _klarinette = wellenform([1.0, 0.0, 0.35, 0.0, 0.15, 0.0, 0.06]);
final Float64List _floete = wellenform([1.0, 0.3, 0.1, 0.05]);

/// Streicher-Teppich: drei leicht verstimmte Stimmen, langsamer Ansatz und Ausklang.
Float64List _pad(double f, double dauer) {
  final out = Float64List(sekunden(dauer));
  for (final cents in [-5.0, 0.0, 5.0]) {
    mische(
      out,
      ton(
        tabelle: _streicher,
        frequenz: f,
        dauer: dauer,
        angriff: 0.8,
        abfall: 0.5,
        haltepegel: 0.8,
        ausklang: 1.0,
        vibratoTiefe: 0.003,
        vibratoHz: 5.2,
        cents: cents,
      ),
      pegel: 0.33,
    );
  }
  return out;
}

Float64List _stueck({
  required List<List<int>> akkorde,
  required List<num> melodie,
  required Float64List melodieTabelle,
  required bool zitherMelodie,
  required Bass bass,
  required List<(int, int)> glocken,
  required int seed,
  double nachhall = 2.0,
}) {
  final rnd = Lcg(seed);
  final buf = Float64List(sekunden(_laenge));

  for (var takt = 0; takt < akkorde.length; takt++) {
    for (final midi in akkorde[takt]) {
      mische(buf, _pad(_hz(midi), 4.0), versatz: sekunden(takt * _takt), pegel: 0.18, kreis: true);
    }
  }

  for (var k = 0; k < melodie.length; k += 3) {
    final midi = melodie[k];
    final beat = melodie[k + 1];
    final beats = melodie[k + 2];
    final f = _hz(midi);
    final Float64List ton0 = zitherMelodie
        ? zupfen(frequenz: f, dauer: beats * _schlag + 1.2, ausklang: 1.6, rnd: rnd, helligkeit: 0.55)
        : ton(
            tabelle: melodieTabelle,
            frequenz: f,
            dauer: beats * _schlag + 0.1,
            angriff: 0.08,
            abfall: 0.12,
            haltepegel: 0.85,
            ausklang: 0.15,
            vibratoTiefe: 0.008,
            vibratoHz: 5.0,
          );
    mische(buf, ton0, versatz: sekunden(beat * _schlag), pegel: 0.5, kreis: true);
  }

  for (var takt = 0; takt < akkorde.length; takt++) {
    final wurzel = akkorde[takt][0] - 12;
    if (bass == Bass.zitherGrund) {
      for (final schlag in [0.0, 2.0]) {
        final pluck = zupfen(frequenz: _hz(wurzel), dauer: 2.0, ausklang: 1.4, rnd: rnd, helligkeit: 0.3);
        mische(buf, pluck, versatz: sekunden(takt * _takt + schlag * _schlag), pegel: 0.9, kreis: true);
      }
    } else if (bass == Bass.pizzicato) {
      for (var schlag = 0; schlag < 4; schlag++) {
        final midi = schlag.isEven ? wurzel : wurzel + 7;
        final pluck = zupfen(frequenz: _hz(midi), dauer: 1.2, ausklang: 0.9, rnd: rnd, helligkeit: 0.3);
        mische(buf, pluck, versatz: sekunden(takt * _takt + schlag * _schlag), pegel: 0.6, kreis: true);
      }
    }
  }

  for (final (takt, midi) in glocken) {
    final bell = glocke(grundton: _hz(midi), dauer: 4.0, ausklang: 3.0, rnd: rnd, helligkeit: 0.5, anschlag: 0.15);
    mische(buf, bell, versatz: sekunden(takt * _takt), pegel: 0.6, kreis: true);
  }

  return hall(buf, nachhall: nachhall, anteil: 0.2, kreis: true);
}

/// Gewölbe: gedämpft und ruhig, D-Moll mit Dorischem Einschlag, Zither-Melodie über Streichern.
Float64List musikGewoelbeSchleife() {
  const dm = [50, 53, 57, 62];
  const bb = [46, 53, 58, 62];
  const c = [48, 52, 55, 60];
  const g = [43, 50, 55, 59];
  const am = [45, 52, 57, 60];
  return _stueck(
    akkorde: [dm, bb, c, dm, dm, g, c, am, dm, bb, g, dm, dm, c, bb, am, dm, g, c, dm],
    melodie: [
      74, 0, 2, 69, 2, 1, 65, 3, 1, //
      65, 4, 1, 62, 5, 1, 70, 6, 2, //
      67, 8, 1, 64, 9, 1, 72, 10, 2, //
      69, 12, 1, 65, 13, 1, 62, 14, 2, //
      65, 16, 1, 69, 17, 1, 74, 18, 2, //
      71, 20, 1, 67, 21, 1, 74, 22, 2, //
      76, 24, 1, 72, 25, 1, 67, 26, 2, //
      69, 28, 1, 72, 29, 1, 76, 30, 2, //
      74, 32, 2, 72, 34, 1, 69, 35, 1, //
      65, 36, 1, 62, 37, 1, 70, 38, 2, //
      74, 40, 1, 71, 41, 1, 67, 42, 2, //
      65, 44, 1, 69, 45, 1, 62, 46, 2, //
      69, 48, 1, 65, 49, 1, 62, 50, 2, //
      67, 52, 1, 64, 53, 1, 72, 54, 2, //
      74, 56, 1, 70, 57, 1, 65, 58, 2, //
      64, 60, 1, 69, 61, 1, 72, 62, 2, //
      74, 64, 2, 69, 66, 1, 65, 67, 1, //
      71, 68, 1, 74, 69, 1, 67, 70, 2, //
      72, 72, 1, 64, 73, 1, 67, 74, 2, //
      62, 76, 2, 69, 78, 1, 74, 79, 1,
    ],
    melodieTabelle: _streicher,
    zitherMelodie: true,
    bass: Bass.zitherGrund,
    glocken: [(0, 62), (4, 62), (8, 62), (12, 62), (16, 62)],
    seed: 9101,
  );
}

/// Gassen bei Nacht: schreitend, E-Phrygisch, Klarinetten-artige Melodie über Pizzicato.
Float64List musikGassenSchleife() {
  const em = [52, 55, 59, 64];
  const f = [53, 57, 60, 65];
  const am = [45, 52, 57, 60];
  return _stueck(
    akkorde: [em, f, am, em, em, am, f, em, em, f, am, em, em, am, f, em, em, f, am, em],
    melodie: [
      76, 0, 1.5, 74, 1.5, 0.5, 71, 2, 1, 67, 3, 1, //
      69, 4, 1, 72, 5, 1, 77, 6, 2, //
      76, 8, 1, 72, 9, 1, 69, 10, 2, //
      71, 12, 1, 69, 13, 1, 67, 14, 1, 64, 15, 1, //
      76, 16, 1, 79, 17, 1, 71, 18, 2, //
      69, 20, 1, 72, 21, 1, 76, 22, 2, //
      77, 24, 1, 72, 25, 1, 69, 26, 2, //
      67, 28, 1, 71, 29, 1, 76, 30, 2, //
      71, 32, 1, 76, 33, 1, 74, 34, 2, //
      72, 36, 1, 69, 37, 1, 65, 38, 2, //
      69, 40, 1, 72, 41, 1, 76, 42, 2, //
      79, 44, 1, 76, 45, 1, 74, 46, 2, //
      64, 48, 1, 67, 49, 1, 71, 50, 2, //
      72, 52, 1, 69, 53, 1, 76, 54, 2, //
      77, 56, 1, 81, 57, 1, 72, 58, 2, //
      71, 60, 1, 69, 61, 1, 67, 62, 1, 64, 63, 1, //
      76, 64, 1, 74, 65, 1, 71, 66, 2, //
      69, 68, 1, 72, 69, 1, 77, 70, 2, //
      76, 72, 1, 72, 73, 1, 69, 74, 2, //
      67, 76, 1, 64, 77, 3,
    ],
    melodieTabelle: _klarinette,
    zitherMelodie: false,
    bass: Bass.pizzicato,
    glocken: const [],
    seed: 9201,
  );
}

/// Morgengrauen: hell und offen, D-Lydisch, Flöten-artige Melodie über Streichern und Glocken.
Float64List musikMorgengrauen() {
  const d = [50, 57, 62, 66];
  const e = [52, 56, 59, 64];
  const a = [45, 52, 57, 64];
  const bm = [47, 54, 59, 62];
  return _stueck(
    akkorde: [d, e, a, bm, d, a, e, bm, d, e, a, bm, d, bm, e, a, d, e, a, d],
    melodie: [
      69, 0, 2, 74, 2, 2, //
      80, 4, 2, 76, 6, 2, //
      81, 8, 2, 85, 10, 2, //
      83, 12, 2, 78, 14, 2, //
      74, 16, 2, 78, 18, 2, //
      76, 20, 1, 73, 21, 1, 81, 22, 2, //
      80, 24, 2, 83, 26, 2, //
      74, 28, 1, 78, 29, 1, 71, 30, 2, //
      78, 32, 2, 81, 34, 2, //
      83, 36, 2, 80, 38, 2, //
      85, 40, 2, 76, 42, 2, //
      86, 44, 2, 78, 46, 2, //
      69, 48, 2, 74, 50, 2, //
      71, 52, 2, 74, 54, 2, //
      80, 56, 2, 83, 58, 2, //
      85, 60, 2, 81, 62, 2, //
      74, 64, 2, 69, 66, 2, //
      76, 68, 2, 80, 70, 2, //
      81, 72, 2, 85, 74, 2, //
      86, 76, 2, 74, 78, 2,
    ],
    melodieTabelle: _floete,
    zitherMelodie: false,
    bass: Bass.keiner,
    glocken: [(0, 81), (8, 81), (12, 81)],
    seed: 9301,
  );
}
