import 'package:flutter/material.dart';

/// Werwolf Digital - Weltklasse Design Tokens
///
/// Contains all primitive values for Colors, Typography, Spacing, and Animation.
/// These should typically be accessed via `WerwolfTheme` extension, not directly.

class DesignColors {
  // Prevent instantiation
  DesignColors._();

  // ===========================================================================
  // NIGHT PALETTE (Dominant 70%)
  // ===========================================================================
  static const Color nightBlack = Color(0xFF0D0F1D); // Absolute darkness base
  static const Color nightDeep = Color(0xFF151B2C); // Dark blue, cave-like
  static const Color nightMid = Color(0xFF1E2844); // Slightly lighter night
  static const Color nightSubtle = Color(0xFF2A3555); // Night UI backgrounds

  static const Color moonPrimary = Color(0xFFE8E0D0); // Warm cream - moon
  static const Color moonGlow = Color(0xFFD0C8B8); // Moon reflection
  static const Color moonShadow = Color(0xFF3D4A66); // Moon shadow

  static const Color wolfRed =
      Color(0xFF8B0000); // Werewolf emphasis - dark red
  static const Color wolfGlow =
      Color(0xFFD32F2F); // Threat indicator - bright red
  static const Color villageGreen =
      Color(0xFF1B5E20); // Village/safe indicator - dark green

  static const Color textNightPrimary =
      Color(0xFFF5F5F5); // Light text for night
  static const Color textNightSecondary =
      Color(0xFFB0B0B0); // Dim text for night
  static const Color textNightMuted = Color(0xFF656565); // Very dim

  // ===========================================================================
  // DAY PALETTE (Dominant 25%)
  // ===========================================================================
  static const Color dayDark = Color(0xFF4A3C1A); // Dark earth/soil tone
  static const Color dayWarm = Color(0xFFFF9800); // Warm orange, sunrise
  static const Color dayBright = Color(0xFFFFD700); // Bright gold, high sun
  static const Color dayLighter = Color(0xFFFFEB99); // Light day, villages
  static const Color dayOrange = Color(0xFFFF9800); // Action/Voting color

  static const Color textDayPrimary = Color(0xFF1A1A1A); // Near-black for day
  static const Color textDaySecondary = Color(0xFF4A4A4A); // Dark gray for day
  static const Color textDayMuted = Color(0xFFA0A0A0); // Lighter for day

  static const Color blood = Color(0xFF8B0000); // Death indicator
  static const Color tension = Color(0xFFD32F2F); // Voting tension

  // ===========================================================================
  // ROLE COLORS (Psychology)
  // ===========================================================================
  static const Color roleWerwolf = Color(0xFF8B0000);
  static const Color roleWerwolfAccent = Color(0xFFD32F2F);

  static const Color roleDorfbewohner = Color(0xFF1B5E20);
  static const Color roleDorfbewohnerAccent = Color(0xFF4CAF50);

  static const Color roleSeherin = Color(0xFF7B68EE);
  static const Color roleSeherinAccent = Color(0xFF9F7AEA);

  static const Color roleHexe = Color(0xFF6F4E37);
  static const Color roleHexeAccent = Color(0xFFA0714F);

  static const Color roleJager = Color(0xFF8B4513);
  static const Color roleJagerAccent = Color(0xFFD2691E);

  static const Color roleAmor = Color(0xFFE91E63);
  static const Color roleAmorAccent = Color(0xFFFF6BB6);

  // Additional roles can be added here
}

class DesignTypography {
  DesignTypography._();

  static const String fontDisplay = 'SpaceGrotesk'; // Check pubspec/assets
  static const String fontBody = 'Inter'; // Check pubspec/assets

  // Sizes
  static const double textXs = 12.0;
  static const double textSm = 14.0;
  static const double textBase = 16.0;
  static const double textLg = 18.0;
  static const double textXl = 20.0;
  static const double text2xl = 24.0;
  static const double text3xl = 30.0;
  static const double text4xl = 36.0;
  static const double text5xl = 48.0;
  static const double text6xl = 60.0;

  // Letter Spacing (Night specific mainly)
  static const double spacingTight = -0.5; // -0.02em approx
  static const double spacingNormal = 0.0;
  static const double spacingWide = 1.0; // 0.05em approx
}

class DesignSpacings {
  DesignSpacings._();

  static const double s0 = 0.0;
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
  static const double s64 = 64.0;
}

class DesignDurations {
  DesignDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration transitionPhase =
      Duration(seconds: 3); // Sunrise/Sunset
  static const Duration cardFlip = Duration(milliseconds: 1200);
}

class DesignCurves {
  DesignCurves._();

  // Custom Bounce: cubic-bezier(0.34, 1.56, 0.64, 1);
  static const Curve bounce = Cubic(0.34, 1.56, 0.64, 1.0);

  // Standard Ease: cubic-bezier(0.16, 1, 0.3, 1);
  static const Curve standard = Cubic(0.16, 1.0, 0.3, 1.0);
}
