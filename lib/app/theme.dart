import 'package:flutter/material.dart';
import 'package:mordakte_core/mordakte_core.dart';

/// Farbpalette und Schriften des Noir-Stils.
abstract final class Noir {
  static const night = Color(0xFF0D0F1D);
  static const night2 = Color(0xFF14172A);
  static const night3 = Color(0xFF1D2138);
  static const night4 = Color(0xFF272C47);
  static const line = Color(0x33E8E0D0);

  static const paper = Color(0xFFE8E0D0);
  static const paperDark = Color(0xFFD5C8AE);
  static const paperShade = Color(0xFFBFAF90);
  static const ink = Color(0xFF2A211B);
  static const inkSoft = Color(0xFF5B4E42);

  static const blood = Color(0xFF8B0000);
  static const bloodBright = Color(0xFFC0322B);
  static const brass = Color(0xFFC9A227);
  static const brassLight = Color(0xFFE6C766);
  static const brassDim = Color(0xFF7E6A2E);

  static const smoke = Color(0xFF9EA3B8);
  static const smokeDim = Color(0xFF6A6F87);
  static const cream = Color(0xFFF3EBDD);

  static const buff = Color(0xFF6BBF6E);
  static const debuff = Color(0xFFE0554D);
  static const cork = Color(0xFF6B4A2E);
  static const corkDark = Color(0xFF4A321F);

  static const display = 'SpecialElite';
  static const body = 'Inter';

  static TextStyle title(double size, {Color color = cream, double spacing = 1.5}) => TextStyle(
        fontFamily: display,
        fontSize: size,
        color: color,
        letterSpacing: spacing,
        height: 1.15,
      );

  static TextStyle label(double size, {Color color = smoke, FontWeight weight = FontWeight.w600, double spacing = 1.2}) =>
      TextStyle(fontFamily: body, fontSize: size, color: color, fontWeight: weight, letterSpacing: spacing);

  static TextStyle text(double size, {Color color = cream, FontWeight weight = FontWeight.w400, double height = 1.4}) =>
      TextStyle(fontFamily: body, fontSize: size, color: color, fontWeight: weight, height: height);

  static TextStyle typed(double size, {Color color = ink, double height = 1.45}) =>
      TextStyle(fontFamily: display, fontSize: size, color: color, height: height, letterSpacing: 0.2);
}

/// Hex `#rrggbb` → Farbe.
Color hexColor(String hex, {Color fallback = Noir.smoke}) {
  final h = hex.replaceFirst('#', '');
  final v = int.tryParse(h.length == 6 ? 'ff$h' : h, radix: 16);
  return v == null ? fallback : Color(v);
}

/// Akzentfarbe eines Szenarios (Messing, wenn unbekannt).
Color accentOf(ScenarioDef? s) => s == null ? Noir.brass : Color(s.theme.color('accent'));

Color coatColor(int index) => hexColor(detectiveCoats[index.clamp(0, detectiveCoats.length - 1)]);

ThemeData buildNoirTheme() {
  const scheme = ColorScheme.dark(
    primary: Noir.brass,
    onPrimary: Noir.night,
    secondary: Noir.bloodBright,
    onSecondary: Noir.cream,
    surface: Noir.night2,
    onSurface: Noir.cream,
    error: Noir.debuff,
  );
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    fontFamily: Noir.body,
    scaffoldBackgroundColor: Noir.night,
    canvasColor: Noir.night,
    splashFactory: InkSparkle.splashFactory,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: Noir.body, bodyColor: Noir.cream, displayColor: Noir.cream),
    dialogTheme: const DialogThemeData(
      backgroundColor: Noir.night2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Noir.night3,
      contentTextStyle: TextStyle(fontFamily: Noir.body, color: Noir.cream),
      behavior: SnackBarBehavior.floating,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Noir.night3,
      hintStyle: Noir.text(15, color: Noir.smokeDim),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Noir.line)),
      enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Noir.line)),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Noir.brass)),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: Noir.night3, borderRadius: BorderRadius.circular(4), border: Border.all(color: Noir.line)),
      textStyle: Noir.text(13),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
  );
}
