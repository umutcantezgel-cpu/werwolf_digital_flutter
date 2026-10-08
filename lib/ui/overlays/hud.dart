import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../icons.dart';
import '../widgets/buttons.dart';
import 'game_context.dart';
import 'minimap.dart';

/// HUD während Ermittlung, Beratung und Nacht.
class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.g,
    required this.notebookBadge,
    required this.onNotebook,
    required this.onSignals,
    required this.onMenu,
    required this.onEffect,
    required this.mapOpen,
    required this.onMap,
    required this.onMapExpand,
    this.showBottom = true,
  });

  final GameCtx g;
  final int notebookBadge;
  final VoidCallback onNotebook;
  final VoidCallback onSignals;
  final VoidCallback onMenu;
  final ValueChanged<String> onEffect;
  final bool mapOpen;
  final VoidCallback onMap;
  final VoidCallback onMapExpand;
  final bool showBottom;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final l = g.l;
    // Querformat/geringe Höhe: Knöpfe als Zeile, damit sie den Fähigkeits-Knopf nicht berühren.
    final compact = MediaQuery.sizeOf(context).height < 560;
    return Stack(
      children: [
        // Oben: dunkler Verlauf für Lesbarkeit
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: pad.top + 120,
          child: const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Noir.shadowStrong, Noir.clear],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: pad.top + 10,
          left: 10,
          child: ValueListenableBuilder<WorldSnapshot?>(
            valueListenable: g.session.world,
            builder: (context, w, _) => _StatusCard(me: w?.detective(g.me), onEffect: onEffect),
          ),
        ),
        Positioned(
          top: pad.top + 10,
          left: 0,
          right: 0,
          child: Center(
            child: ValueListenableBuilder<WorldSnapshot?>(
              valueListenable: g.session.world,
              builder: (context, w, _) => _PhaseTimer(world: w, phase: g.cv.phase, chapter: g.cv.chapter, l: l),
            ),
          ),
        ),
        Positioned(
          top: pad.top + 10,
          right: 10,
          child: Flex(
            direction: compact ? Axis.horizontal : Axis.vertical,
            children: [
              RoundIconButton(icon: Icons.menu_rounded, onPressed: onMenu, size: 40, tooltip: l.hud_menu),
              const SizedBox(width: 10, height: 10),
              RoundIconButton(
                icon: Icons.menu_book_rounded,
                onPressed: onNotebook,
                badge: notebookBadge,
                tooltip: l.hud_notebook,
                accent: g.accent,
              ),
              const SizedBox(width: 10, height: 10),
              RoundIconButton(
                icon: Icons.forum_rounded,
                onPressed: onSignals,
                tooltip: l.hud_signals,
                accent: g.accent,
              ),
              const SizedBox(width: 10, height: 10),
              RoundIconButton(
                icon: Icons.map_rounded,
                onPressed: onMap,
                active: mapOpen,
                tooltip: l.hud_map,
                accent: g.accent,
              ),
            ],
          ),
        ),
        if (mapOpen && g.scenario != null)
          Positioned(
            top: pad.top + (compact ? 64 : 112),
            right: compact ? 10 : 62,
            child: GestureDetector(
              onTap: onMapExpand,
              child: MiniMap(g: g, width: compact ? 130 : 150),
            ),
          ),
        if (showBottom) ...[
          Positioned(
            right: 36,
            bottom: 128 + pad.bottom,
            child: AbilityButton(g: g),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 18 + pad.bottom,
            child: Center(child: InventoryBar(g: g)),
          ),
        ],
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.me, required this.onEffect});

  final DetectiveView? me;
  final ValueChanged<String> onEffect;

  @override
  Widget build(BuildContext context) {
    final d = me;
    final l = L.of(context);
    final hp = d?.hp ?? 0;
    final maxHp = d?.maxHp ?? 3;
    final nerves = (d?.nerves ?? 100).clamp(0, 100);
    final nerveColor = Color.lerp(Noir.debuff, Noir.lab, nerves / 100)!;
    return Container(
      width: 136,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
      decoration: BoxDecoration(
        color: Noir.glass,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Noir.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              for (var i = 0; i < maxHp; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Icon(
                    i < hp ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 19,
                    color: i < hp ? Noir.bloodBright : Noir.lineStrong,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.psychology_rounded, size: 13, color: nerveColor),
              const SizedBox(width: 5),
              Expanded(
                child: Tooltip(
                  message: l.hud_nerves,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: SizedBox(
                      height: 6,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const ColoredBox(color: Noir.line),
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: nerves / 100,
                            child: ColoredBox(color: nerveColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (d != null && d.effects.isNotEmpty) ...[
            const SizedBox(height: 7),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [for (final e in d.effects) _EffectIcon(id: e, onTap: () => onEffect(e))],
            ),
          ],
        ],
      ),
    );
  }
}

class _EffectIcon extends StatelessWidget {
  const _EffectIcon({required this.id, required this.onTap});

  final String id;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final buff = effectCatalog[id]?.buff ?? true;
    final c = buff ? Noir.buff : Noir.debuff;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: c.withValues(alpha: 0.18),
          border: Border.all(color: c, width: 1.3),
        ),
        child: Icon(GameIcons.effect(id), size: 13, color: c),
      ),
    );
  }
}

/// Phase, Kapitel und Restzeit. Unter 30 s pulsiert der Timer rot.
class _PhaseTimer extends StatefulWidget {
  const _PhaseTimer({required this.world, required this.phase, required this.chapter, required this.l});

  final WorldSnapshot? world;
  final Phase phase;
  final int chapter;
  final L l;

  @override
  State<_PhaseTimer> createState() => _PhaseTimerState();
}

class _PhaseTimerState extends State<_PhaseTimer> {
  int _lastSecond = -1;

  @override
  void didUpdateWidget(covariant _PhaseTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final rem = widget.world?.phaseRemainingMs ?? 0;
    final sec = (rem / 1000).ceil();
    if (sec != _lastSecond) {
      if (sec <= 5 && sec > 0 && _lastSecond != -1) HapticFeedback.selectionClick();
      _lastSecond = sec;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.world;
    final rem = w?.phaseRemainingMs ?? 0;
    final tot = math.max(1, w?.phaseTotalMs ?? 1);
    final urgent = rem > 0 && rem <= 30000;
    final night = widget.phase == Phase.night;
    final base = night ? Noir.moon : Noir.brass;
    final color = urgent ? Noir.bloodBright : base;
    final frac = (rem / tot).clamp(0.0, 1.0);
    final sec = (rem / 1000).ceil();
    final pulse = urgent && sec <= 10 ? 1.0 + 0.08 * ((rem % 1000) / 1000) : 1.0;
    return Container(
      width: 112,
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 7),
      decoration: BoxDecoration(
        color: Noir.glass,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: urgent ? 0.9 : 0.4)),
        boxShadow: urgent ? [BoxShadow(color: Noir.bloodBright.withValues(alpha: 0.35), blurRadius: 14)] : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.l.phaseName(widget.phase).toUpperCase(),
            style: Noir.label(9.5, color: color, spacing: 1.8, weight: FontWeight.w700),
          ),
          Transform.scale(
            scale: pulse,
            child: Text(
              formatClock(rem),
              style: Noir.title(25, color: urgent ? Noir.bloodBright : Noir.cream, spacing: 1),
            ),
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: Noir.lineSoft),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: frac,
                    child: ColoredBox(color: color),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(widget.l.hud_chapter(widget.chapter), style: Noir.label(9.5, color: Noir.smoke, spacing: 1)),
        ],
      ),
    );
  }
}

/// Fähigkeits-Knopf (64 px) mit Cooldown-Ring und Ladungen.
class AbilityButton extends StatefulWidget {
  const AbilityButton({super.key, required this.g});

  final GameCtx g;

  @override
  State<AbilityButton> createState() => _AbilityButtonState();
}

class _AbilityButtonState extends State<AbilityButton> {
  int _cdAt = 0;
  int _cdMs = 0;
  int _version = -1;

  void _sync() {
    final cv = widget.g.cv;
    if (cv.version != _version) {
      _version = cv.version;
      _cdMs = cv.abilityCooldownMs;
      _cdAt = DateTime.now().millisecondsSinceEpoch;
    }
  }

  @override
  Widget build(BuildContext context) {
    _sync();
    final g = widget.g;
    final cls = detectiveClasses[g.myClass];
    final ability = cls?.ability ?? 'scan';
    return ValueListenableBuilder<WorldSnapshot?>(
      valueListenable: g.session.world,
      builder: (context, w, _) {
        final elapsed = DateTime.now().millisecondsSinceEpoch - _cdAt;
        final remaining = math.max(0, _cdMs - elapsed);
        final total = math.max(1, cls?.abilityCooldownMs ?? 1);
        final charges = g.cv.abilityCharges;
        final limited = (cls?.chargesPerNight ?? 0) > 0;
        final noCharges = limited && charges <= 0;
        final alive = w?.detective(g.me)?.life != LifeState.downed;
        final ready = remaining == 0 && !noCharges && alive;
        return Tooltip(
          message: '${g.l.abilityName(ability)} – ${g.l.classAbility(g.myClass)}',
          child: GestureDetector(
            onTap: ready
                ? () {
                    HapticFeedback.mediumImpact();
                    g.send(const UseAbility());
                  }
                : () => HapticFeedback.lightImpact(),
            child: SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: const Size.square(64),
                    painter: _CooldownPainter(fraction: remaining / total, accent: g.accent, ready: ready),
                  ),
                  Center(
                    child: remaining > 0
                        ? Text('${(remaining / 1000).ceil()}', style: Noir.title(20, color: Noir.cream))
                        : Icon(GameIcons.ability(ability), size: 28, color: ready ? Noir.night : Noir.smokeDim),
                  ),
                  if (limited)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: noCharges ? Noir.night3 : Noir.bloodBright,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: Noir.night, width: 1.5),
                        ),
                        child: Text('$charges×', style: Noir.label(10, color: Colors.white, spacing: 0)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CooldownPainter extends CustomPainter {
  _CooldownPainter({required this.fraction, required this.accent, required this.ready});

  final double fraction;
  final Color accent;
  final bool ready;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    canvas.drawCircle(c, r + 2, Paint()..color = Noir.shadow);
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          colors: ready
              ? [Color.lerp(accent, Colors.white, 0.35)!, accent, Color.lerp(accent, Colors.black, 0.4)!]
              : [Noir.night4, Noir.night2, Noir.night1],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
    canvas.drawCircle(
      c,
      r - 1,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = ready ? Color.lerp(accent, Colors.white, 0.5)! : Noir.lineStrong,
    );
    if (fraction > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r - 4),
        -math.pi / 2,
        -2 * math.pi * fraction,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..color = accent,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CooldownPainter old) =>
      old.fraction != fraction || old.ready != ready || old.accent != accent;
}

/// Inventar-Slots unten in der Mitte.
class InventoryBar extends StatelessWidget {
  const InventoryBar({super.key, required this.g});

  final GameCtx g;

  @override
  Widget build(BuildContext context) {
    final inv = g.cv.inventory;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < Tuning.maxInventory; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _Slot(type: i < inv.length ? inv[i] : null, onUse: () => g.send(UseItem(i)), accent: g.accent),
          ),
      ],
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({required this.type, required this.onUse, required this.accent});

  final String? type;
  final VoidCallback onUse;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final t = type;
    final body = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: t == null ? Noir.glassFaint : Noir.glassStrong,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: t == null ? Noir.line : accent.withValues(alpha: 0.8), width: t == null ? 1 : 1.5),
        boxShadow: t == null ? null : [BoxShadow(color: accent.withValues(alpha: 0.2), blurRadius: 8)],
      ),
      child: t == null
          ? const Icon(Icons.add_rounded, size: 16, color: Noir.line)
          : Icon(GameIcons.item(t), size: 24, color: Noir.cream),
    );
    if (t == null) return body;
    return Tooltip(
      message: '${l.itemName(t)} – ${l.itemDesc(t)}',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          onUse();
        },
        child: body,
      ),
    );
  }
}
