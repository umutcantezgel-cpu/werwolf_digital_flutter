import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';
import 'custom_theme_extension.dart';

class AppTheme {
  // --- DAY THEME ---
  static final ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    baseColor: DesignColors.dayWarm,
    surfaceColor: DesignColors.dayLighter,
    backgroundColor: DesignColors.dayDark,
    extension: WerwolfThemeExtension.day(),
  );

  // --- NIGHT THEME ---
  static final ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    baseColor: DesignColors.nightMid,
    surfaceColor: DesignColors.nightSubtle,
    backgroundColor: DesignColors.nightBlack,
    extension: WerwolfThemeExtension.night(),
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color baseColor,
    required Color surfaceColor,
    required Color backgroundColor,
    required WerwolfThemeExtension extension,
  }) {
    final isDark = brightness == Brightness.dark;
    final textColor =
        isDark ? DesignColors.textNightPrimary : DesignColors.textDayPrimary;
    final textSecondary = isDark
        ? DesignColors.textNightSecondary
        : DesignColors.textDaySecondary;

    return ThemeData(
      brightness: brightness,
      primaryColor: baseColor,
      scaffoldBackgroundColor: backgroundColor,
      extensions: [extension],

      // Text Theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: DesignTypography.text6xl,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: isDark
              ? DesignTypography.spacingTight
              : DesignTypography.spacingNormal,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: DesignTypography.text5xl,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: DesignTypography.text4xl,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: DesignTypography.text3xl,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: DesignTypography.text2xl,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: DesignTypography.textLg,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.5, // Clarity for reading
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: DesignTypography.textBase,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: DesignTypography.textSm,
          fontWeight: FontWeight.w500,
          color: textColor, // Button text
          letterSpacing: 0.5,
        ),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: DesignTypography.text2xl,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDark ? DesignColors.moonPrimary : DesignColors.dayDark,
          foregroundColor:
              isDark ? DesignColors.nightBlack : DesignColors.dayLighter,
          elevation: isDark ? 8 : 4,
          padding: const EdgeInsets.symmetric(
              horizontal: DesignSpacings.s24, vertical: DesignSpacings.s12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: DesignTypography.textBase,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: surfaceColor.withValues(alpha: isDark ? 0.8 : 0.95),
        elevation: isDark ? 12 : 4,
        shadowColor: isDark
            ? Colors.black.withValues(alpha: 0.5)
            : Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),

      // Color Scheme
      colorScheme: isDark
          ? const ColorScheme.dark(
              primary: DesignColors.moonPrimary,
              secondary: DesignColors.wolfRed,
              surface: DesignColors.nightSubtle,
              error: DesignColors.wolfRed,
            )
          : const ColorScheme.light(
              primary: DesignColors.dayWarm,
              secondary: DesignColors.villageGreen,
              surface: DesignColors.dayLighter,
              error: DesignColors.blood,
            ),
    );
  }
}
