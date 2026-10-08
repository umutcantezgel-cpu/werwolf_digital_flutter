import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Text mit Schreibmaschinen-Effekt. Antippen zeigt sofort alles.
class TypewriterText extends StatefulWidget {
  const TypewriterText(
    this.text, {
    super.key,
    required this.style,
    this.charMs = 28,
    this.delay = Duration.zero,
    this.textAlign = TextAlign.start,
    this.onDone,
    this.cursor = true,
  });

  final String text;
  final TextStyle style;
  final int charMs;
  final Duration delay;
  final TextAlign textAlign;
  final VoidCallback? onDone;
  final bool cursor;

  @override
  State<TypewriterText> createState() => TypewriterTextState();
}

class TypewriterTextState extends State<TypewriterText> {
  int _shown = 0;
  Timer? _timer;
  Timer? _start;

  bool get done => _shown >= widget.text.length;

  @override
  void initState() {
    super.initState();
    _begin();
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _timer?.cancel();
      _start?.cancel();
      _shown = 0;
      _begin();
    }
  }

  void _begin() {
    _start = Timer(widget.delay, () {
      _timer = Timer.periodic(Duration(milliseconds: widget.charMs), (t) {
        if (!mounted) return;
        setState(() => _shown++);
        if (done) {
          t.cancel();
          widget.onDone?.call();
        }
      });
    });
  }

  /// Sofort alles anzeigen.
  void complete() {
    if (done) return;
    _timer?.cancel();
    _start?.cancel();
    setState(() => _shown = widget.text.length);
    widget.onDone?.call();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _start?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.text.substring(0, _shown.clamp(0, widget.text.length));
    final rest = widget.text.substring(visible.length);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: complete,
      child: Text.rich(
        TextSpan(
          style: widget.style,
          children: [
            TextSpan(text: visible),
            if (widget.cursor && !done)
              TextSpan(
                text: '▌',
                style: TextStyle(color: widget.style.color?.withValues(alpha: 0.7)),
              ),
            // Unsichtbarer Rest hält das Layout stabil.
            TextSpan(
              text: rest,
              style: const TextStyle(color: Noir.clear),
            ),
          ],
        ),
        textAlign: widget.textAlign,
      ),
    );
  }
}
