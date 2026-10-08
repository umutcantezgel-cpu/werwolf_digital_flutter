import 'dart:ui';

import 'package:mordakte_core/mordakte_core.dart';

/// Farben eines Szenarios (aus `theme.palette`) plus abgeleitete Materialien.
class ScenePalette {
  final Color background;
  final Color floor;
  final Color floorAlt;
  final Color wall;
  final Color wallTop;
  final Color trim;
  final Color accent;
  final Color light;
  final Color danger;
  final Color text;
  final Color fog;

  /// Holz für Möbel.
  late final Color wood = mix(const Color(0xFF5B3A24), floorAlt, 0.25);
  late final Color darkWood = shade(wood, -0.35);
  late final Color fabric = mix(const Color(0xFF6E2330), danger, 0.35);
  late final Color metal = const Color(0xFF8C8F96);
  late final Color porcelain = const Color(0xFFE9E6DD);
  late final Color glass = mix(const Color(0xFF2B3E55), fog, 0.35);

  ScenePalette({
    required this.background,
    required this.floor,
    required this.floorAlt,
    required this.wall,
    required this.wallTop,
    required this.trim,
    required this.accent,
    required this.light,
    required this.danger,
    required this.text,
    required this.fog,
  });

  factory ScenePalette.fromTheme(ThemeDef? t) {
    Color c(String key, int fallback) {
      final s = t?.palette[key];
      return parseHex(s) ?? Color(fallback);
    }

    return ScenePalette(
      background: c('background', 0xFF0B0910),
      floor: c('floor', 0xFF4A2F25),
      floorAlt: c('floorAlt', 0xFF3B241C),
      wall: c('wall', 0xFF2A1D24),
      wallTop: c('wallTop', 0xFF5A3A3F),
      trim: c('trim', 0xFFC9A227),
      accent: c('accent', 0xFFC9A227),
      light: c('light', 0xFFFFCF7A),
      danger: c('danger', 0xFFB3122E),
      text: c('text', 0xFFF3E9DC),
      fog: c('fog', 0xFF1A1420),
    );
  }

  static final ScenePalette fallback = ScenePalette.fromTheme(null);
}

/// `#rrggbb` / `#aarrggbb` → Farbe, sonst `null`.
Color? parseHex(String? s) {
  if (s == null) return null;
  var h = s.trim();
  if (h.startsWith('#')) h = h.substring(1);
  if (h.length == 6) h = 'ff$h';
  if (h.length != 8) return null;
  final v = int.tryParse(h, radix: 16);
  return v == null ? null : Color(v);
}

Color mix(Color a, Color b, double t) => Color.lerp(a, b, t)!;

/// [f] < 0 abdunkeln, > 0 aufhellen (−1..1).
Color shade(Color c, double f) {
  if (f >= 0) return Color.lerp(c, const Color(0xFFFFFFFF), f)!;
  return Color.lerp(c, const Color(0xFF000000), -f)!;
}

Color withAlpha(Color c, double a) => c.withValues(alpha: (c.a * a).clamp(0.0, 1.0));

/// Relative Helligkeit 0..1 (grob).
double luminance(Color c) => 0.299 * c.r + 0.587 * c.g + 0.114 * c.b;
