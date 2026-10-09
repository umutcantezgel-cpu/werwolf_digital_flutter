// PDF-Probeseite des Partymodus (Spike F1-ORCH-11).
// Aufruf (im Paketordner): dart run bin/party_druck_probe.dart [figur] [ausgabe.pdf]
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/src/party/druck/probe.dart';
import 'package:mordakte_core/src/party/kanon/kanon.dart';

Future<void> main(List<String> args) async {
  var d = Directory.current;
  while (!Directory('${d.path}/content/party').existsSync()) {
    d = d.parent;
  }
  final wurzel = d.path;
  final kanon = Kanon.lade((p) => jsonDecode(File('$wurzel/content/party/schlosskeller/$p').readAsStringSync()) as Map<String, Object?>);
  final figur = args.isNotEmpty ? args[0] : 'leyla';
  final aus = File(args.length > 1 ? args[1] : '$wurzel/build/druck_probe/probe_$figur.pdf');
  aus.parent.createSync(recursive: true);
  final bytes = await druckProbe(
    kanon,
    figur,
    regular: File('$wurzel/assets/fonts/Inter-Regular.ttf').readAsBytesSync(),
    fett: File('$wurzel/assets/fonts/Inter-Bold.ttf').readAsBytesSync(),
  );
  aus.writeAsBytesSync(bytes);
  stdout.writeln('Geschrieben: ${aus.path} (${bytes.length} Bytes)');
}
