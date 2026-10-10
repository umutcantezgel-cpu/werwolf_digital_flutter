// Druckspiel des Partymodus als PDF-Satz (F5, Master 7.14).
// Aufruf (im Paketordner):
//   dart run bin/party_druck.dart [--code XXXXX | --pfad <ahmet|fatma|olli|can>] [--n 12] [--detektiv w] [--dauer 30] [--aus ordner]
// Ohne Code und Pfad entsteht ein Zufallsfall. Der Pfad ist nur für Testläufe
// der Spielleitung gedacht; im Ordnernamen steht nur der Code.
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte_core/src/party/druck/modell.dart';
import 'package:mordakte_core/src/party/druck/satz.dart';
import 'package:mordakte_core/src/party/druck/satz_stil.dart';

Future<void> main(List<String> args) async {
  String? wert(String name) {
    final i = args.indexOf('--$name');
    return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
  }

  var d = Directory.current;
  while (!Directory('${d.path}/content/party').existsSync()) {
    d = d.parent;
  }
  final wurzel = d.path;
  Map<String, Object?> lies(String p) => jsonDecode(File('$wurzel/content/party/schlosskeller/$p').readAsStringSync()) as Map<String, Object?>;
  final kanon = Kanon.lade(lies);
  final texte = Texte(kanon, Textsammlung.lade(lies));
  final code = switch ((wert('code'), wert('pfad'))) {
    (final String c, _) => FallCode.lesen(c) ?? (throw ArgumentError('ungültiger Fall-Code $c')),
    (_, final String p) => FallCode.fuerPfad(p, kanon.pfade),
    _ => FallCode.zufall(Rng(DateTime.now().microsecondsSinceEpoch & 0x7fffffff)),
  };
  final n = int.parse(wert('n') ?? '12');
  final detektiv = wert('detektiv') ?? 'w';
  final aus = Directory(wert('aus') ?? '$wurzel/build/druck/${code.code}-n$n');
  aus.createSync(recursive: true);

  final stil = DruckStil(
    regular: File('$wurzel/assets/fonts/Inter-Regular.ttf').readAsBytesSync(),
    fett: File('$wurzel/assets/fonts/Inter-Bold.ttf').readAsBytesSync(),
    schreibmaschine: File('$wurzel/assets/fonts/SpecialElite-Regular.ttf').readAsBytesSync(),
  );
  final dauer = wert('dauer');
  final satz = DruckSatz.aus(kanon, texte, code, rollen: n, detektiv: detektiv, rundendauerMinuten: dauer == null ? null : int.parse(dauer));
  final dateien = await druckDateien(DruckKontext(kanon, texte, satz, stil));
  for (final f in dateien) {
    File('${aus.path}/${f.name}').writeAsBytesSync(f.bytes);
    stdout.writeln('${f.name.padRight(30)} ${(f.bytes.length / 1024).toStringAsFixed(0).padLeft(6)} KB');
  }
  stdout.writeln('Druckspiel ${code.code} für $n Rollen und das Geburtstagskind in ${aus.path}');
}
