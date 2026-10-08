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

  /// Alle Toasts sofort entfernen (z. B. beim Wechsel in einen Vollbild-Abschnitt).
  void clear() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
    if (items.isEmpty) return;
    items.clear();
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
  const ToastLayer({
    super.key,
    required this.controller,
    this.top = 150,
    this.bottom,
    this.left = 12,
    this.right = 16,
    this.maxVisible = 3,
  });

  final ToastController controller;

  /// Abstand unter der Statusleiste (oben verankert), wenn [bottom] `null` ist.
  final double top;

  /// Unten verankert (Abstand über dem unteren Safe-Area-Rand); hat Vorrang vor [top].
  final double? bottom;
  final double left;
  final double right;

  /// Höchstens so viele (die neuesten) Toasts zeigen – auf engen Bildschirmen weniger.
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final b = bottom;
    return Positioned(
      top: b == null ? pad.top + top : null,
      bottom: b == null ? null : pad.bottom + b,
      left: left,
      right: right,
      child: IgnorePointer(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final items = controller.items;
            final shown = items.length > maxVisible ? items.sublist(items.length - maxVisible) : items;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final t in shown)
                  Padding(
                    key: ValueKey(t.id),
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Center(child: _Toast(t)),
                  ).animate().fadeIn(duration: 200.ms).slideY(begin: b == null ? -0.4 : 0.4, curve: Curves.easeOutBack),
              ],
            );
          },
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
          color: Noir.glassStrong,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: t.color.withValues(alpha: 0.55)),
          boxShadow: [
            const BoxShadow(color: Noir.shadowStrong, blurRadius: 12, offset: Offset(0, 4)),
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
