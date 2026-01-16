import 'package:flutter/material.dart';
import '../services/tts_service.dart';

class TtsProvider extends ChangeNotifier {
  final TtsService _ttsService = TtsService();

  TtsService get ttsService => _ttsService;

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }
}
