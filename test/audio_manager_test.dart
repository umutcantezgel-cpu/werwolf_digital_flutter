import 'package:flutter_test/flutter_test.dart';
import 'package:werwolf_digital_flutter/services/audio_manager.dart';

// Since AudioPlayers uses platform channels, we can't easily test the actual playback
// without complex mocking. For now, we verify the singleton and methods don't crash.
// In a real project, we'd mock the AudioPlayer instance.

import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('xyz.luan/audioplayers');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return 1; // Return some ID
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      null,
    );
  });

  test('AudioManager Singleton works', () {
    final audio1 = AudioManager();
    final audio2 = AudioManager();
    expect(audio1, same(audio2));
  });

  test('AudioManager mute toggle works', () {
    final audio = AudioManager();
    // Default is unmuted
    audio.toggleMute(); // Mute
    // Can't check private field directly, but operation should complete
    audio.toggleMute(); // Unmute
  });
}
