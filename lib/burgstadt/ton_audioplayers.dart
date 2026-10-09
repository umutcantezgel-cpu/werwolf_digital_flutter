import 'package:audioplayers/audioplayers.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:flutter/foundation.dart';

/// Tonausgabe über audioplayers: ein kleiner Pool für Einzelklänge, je Kanal ein
/// Schleifen-Spieler. Fehler (z. B. Browser ohne Nutzergeste) werden geschluckt.
class AudioplayersTon implements Tonausgabe {
  final List<AudioPlayer> _pool = [for (var i = 0; i < 6; i++) AudioPlayer()];
  final Map<String, AudioPlayer> _kanal = {};
  final Map<String, String?> _laeuft = {};
  int _naechster = 0;
  double _gesamt = 0.8;

  static Source _quelle(String name) => AssetSource('burgstadt/ton/$name.wav');

  @override
  void gesamt(double wert) {
    _gesamt = wert.clamp(0.0, 1.0);
  }

  @override
  void spiele(String name, {double lautstaerke = 1}) {
    if (_gesamt <= 0) return;
    final p = _pool[_naechster++ % _pool.length];
    _sicher(() async {
      await p.stop();
      await p.setVolume(lautstaerke * _gesamt);
      await p.play(_quelle(name));
    });
  }

  @override
  void schleife(String kanal, String? name, {double lautstaerke = 1}) {
    if (_laeuft[kanal] == name) return;
    _laeuft[kanal] = name;
    final p = _kanal.putIfAbsent(kanal, () => AudioPlayer()..setReleaseMode(ReleaseMode.loop));
    _sicher(() async {
      await p.stop();
      if (name == null || _gesamt <= 0) return;
      await p.setVolume(lautstaerke * _gesamt);
      await p.play(_quelle(name));
    });
  }

  void _sicher(Future<void> Function() f) {
    f().catchError((Object e) {
      if (kDebugMode) debugPrint('Ton: $e');
    });
  }

  void dispose() {
    for (final p in [..._pool, ..._kanal.values]) {
      p.dispose();
    }
  }
}
