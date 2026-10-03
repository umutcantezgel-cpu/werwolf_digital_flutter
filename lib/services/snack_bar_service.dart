import 'package:flutter/material.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';

class SnackBarService {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message) {
    _showSnackBar(message, DesignColors.villageGreen);
  }

  static void showError(String message) {
    _showSnackBar(message, DesignColors.wolfGlow);
  }

  static void showInfo(String message) {
    _showSnackBar(message, DesignColors.roleSeherinAccent);
  }

  static void _showSnackBar(String message, Color backgroundColor) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: DesignColors.textNightPrimary),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
