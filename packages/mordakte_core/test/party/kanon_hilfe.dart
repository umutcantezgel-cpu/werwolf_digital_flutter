import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';

/// Wurzel des Repos (Tests laufen in `packages/mordakte_core`).
final String repoWurzel = () {
  var d = Directory.current;
  while (!Directory('${d.path}/content/party').existsSync()) {
    final p = d.parent;
    if (p.path == d.path) throw StateError('content/party nicht gefunden');
    d = p;
  }
  return d.path;
}();

Map<String, Object?> leseJson(String pfad) => jsonDecode(File(pfad).readAsStringSync()) as Map<String, Object?>;

/// Lädt den Kanon eines Falls aus `content/party/<fall>/`.
Kanon ladeKanon([String fall = 'schlosskeller']) => Kanon.lade((p) => leseJson('$repoWurzel/content/party/$fall/$p'));

Kanon? _kanon;
Plausibilitaet? _pruefer;

/// Einmal geladener Kanon und Plausibilitätsprüfer für alle Tests einer Datei.
Kanon get kanon => _kanon ??= ladeKanon();
Plausibilitaet get pruefer => _pruefer ??= Plausibilitaet(kanon);
