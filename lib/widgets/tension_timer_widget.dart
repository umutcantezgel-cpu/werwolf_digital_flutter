import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/design_tokens.dart';

class TensionTimerWidget extends StatefulWidget {
  final Duration duration;
  final VoidCallback onTimerFinished;

  const TensionTimerWidget({
    super.key,
    required this.duration,
    required this.onTimerFinished,
  });

  @override
  State<TensionTimerWidget> createState() => _TensionTimerWidgetState();
}

class _TensionTimerWidgetState extends State<TensionTimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isUrgent = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();

    _controller.addListener(() {
      // Trigger urgency in the last 15% of time
      if (_controller.value > 0.85 && !_isUrgent) {
        setState(() {
          _isUrgent = true;
        });
      }
      if (_controller.isCompleted) {
        widget.onTimerFinished();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _timerString {
    final remaining = widget.duration * (1.0 - _controller.value);
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final color =
            Color.lerp(DesignColors.dayDark, DesignColors.wolfRed, progress)!;

        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: DesignColors.dayLighter,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: _isUrgent ? 15 : 5,
                spreadRadius: _isUrgent ? 5 : 1,
              )
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0 - progress,
                strokeWidth: 6,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  _timerString,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        )
            .animate(target: _isUrgent ? 1 : 0)
            .shake(hz: 4, duration: 1.seconds) // Shake when urgent
            .then()
            .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                curve: Curves.easeInOut,
                duration: 500.ms); // Pulse
      },
    );
  }
}
