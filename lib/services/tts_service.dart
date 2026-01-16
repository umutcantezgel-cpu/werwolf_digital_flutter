import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  late FlutterTts _flutterTts;

  TtsService() {
    _flutterTts = FlutterTts();
    _setLanguage();
  }

  Future<void> _setLanguage() async {
    await _flutterTts.setLanguage("de-DE"); // Set German language
    await _flutterTts.setSpeechRate(0.55); // Slightly faster for flow
    await _flutterTts.setVolume(1.0); // Full volume
    await _flutterTts.setPitch(0.85); // Deeper, narrator-like pitch
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Future<void> dispose() async {
    // There is no explicit dispose method for FlutterTts,
    // but stopping any ongoing speech is good practice.
    await _flutterTts.stop();
  }
}
