import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();

  AudioService() {
    _musicPlayer.setReleaseMode(ReleaseMode.loop); // Loop background music
  }

  Future<void> playEffect(String assetPath) async {
    await _effectPlayer.play(AssetSource(assetPath));
  }

  Future<void> playBackgroundMusic(String assetPath) async {
    await _musicPlayer.play(AssetSource(assetPath));
  }

  Future<void> stopBackgroundMusic() async {
    await _musicPlayer.stop();
  }

  Future<void> dispose() async {
    await _effectPlayer.dispose();
    await _musicPlayer.dispose();
  }
}
