import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

void main() {
  tearDown(() => FigurenLager.prozessorZeitMs = null);

  test('Nachmessen: eine Unterbrechung der Maschine in einem Back-Schritt zählt nicht als Arbeit (E56)', () {
    // Uhr wie im Messwerkzeug, nur dass beim zweiten Ablesen (Ende des ersten Schritts) 60 ms
    // hinzukommen – so rechnet eine VM eine Unterbrechung durch den Wirt dem Thread an.
    final sw = Stopwatch()..start();
    var ablesungen = 0;
    var aussetzer = 0.0;
    FigurenLager.prozessorZeitMs = () {
      if (++ablesungen == 2) aussetzer = 60;
      return sw.elapsedMicroseconds / 1000 + aussetzer;
    };
    final lager = FigurenLager(kTeileBasis)..karte(karteAusSteckbrief({'id': 'T1'}));
    for (var i = 0; i < 20 && lager.offen > 0; i++) {
      lager.backe(3);
    }
    expect(lager.maxBackCpuMs, greaterThanOrEqualTo(60));
    expect(lager.spitzenSchritte, isNotEmpty);
    expect(lager.spitzenSchritte.first.$2, isNotEmpty, reason: 'Arbeit des Schritts ist festgehalten');
    final nach = lager.nachmessen();
    expect(nach, greaterThan(0), reason: 'die Arbeit wurde wirklich noch einmal getan');
    expect(nach, lessThan(30), reason: 'der Aussetzer fällt heraus');
  });

  test('Ohne Prozessoruhr bleibt nachmessen beim gemessenen Wert', () {
    final lager = FigurenLager(kTeileBasis)..karte(karteAusSteckbrief({'id': 'T1'}));
    lager.backe(3);
    expect(lager.spitzenSchritte, isEmpty);
    expect(lager.nachmessen(), lager.maxBackCpuMs);
  });
}
