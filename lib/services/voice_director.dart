import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:werwolf_digital_flutter/models/role.dart';
import 'package:werwolf_digital_flutter/services/audio_manager.dart';
import 'package:werwolf_digital_flutter/providers/skin_provider.dart';

/// Directs the voice acting based on game state events.
class VoiceDirector {
  static final VoiceDirector _instance = VoiceDirector._internal();
  factory VoiceDirector() => _instance;
  VoiceDirector._internal();

  final AudioManager _audio = AudioManager();
  final Random _rng = Random();

  // Reference to SkinProvider for voice pack path
  SkinProvider? _skinProvider;

  /// Set the skin provider reference (called from main or GameProvider).
  void setSkinProvider(SkinProvider provider) {
    _skinProvider = provider;
  }

  /// Get the voice path using the selected voice pack.
  String _getVoicePath(String filename) {
    if (_skinProvider != null) {
      return _skinProvider!.getVoicePath(filename);
    }
    // Fallback to default path
    return 'voice/default/$filename';
  }

  /// Called when entering a new phase to play intro narration.
  void onPhaseStart(String phaseName, int roundNumber) {
    debugPrint('VoiceDirector: Phase Start -> $phaseName (Round $roundNumber)');

    switch (phaseName) {
      case 'night':
        _playNightIntro(roundNumber);
        break;
      case 'day':
        _playDayIntro(roundNumber);
        break;
      case 'voting':
        _audio.playVoice('voice/voting_intro.mp3');
        break;
    }
  }

  /// Called when a role wakes up.
  void onRoleWake(RoleType role) {
    final roleName = role.name.toLowerCase();
    // e.g. "werwolf_wake_1.mp3"
    _audio.playVoice('voice/${roleName}_wake.mp3');
  }

  /// Called when a role goes back to sleep.
  void onRoleSleep(RoleType role) {
    final roleName = role.name.toLowerCase();
    _audio.playVoice('voice/${roleName}_sleep.mp3');
  }

  void onDeathAnnouncement(List<String> deadPlayers) {
    if (deadPlayers.isEmpty) {
      _audio.playVoice('voice/day_no_deaths.mp3');
    } else {
      _audio.playVoice('voice/day_tragedy.mp3');
    }
  }

  /// Called when voting begins (e.g. countdown starts).
  void onVoteStart() {
    _audio.playBgm('bgm/tension_vote.mp3');
    _audio.playVoice('voice/day/vote_start.mp3');
  }

  /// Called when voting is complete and someone is eliminated.
  void onVoteComplete(String eliminatedName) {
    _audio.playSfx('sfx/death_toll.mp3');
  }

  /// Called when the game ends.
  void onGameEnd(bool villagersWin) {
    final bgm = villagersWin ? 'bgm/day_village.mp3' : 'bgm/night_ambience.mp3';
    _audio.playBgm(bgm);
  }

  void _playNightIntro(int round) {
    _audio.playBgm('bgm/night_ambience.mp3');

    // First Night is special
    if (round == 1) {
      _audio.playVoice(_getVoicePath('night/intro_01.mp3'));
      return;
    }

    // Dynamic selection for subsequent nights
    final variant = _rng.nextInt(3) + 1;
    _audio.playVoice(_getVoicePath('night/intro_generic_$variant.mp3'));
  }

  void _playDayIntro(int round) {
    _audio.playBgm('bgm/day_village.mp3');
    _audio.playSfx('sfx/rooster_crow.mp3');

    // Maybe specific day intros?
    if (round == 1) {
      // "The first morning..."
      _audio.playVoice('voice/day/sunrise_01.mp3');
    }
  }
}
