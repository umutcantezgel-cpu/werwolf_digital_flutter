import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/audio_provider.dart';
import 'providers/game_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/tts_provider.dart';
import 'providers/skin_provider.dart';
import 'utils/performance_monitor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SkinProvider from SharedPreferences
  final skinProvider = SkinProvider();
  await skinProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => TtsProvider()),
        ChangeNotifierProvider.value(value: skinProvider),
      ],
      child: const PerformanceMonitor(
        child: WerwolfApp(),
      ),
    ),
  );
}
