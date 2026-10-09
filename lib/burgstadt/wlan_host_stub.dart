import 'package:burgstadt_core/burgstadt_core.dart';

/// Im Browser gibt es keinen Server im Gerät: beitreten ja, eröffnen nein.
const kannGastgeben = false;

class Gastgeber {
  Future<(String, List<String>, String)> starte(BurgstadtRaum raum, String name) =>
      throw UnsupportedError('Im Browser kann keine Partie eröffnet werden.');

  Future<void> stoppe() async {}
}
