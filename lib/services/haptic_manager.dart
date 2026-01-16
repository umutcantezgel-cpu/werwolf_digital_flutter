import 'package:flutter/services.dart';

class HapticManager {
  static final HapticManager _instance = HapticManager._internal();
  factory HapticManager() => _instance;
  HapticManager._internal();

  /// Light feedback for minor interactions (e.g., tap)
  Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Medium feedback for successful actions (e.g., confirm vote)
  Future<void> impactLight() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium-Heavy feedback for phase changes
  Future<void> impactMedium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy feedback for critical events (e.g., death)
  Future<void> impactHeavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Double pulse for dramatic moments (e.g., Wolf selection)
  Future<void> heartBeat() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
  }
}
