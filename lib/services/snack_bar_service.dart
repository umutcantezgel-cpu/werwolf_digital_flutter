import 'package:flutter/material.dart';

class SnackBarService {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message) {
    _showSnackBar(message, Colors.green);
  }

  static void showError(String message) {
    _showSnackBar(message, Colors.redAccent);
  }

  static void showInfo(String message) {
    _showSnackBar(message, Colors.blueAccent);
  }

  static void _showSnackBar(String message, Color backgroundColor) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
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
