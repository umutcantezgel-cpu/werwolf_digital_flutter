import '../bauteil.dart';
import 'fenster.dart';

/// Register der Fassaden-Bauteile nach Name (E-010). Jedes Bauteil liegt in einer eigenen Datei
/// unter `bau/teile/` und wird hier eingetragen.
final Map<String, Bauteil> kBauteile = {
  for (final t in const <Bauteil>[FensterV1()]) t.name: t,
};
