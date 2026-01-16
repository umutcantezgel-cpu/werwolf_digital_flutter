import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../config/design_tokens.dart';

class PhaseTransitionOverlay extends StatefulWidget {
  final GamePhase phase;
  final Widget? child;

  const PhaseTransitionOverlay({super.key, required this.phase, this.child});

  @override
  State<PhaseTransitionOverlay> createState() => _PhaseTransitionOverlayState();
}

class _PhaseTransitionOverlayState extends State<PhaseTransitionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Color?> _topColorAnimation;
  late Animation<Color?> _bottomColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: DesignDurations.transitionPhase, // 3 seconds
    );

    // Initial state (hidden)
    _opacityAnimation = ConstantTween(0.0).animate(_controller);
    _topColorAnimation = ConstantTween(Colors.transparent).animate(_controller);
    _bottomColorAnimation =
        ConstantTween(Colors.transparent).animate(_controller);
  }

  @override
  void didUpdateWidget(PhaseTransitionOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.phase != oldWidget.phase) {
      _triggerTransition(widget.phase);
    }
  }

  void _triggerTransition(GamePhase newPhase) {
    if (newPhase == GamePhase.day) {
      _playSunrise();
    } else if (newPhase == GamePhase.night) {
      _playSunset();
    }
  }

  void _playSunrise() {
    // Night -> Day (Explosive Sunrise)
    _controller.duration = DesignDurations.transitionPhase;

    _topColorAnimation = ColorTween(
      begin: DesignColors.nightBlack,
      end: DesignColors.dayBright,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _bottomColorAnimation = ColorTween(
      begin: DesignColors.nightMid,
      end: DesignColors.dayWarm,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    // Fade In overlay -> Hold -> Fade Out (revealing Day UI)
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0), weight: 10), // Fast fade in
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 50), // Hold
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0), weight: 40), // Fade to reveal
    ]).animate(_controller);

    _controller.forward(from: 0.0);
  }

  void _playSunset() {
    // Day -> Night (Dread setting in)
    _controller.duration = DesignDurations.transitionPhase;

    _topColorAnimation = ColorTween(
      begin: DesignColors.dayLighter,
      end: DesignColors.nightBlack,
    ).animate(_controller);

    _bottomColorAnimation = ColorTween(
      begin: DesignColors.dayWarm,
      end: DesignColors.nightMid,
    ).animate(_controller);

    // Fade In overlay (becoming dark) -> Fade Out (revealing Dark UI)
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 40),
    ]).animate(_controller);

    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Optimization: Don't render if opacity is 0
              if (_opacityAnimation.value == 0.0) {
                return const SizedBox.shrink();
              }

              return Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _topColorAnimation.value ?? Colors.transparent,
                        _bottomColorAnimation.value ?? Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
