import 'package:flutter/material.dart';
import '../config/constants.dart';
// import '../config/theme.dart'; // Unused

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setTheme(ThemeMode themeMode) {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      notifyListeners();
    }
  }

  void updateThemeForPhase(GamePhase phase) {
    // Automatically switch theme mode based on phase
    if (phase == GamePhase.night ||
        phase == GamePhase.roleDistribution ||
        phase == GamePhase.firstNight) {
      setTheme(ThemeMode.dark);
    } else {
      setTheme(ThemeMode.light);
    }
  }
}
