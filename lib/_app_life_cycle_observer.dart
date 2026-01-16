import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/providers/audio_provider.dart';
import 'package:werwolf_digital_flutter/providers/tts_provider.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final BuildContext context;

  AppLifecycleObserver(this.context);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final ttsProvider = Provider.of<TtsProvider>(context, listen: false);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // Stop audio and TTS when the app is in the background
        audioProvider.audioService.stopBackgroundMusic();
        ttsProvider.ttsService.stop();
        break;
      case AppLifecycleState.resumed:
        // Optionally resume background music or TTS here if desired
        // audioProvider.audioService.playBackgroundMusic(AudioConfig.backgroundMusicDay); // Example
        break;
      case AppLifecycleState.detached:
        // Clean up resources if necessary (though dispose methods handle this for providers)
        break;
    }
  }
}
