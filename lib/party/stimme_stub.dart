import 'stimme.dart';

/// Stimme ohne Sprachausgabe (Tests, Entwickler-Einstieg, Geräte ohne Stimme):
/// nichts ist verfügbar, nichts wird gesprochen.
Stimme erzeugeStimme() => StimmeStub();

/// Der Stub: immer ohne Stimme.
class StimmeStub extends Stimme {
  @override
  bool get verfuegbar => false;

  @override
  Future<bool> sprich(String text) => Future.value(false);

  @override
  void stopp() {}
}
