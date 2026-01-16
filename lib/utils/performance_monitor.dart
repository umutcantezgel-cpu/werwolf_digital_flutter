import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final Duration logInterval;
  final int warningThreshold;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.enabled = true,
    this.logInterval = const Duration(seconds: 1),
    this.warningThreshold = 50,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  int _frameCount = 0;
  Ticker? _ticker;
  DateTime? _lastLogTime;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _ticker = Ticker(_onTick)..start();
      _lastLogTime = DateTime.now();
    }
  }

  void _onTick(Duration elapsed) {
    _frameCount++;
    final now = DateTime.now();
    final diff = now.difference(_lastLogTime!);

    if (diff >= widget.logInterval) {
      final fps = _frameCount / (diff.inMilliseconds / 1000.0);
      if (fps < widget.warningThreshold) {
        debugPrint('⚠️ Low FPS: ${fps.toStringAsFixed(1)}');
      }
      _frameCount = 0;
      _lastLogTime = now;
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
