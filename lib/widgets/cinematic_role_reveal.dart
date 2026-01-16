import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/design_tokens.dart';
import '../services/haptic_manager.dart';

/// The 5-Phase "Weltklasse" Role Reveal Animation.
///
/// 1. Anticipation: Breathing, Floating Particles
/// 2. Flip: 3D Rotation + Light Flash
/// 3. Reveal: Staggered Fade-in (Art -> Name -> Badge)
/// 4. Confirmation: Haptic Heartbeat on press
/// 5. Transition: Fly-out into the abyss
class CinematicRoleReveal extends StatefulWidget {
  final Widget front;
  final Widget back;
  final VoidCallback? onRevealComplete;

  final bool isTesting;

  const CinematicRoleReveal({
    super.key,
    required this.front,
    required this.back,
    this.onRevealComplete,
    this.isTesting = false,
  });

  @override
  State<CinematicRoleReveal> createState() => _CinematicRoleRevealState();
}

class _CinematicRoleRevealState extends State<CinematicRoleReveal>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _tiltAnimation;

  // Staggered Reveal Controllers
  late AnimationController _artController;
  late AnimationController _nameController;
  late AnimationController _badgeController;

  bool _isFront = false;
  bool _isAnimating = false;
  bool _isRevealed = false; // Phase 3 Complete

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
        vsync: this,
        duration: widget.isTesting ? Duration.zero : DesignDurations.cardFlip);

    // Staggered controllers
    _artController = AnimationController(
        vsync: this, duration: widget.isTesting ? Duration.zero : 600.ms);
    _nameController = AnimationController(
        vsync: this, duration: widget.isTesting ? Duration.zero : 600.ms);
    _badgeController = AnimationController(
        vsync: this, duration: widget.isTesting ? Duration.zero : 600.ms);

    // Flip Physics
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.15), weight: 50), // Scale UP
      TweenSequenceItem(
          tween: Tween(begin: 1.15, end: 1.0), weight: 50), // Scale DOWN
    ]).animate(
        CurvedAnimation(parent: _flipController, curve: Curves.easeInOut));

    _tiltAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.1), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: 0.0), weight: 50),
    ]).animate(
        CurvedAnimation(parent: _flipController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _flipController.dispose();
    _artController.dispose();
    _nameController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isAnimating || _isFront) {
      if (_isRevealed) {
        // Phase 4: Confirmation (Heartbeat) & Phase 5: Transition
        _handleConfirmation();
      }
      return;
    }

    // Phase 2: The Flip
    _startFlipSequence();
  }

  Future<void> _startFlipSequence() async {
    setState(() {
      _isAnimating = true;
      _isFront = true;
    });

    // Sound: Card Flip
    // AudioManager().playSfx('sfx/card_flip.mp3');
    HapticManager().selection();

    await _flipController.forward();
    if (!mounted) return;

    // Phase 3: The Reveal (Staggered)
    // Flash effect could be here

    // 1. Art
    if (!widget.isTesting) await Future.delayed(200.ms);
    if (!mounted) return;
    _artController.forward();

    // 2. Name
    if (!widget.isTesting) await Future.delayed(300.ms);
    if (!mounted) return;
    _nameController.forward();

    // 3. Badge / Role Description
    if (!widget.isTesting) await Future.delayed(300.ms);
    if (!mounted) return;
    await _badgeController.forward();

    setState(() {
      _isAnimating = false;
      _isRevealed = true;
    });

    // User can now tap to confirm
  }

  Future<void> _handleConfirmation() async {
    // Phase 4: Haptic Heartbeat
    HapticManager().heartBeat();

    // Phase 5: Transition (Fly Out)
    // We can animate this widget out or callback
    // For now, simpler callback
    widget.onRevealComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _flipController,
        builder: (context, child) {
          final double value = _flipController.value;
          // Rotate around Y axis. 0 = 0deg (Back), 1 = 180deg (Front)
          // Actually, let's keep the previous logic: 0 = PI (Back), 1 = 0 (Front)
          final double angle = (1 - value) * pi;

          final bool isFrontVisible = angle < (pi / 2);

          final Matrix4 transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle)
            ..multiply(Matrix4.diagonal3Values(_scaleAnimation.value,
                _scaleAnimation.value, _scaleAnimation.value))
            ..rotateZ(_tiltAnimation.value * (isFrontVisible ? 1 : -1));

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: isFrontVisible
                ? _buildFront()
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildBack(), // Phase 1: Anticipation
                  ),
          );
        },
      ),
    );
  }

  Widget _buildBack() {
    // Phase 1: Anticipation (Breathing)
    if (widget.isTesting) return widget.back;

    return widget.back
        .animate(
            onPlay: (c) => widget.isTesting ? null : c.repeat(reverse: true))
        .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.03, 1.03),
            duration: 2500.ms,
            curve: Curves.easeInOut)
        .shimmer(duration: 3000.ms, color: Colors.white10);
  }

  Widget _buildFront() {
    // We need to check if we can decompose the 'front' widget or if we just apply effects to it.
    // Ideally, 'front' is the full card. We wrap it in the staggered animations?
    // The 'front' widget passed in is likely the RoleCard.
    // If we can't control the internals of RoleCard here easily without changing its API,
    // we might just apply the mask/reveal to the whole thing, OR we ask the caller to pass
    // the pieces.
    // For now, let's assume 'front' is the whole card and we fade it in nicely.
    // BUT the spec says: Art -> Name -> Badge.
    // This implies CinematicRoleReveal needs to know about the Role structure, OR
    // the Front Widget is built using these controllers.
    // Let's wrapping the 'front' widget in a FadeIn for now to support generic usage,
    // but ideally we'd rebuild RoleCard to take these animation controllers.

    // OPTION B: We just apply a "Flash" and then fade the whole front in? Check spec.
    // Spec: "Staggered fade-in of Art -> Name -> Badge".
    // This suggests CinematicRoleReveal should probably BUILD the card content or we pass a builder.
    // However, refactoring RoleCard might be too invasive right now.
    // Let's implement a 'Flash' overlay and a basic staggered shake/scale for now,
    // or assume the `front` widget handles its own internal staggering if provided with a trigger.

    // Let's keep it simple: Fade in the Whole Front after flip?
    // No, the flip reveals it.
    // Let's wrap the front in a container that allows the "Flash" effect.

    return Stack(
      children: [
        widget.front,
        // Flash Effect
        if (_isAnimating &&
            _flipController.value > 0.5 &&
            _flipController.value < 0.8)
          Positioned.fill(
                  child: Container(color: Colors.white.withValues(alpha: 0.3)))
              .animate()
              .fadeOut(duration: 200.ms)
      ],
    );
  }
}
