// Textprüfung des Partymodus (F3-BAUMEISTER-01): prüft alle Spielertexte gegen den TON-LEITFADEN §4–§6.
// Aufruf (im Paketordner): dart run bin/party_texte.dart [--fall schlosskeller]
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';

void main(List<String> args) {
  String? wert(String name) {
    final i = args.indexOf(name);
    return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
  }

  final fall = wert('--fall') ?? 'schlosskeller';
  final wurzel = _wurzel();
  final ordner = '$wurzel/content/party/$fall';
  Map<String, Object?> lies(String pfad) => jsonDecode(File(pfad).readAsStringSync()) as Map<String, Object?>;

  final kanon = Kanon.lade((p) => lies('$ordner/$p'));
  final sammlung = Textsammlung.lade((p) => lies('$ordner/$p'));
  final regeln = lies('$wurzel/content/party/textregeln.json');
  final pruefer = Textpruefer(regeln);
  final quellen = textQuellen(kanon, sammlung);

  final befunde = <TextBefund>[for (final q in quellen) ...pruefer.pruefe(q)];
  final bereiche = <String, List<TextQuelle>>{};
  for (final q in quellen) {
    (bereiche[q.ort.split('#').first] ??= []).add(q);
  }
  for (final e in bereiche.entries) {
    befunde.addAll(pruefer.pruefeMittel(e.key, e.value));
  }
  befunde.addAll(textLint(kanon, quellen, regeln: regeln));

  for (final b in befunde) {
    stdout.writeln('${b.ort}: ${b.regel}: ${b.auszug}');
  }
  stdout.writeln('Geprüfte Texte: ${quellen.length}');
  stdout.writeln(befunde.isEmpty ? 'Texte: OK (${quellen.length} Texte)' : 'Texte: ${befunde.length} Befunde');
  exitCode = befunde.isEmpty ? 0 : 1;
}

String _wurzel() {
  var d = Directory.current;
  while (!Directory('${d.path}/content/party').existsSync()) {
    final p = d.parent;
    if (p.path == d.path) throw StateError('content/party nicht gefunden');
    d = p;
  }
  return d.path;
}
