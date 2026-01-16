import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../config/constants.dart';

class AudioProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();

  // Track current audio state
  String? _currentBackgroundTrack;
  double _volume = 0.5; // Default music volume

  AudioService get audioService => _audioService;
  double get volume => _volume;

  // Update background audio based on GamePhase
  Future<void> updateAudioForPhase(GamePhase phase) async {
    String? targetTrack;

    switch (phase) {
      case GamePhase.lobby:
      case GamePhase.roleDistribution:
      case GamePhase.roleReveal:
        targetTrack = 'audio/day_music.mp3'; // Calm waiting music
        break;

      case GamePhase.firstNight:
      case GamePhase.night:
        targetTrack = 'audio/night_music.mp3'; // Suspenseful/Cricket sounds
        break;

      case GamePhase.dawn:
      case GamePhase.day:
      case GamePhase.nomination:
      case GamePhase.defense:
      case GamePhase.voting:
        targetTrack = 'audio/day_music.mp3'; // Active discussion music
        break;

      case GamePhase.execution:
      case GamePhase.gameOver:
        targetTrack = null; // Silence or specific SFX handled separately
        break;
      case GamePhase.tragedy:
        await _audioService
            .playEffect('audio/sfx/death_toll.mp3'); // Placeholder
        targetTrack = null; // Stop background music for tragedy
        break;
      case GamePhase.victory:
        targetTrack = 'audio/bgm/victory_fanfare.mp3'; // Play victory music
        break;
    }

    if (targetTrack != _currentBackgroundTrack) {
      if (targetTrack != null) {
        await _audioService.playBackgroundMusic(targetTrack);
      } else {
        await _audioService.stopBackgroundMusic();
      }
      _currentBackgroundTrack = targetTrack;
    }
  }

  Future<void> playSoundEffect(String sfxName) async {
    // e.g. 'wolf_howl.mp3', 'villager_scream.mp3'
    await _audioService.playEffect('audio/$sfxName');
  }

  void setVolume(double value) {
    _volume = value;
    // TODO: Expose setVolume in AudioService and call it here
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
