import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';
import '../widgets/buttons.dart';
import '../widgets/typewriter.dart';
import 'game_context.dart';

/// Kurz eingeblendeter Nachttext zu Beginn der Nacht.
class NightBanner extends StatelessWidget {
  const NightBanner({super.key, required this.title, required this.text, required this.hint});

  final String title;
  final String text;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: const Alignment(0, -0.18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Noir.nightBandClear, Noir.nightBand, Noir.nightBand, Noir.nightBandClear],
              stops: [0, 0.18, 0.82, 1],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.nightlight_round, color: Noir.moon, size: 26),
              const SizedBox(height: 8),
              Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: Noir.title(22, color: Noir.moonLight, spacing: 3),
              ),
              const SizedBox(height: 10),
              if (text.isNotEmpty)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: TypewriterText(
                    text,
                    textAlign: TextAlign.center,
                    style: Noir.typed(15.5, color: Noir.paper),
                    charMs: 26,
                    cursor: false,
                  ),
                ),
              const SizedBox(height: 10),
              Text(hint, style: Noir.label(11.5, color: Noir.moon, spacing: 1.2)),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 600.ms),
    );
  }
}

/// Dunkle Ränder bei Nacht.
class NightVignette extends StatelessWidget {
  const NightVignette({super.key});

  @override
  Widget build(BuildContext context) => const IgnorePointer(
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 0.95,
          colors: [Noir.clear, Noir.nightEdge, Noir.nightEdgeDeep],
          stops: [0.5, 0.78, 1],
        ),
      ),
    ),
  );
}

/// Pulsierende rote Ränder, solange der Schatten nah ist (Herzschlag).
class HeartbeatVignette extends StatefulWidget {
  const HeartbeatVignette({super.key, required this.trigger});

  /// Zeitpunkt (ms) des letzten `shadowNear`.
  final ValueNotifier<int> trigger;

  @override
  State<HeartbeatVignette> createState() => _HeartbeatVignetteState();
}

class _HeartbeatVignetteState extends State<HeartbeatVignette> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 850));

  @override
  void initState() {
    super.initState();
    widget.trigger.addListener(_kick);
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        final age = DateTime.now().millisecondsSinceEpoch - widget.trigger.value;
        if (age < 2600) _c.forward(from: 0);
      }
    });
  }

  void _kick() {
    if (!_c.isAnimating) _c.forward(from: 0);
  }

  @override
  void dispose() {
    widget.trigger.removeListener(_kick);
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          // Doppelschlag: lub-dub
          if (!_c.isAnimating) return const SizedBox.expand();
          final t = _c.value;
          final beat = math.max(_pulse(t, 0.08), _pulse(t, 0.3) * 0.7);
          if (beat <= 0.01) return const SizedBox.expand();
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.9,
                colors: [
                  Noir.clear,
                  Noir.blood.withValues(alpha: 0.55 * beat),
                ],
                stops: const [0.55, 1],
              ),
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }

  double _pulse(double t, double at) {
    final d = (t - at).abs();
    return d > 0.14 ? 0 : 1 - d / 0.14;
  }
}

/// Roter Blitz bei einem Angriff.
class FlashOverlay extends StatelessWidget {
  const FlashOverlay({super.key, required this.trigger});

  final ValueNotifier<int> trigger;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ValueListenableBuilder<int>(
        valueListenable: trigger,
        builder: (context, v, _) {
          if (v == 0) return const SizedBox.expand();
          return TweenAnimationBuilder<double>(
            key: ValueKey(v),
            tween: Tween(begin: 1, end: 0),
            duration: const Duration(milliseconds: 700),
            builder: (context, a, _) => ColoredBox(
              color: Noir.bloodBright.withValues(alpha: 0.45 * a),
              child: const SizedBox.expand(),
            ),
          );
        },
      ),
    );
  }
}

/// Niedergeschlagen: rote Ränder, Restzeit, Hilferuf.
class DownedOverlay extends StatelessWidget {
  const DownedOverlay({super.key, required this.g, required this.leftMs});

  final GameCtx g;
  final int leftMs;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final frac = (leftMs / Tuning.downedMs).clamp(0.0, 1.0);
    return Stack(
      children: [
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.85,
                  colors: [Noir.shadeFaint, Noir.bloodVeil, Noir.bloodDeep],
                  stops: [0.3, 0.75, 1],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 0.15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 112,
                height: 112,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: frac,
                      strokeWidth: 6,
                      color: Noir.bloodBright,
                      backgroundColor: Noir.shade,
                    ),
                    Center(child: Text(l.downed_seconds((leftMs / 1000).ceil()), style: Noir.title(30))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(l.downed_title.toUpperCase(), style: Noir.title(26, color: Noir.cream, spacing: 3)),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Text(
                  l.downed_text,
                  textAlign: TextAlign.center,
                  style: Noir.text(13.5, color: Noir.paper),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 220,
                child: NoirButton(
                  label: l.downed_help,
                  icon: Icons.sos_rounded,
                  style: NoirButtonStyle.danger,
                  onPressed: () => g.send(const Signal(kind: 'quick', value: 'help')),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms),
      ],
    );
  }
}

/// Hinweis-Banner für Geister.
class GhostBanner extends StatelessWidget {
  const GhostBanner({super.key, required this.g});

  final GameCtx g;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final pad = MediaQuery.paddingOf(context);
    return Positioned(
      left: 16,
      right: 16,
      bottom: pad.bottom + 196,
      child: IgnorePointer(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              decoration: BoxDecoration(
                color: Noir.ghostGlass,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Noir.ghostLine),
                boxShadow: const [BoxShadow(color: Noir.ghostGlow, blurRadius: 24)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.blur_circular_rounded, color: Noir.ghost, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l.ghost_title, style: Noir.title(17, color: Noir.ghostLight)),
                        const SizedBox(height: 3),
                        Text(l.ghost_text, style: Noir.text(12, color: Noir.ghostDim, height: 1.3)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(begin: 0.75, end: 1, duration: 1800.ms),
    );
  }
}

/// Entsättigung für den Geist-Modus.
const ghostMatrix = <double>[
  0.30, 0.55, 0.15, 0, 8, //
  0.30, 0.55, 0.15, 0, 14, //
  0.32, 0.58, 0.18, 0, 30, //
  0, 0, 0, 1, 0,
];
