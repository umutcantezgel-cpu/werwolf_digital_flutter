import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme.dart';

class ToastData {
  ToastData(this.id, this.text, this.icon, this.color);

  final int id;
  final String text;
  final IconData icon;
  final Color color;
}

/// Hält die aktuell sichtbaren Toasts (max. 3).
class ToastController extends ChangeNotifier {
  final List<ToastData> items = [];
  int _next = 0;
  final Map<int, Timer> _timers = {};

  void show(String text, {IconData icon = Icons.info_outline_rounded, Color color = Noir.brass, int ms = 3200}) {
    // Gleiche Meldung nicht doppelt stapeln.
    if (items.isNotEmpty && items.last.text == text) return;
    final t = ToastData(_next++, text, icon, color);
    items.add(t);
    while (items.length > 3) {
      _timers.remove(items.first.id)?.cancel();
      items.removeAt(0);
    }
    _timers[t.id] = Timer(Duration(milliseconds: ms), () {
      items.removeWhere((e) => e.id == t.id);
      _timers.remove(t.id);
      notifyListeners();
    });
    notifyListeners();
  }

  @override
  void dispose() {
    for (final t in _timers.values) {
      t.cancel();
    }
    super.dispose();
  }
}

class ToastLayer extends StatelessWidget {
  const ToastLayer({super.key, required this.controller, this.top = 150, this.right = 16});

  final ToastController controller;
  final double top;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + top,
      left: 12,
      right: right,
      child: IgnorePointer(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => Column(
            children: [
              for (final t in controller.items)
                Padding(
                  key: ValueKey(t.id),
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Center(child: _Toast(t)),
                ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.4, curve: Curves.easeOutBack),
            ],
          ),
        ),
      ),
    );
  }
}

class _Toast extends StatelessWidget {
  const _Toast(this.t);

  final ToastData t;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 14, 8),
        decoration: BoxDecoration(
          color: const Color(0xEE0E101C),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: t.color.withValues(alpha: 0.55)),
          boxShadow: [
            const BoxShadow(color: Color(0x99000000), blurRadius: 12, offset: Offset(0, 4)),
            BoxShadow(color: t.color.withValues(alpha: 0.18), blurRadius: 16),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(shape: BoxShape.circle, color: t.color.withValues(alpha: 0.2)),
              child: Icon(t.icon, size: 15, color: t.color),
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(t.text, style: Noir.text(13.5, weight: FontWeight.w500, height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }
}
