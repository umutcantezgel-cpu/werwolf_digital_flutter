import 'package:flutter/material.dart';
import 'design_tokens.dart';

/// Custom Theme Extension to expose Werwolf-specific design tokens
/// (Role colors, specific day/night palettes that don't map to Material Scheme)
@immutable
class WerwolfThemeExtension extends ThemeExtension<WerwolfThemeExtension> {
  final Color nightDeep;
  final Color nightMid;
  final Color moonPrimary;
  final Color moonGlow;
  final Color wolfRed;
  final Color villageGreen;
  final Color roleWerwolf;
  final Color roleWerwolfAccent;
  static const roleDorfbewohner = DesignColors.roleDorfbewohner;
  static const roleDorfbewohnerAccent = DesignColors.roleDorfbewohnerAccent;
  final Color roleSeherin;
  final Color roleSeherinAccent;
  final Color roleHexe;
  final Color roleHexeAccent;

  const WerwolfThemeExtension({
    required this.nightDeep,
    required this.nightMid,
    required this.moonPrimary,
    required this.moonGlow,
    required this.wolfRed,
    required this.villageGreen,
    required this.roleWerwolf,
    required this.roleWerwolfAccent,
    required this.roleSeherin,
    required this.roleSeherinAccent,
    required this.roleHexe,
    required this.roleHexeAccent,
  });

  // Default Night Theme
  factory WerwolfThemeExtension.night() {
    return const WerwolfThemeExtension(
      nightDeep: DesignColors.nightDeep,
      nightMid: DesignColors.nightMid,
      moonPrimary: DesignColors.moonPrimary,
      moonGlow: DesignColors.moonGlow,
      wolfRed: DesignColors.wolfRed,
      villageGreen: DesignColors.villageGreen,
      roleWerwolf: DesignColors.roleWerwolf,
      roleWerwolfAccent: DesignColors.roleWerwolfAccent,
      roleSeherin: DesignColors.roleSeherin,
      roleSeherinAccent: DesignColors.roleSeherinAccent,
      roleHexe: DesignColors.roleHexe,
      roleHexeAccent: DesignColors.roleHexeAccent,
    );
  }

  // Day Theme (Can override specific values if needed, but roles usually stay same)
  factory WerwolfThemeExtension.day() {
    return const WerwolfThemeExtension(
      // For day, we might shift some ambient colors, but roles remain consistent
      nightDeep: DesignColors.dayDark, // Re-purpose for day ground
      nightMid: DesignColors.dayWarm,
      moonPrimary: DesignColors.dayBright, // Sun
      moonGlow: DesignColors.dayLighter,
      wolfRed: DesignColors.blood,
      villageGreen: DesignColors.villageGreen,
      roleWerwolf: DesignColors.roleWerwolf,
      roleWerwolfAccent: DesignColors.roleWerwolfAccent,
      roleSeherin: DesignColors.roleSeherin,
      roleSeherinAccent: DesignColors.roleSeherinAccent,
      roleHexe: DesignColors.roleHexe,
      roleHexeAccent: DesignColors.roleHexeAccent,
    );
  }

  @override
  ThemeExtension<WerwolfThemeExtension> copyWith({
    Color? nightDeep,
    Color? nightMid,
    Color? moonPrimary,
    Color? moonGlow,
    Color? wolfRed,
    Color? villageGreen,
    Color? roleWerwolf,
    Color? roleWerwolfAccent,
    Color? roleSeherin,
    Color? roleSeherinAccent,
    Color? roleHexe,
    Color? roleHexeAccent,
  }) {
    return WerwolfThemeExtension(
      nightDeep: nightDeep ?? this.nightDeep,
      nightMid: nightMid ?? this.nightMid,
      moonPrimary: moonPrimary ?? this.moonPrimary,
      moonGlow: moonGlow ?? this.moonGlow,
      wolfRed: wolfRed ?? this.wolfRed,
      villageGreen: villageGreen ?? this.villageGreen,
      roleWerwolf: roleWerwolf ?? this.roleWerwolf,
      roleWerwolfAccent: roleWerwolfAccent ?? this.roleWerwolfAccent,
      roleSeherin: roleSeherin ?? this.roleSeherin,
      roleSeherinAccent: roleSeherinAccent ?? this.roleSeherinAccent,
      roleHexe: roleHexe ?? this.roleHexe,
      roleHexeAccent: roleHexeAccent ?? this.roleHexeAccent,
    );
  }

  @override
  ThemeExtension<WerwolfThemeExtension> lerp(
      ThemeExtension<WerwolfThemeExtension>? other, double t) {
    if (other is! WerwolfThemeExtension) {
      return this;
    }
    return WerwolfThemeExtension(
      nightDeep: Color.lerp(nightDeep, other.nightDeep, t)!,
      nightMid: Color.lerp(nightMid, other.nightMid, t)!,
      moonPrimary: Color.lerp(moonPrimary, other.moonPrimary, t)!,
      moonGlow: Color.lerp(moonGlow, other.moonGlow, t)!,
      wolfRed: Color.lerp(wolfRed, other.wolfRed, t)!,
      villageGreen: Color.lerp(villageGreen, other.villageGreen, t)!,
      roleWerwolf: Color.lerp(roleWerwolf, other.roleWerwolf, t)!,
      roleWerwolfAccent:
          Color.lerp(roleWerwolfAccent, other.roleWerwolfAccent, t)!,
      roleSeherin: Color.lerp(roleSeherin, other.roleSeherin, t)!,
      roleSeherinAccent:
          Color.lerp(roleSeherinAccent, other.roleSeherinAccent, t)!,
      roleHexe: Color.lerp(roleHexe, other.roleHexe, t)!,
      roleHexeAccent: Color.lerp(roleHexeAccent, other.roleHexeAccent, t)!,
    );
  }
}

// Convenience extension
extension WerwolfThemeContext on BuildContext {
  WerwolfThemeExtension get werwolfTheme =>
      Theme.of(this).extension<WerwolfThemeExtension>()!;
}
