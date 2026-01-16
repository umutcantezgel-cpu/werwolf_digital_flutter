import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Service to manage game audio ensuring layered playback (BGM, SFX, VO).
class AudioManager {
  // Singleton instance
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  // Players for different layers
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer(); // Shared for simple SFX
  final AudioPlayer _voPlayer = AudioPlayer(); // Voice Over Layer

  // State
  bool _isMuted = false;
  final double _bgmVolume = 0.5;
  final double _sfxVolume = 1.0;
  final double _voVolume = 1.0;

  /// Initialize audio settings (e.g. set context for iOS if needed)
  Future<void> init() async {
    // Configure players, e.g., set release mode for BGM
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _voPlayer.setReleaseMode(ReleaseMode.stop);
    debugPrint('AudioManager initialized');
  }

  // ===========================================================================
  // Background Music (BGM)
  // ===========================================================================

  /// Play a looping background track.
  /// [path] should be relative to assets/audio/ (e.g., 'night/ambience_loop.mp3')
  Future<void> playBgm(String path, {double fadeDuration = 1.0}) async {
    if (_isMuted) return;

    try {
      // In a real app we might fade out the current track here
      await _bgmPlayer.setVolume(_bgmVolume);
      await _bgmPlayer.play(AssetSource('audio/$path'));
    } catch (e) {
      debugPrint('Error playing BGM: $e');
    }
  }

  Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping BGM: $e');
    }
  }

  // ===========================================================================
  // Sound Effects (SFX)
  // ===========================================================================

  /// Play a one-shot sound effect.
  Future<void> playSfx(String path) async {
    if (_isMuted) return;

    try {
      // For overlapping SFX, we might want to create temporary players,
      // but for simplicity we reuse one or create a new one for critical sounds.
      // To allow overlapping, we can just strictly use a new player or fire-and-forget mode if specific API supports it.
      // AudioPlayers play() on a reusable player stops the previous sound.
      // For better SFX, usually simplest is:
      final player = AudioPlayer();
      await player.setVolume(_sfxVolume);
      await player.play(AssetSource('audio/$path'));
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (e) {
      debugPrint('Error playing SFX: $e');
    }
  }

  // ===========================================================================
  // Voice Over (VO)
  // ===========================================================================

  /// Play a voice line. Stops any current VO.
  Future<void> playVoice(String path) async {
    if (_isMuted) return;

    try {
      // Duck BGM volume while VO plays
      await _bgmPlayer.setVolume(_bgmVolume * 0.3);

      await _voPlayer.setVolume(_voVolume);
      await _voPlayer.play(AssetSource('audio/$path'));

      // Restore BGM after VO
      _voPlayer.onPlayerComplete.listen((_) {
        _bgmPlayer.setVolume(_bgmVolume);
      });
    } catch (e) {
      debugPrint('Error playing VO: $e');
      // Ensure BGM is restored even on error
      _bgmPlayer.setVolume(_bgmVolume);
    }
  }

  Future<void> stopVoice() async {
    await _voPlayer.stop();
    await _bgmPlayer.setVolume(_bgmVolume);
  }

  // ===========================================================================
  // Controls
  // ===========================================================================

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _bgmPlayer.setVolume(0);
      _sfxPlayer.setVolume(0);
      _voPlayer.setVolume(0);
    } else {
      _bgmPlayer.setVolume(_bgmVolume);
      _sfxPlayer.setVolume(_sfxVolume);
      _voPlayer.setVolume(_voVolume);
    }
  }

  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    _voPlayer.dispose();
  }
}
