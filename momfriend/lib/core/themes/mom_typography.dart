import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mom_theme_colors.dart';

/// Typografia przyjazna dla matek
/// Wykorzystuje font Poppins z dobrym spacingiem dla długich tekstów
class MomTypography {
  // === Headlines ===
  static TextStyle get headline1 => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: MomThemeColors.textPrimary,
  );

  static TextStyle get headline2 => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
    color: MomThemeColors.textPrimary,
  );

  static TextStyle get headline3 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: MomThemeColors.textPrimary,
  );

  static TextStyle get headline4 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: MomThemeColors.textPrimary,
  );

  static TextStyle get headline5 => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: MomThemeColors.textPrimary,
  );

  static TextStyle get headline6 => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: MomThemeColors.textPrimary,
  );

  // === Body Text ===
  static TextStyle get body1 => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6, // Lepsze spacing dla długich tekstów
    letterSpacing: 0.15,
    color: MomThemeColors.textPrimary,
  );

  static TextStyle get body2 => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
    color: MomThemeColors.textPrimary,
  );

  // === Subtitles ===
  static TextStyle get subtitle1 => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.15,
    color: MomThemeColors.textPrimary,
  );

  static TextStyle get subtitle2 => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
    color: MomThemeColors.textSecondary,
  );

  // === Caption & Small Text ===
  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.4,
    color: MomThemeColors.textSecondary,
  );

  static TextStyle get overline => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 1.5,
    color: MomThemeColors.textSecondary,
  );

  // === Specialized Styles ===
  
  /// Tekst dla przycisków
  static TextStyle get buttonText => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
    color: MomThemeColors.textOnColor,
  );

  /// Tekst dla małych przycisków
  static TextStyle get buttonTextSmall => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
    color: MomThemeColors.textOnColor,
  );

  /// Logo text - używa Pacifico dla ciepłego charakteru
  static TextStyle get logoText => GoogleFonts.pacifico(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: MomThemeColors.primary,
  );

  /// Tekst na kartach profili
  static TextStyle get profileName => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: MomThemeColors.textOnColor,
    shadows: [
      Shadow(
        color: Colors.black.withOpacity(0.3),
        offset: const Offset(0, 1),
        blurRadius: 3,
      ),
    ],
  );

  /// Informacje o dzieciach na profilach
  static TextStyle get profileDetails => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: MomThemeColors.textOnColor,
    shadows: [
      Shadow(
        color: Colors.black.withOpacity(0.3),
        offset: const Offset(0, 1),
        blurRadius: 3,
      ),
    ],
  );

  /// Tekst dla match dialog
  static TextStyle get matchTitle => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: MomThemeColors.primary,
  );

  /// Input field text
  static TextStyle get inputText => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: MomThemeColors.textPrimary,
  );

  /// Label text dla form fields
  static TextStyle get labelText => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: MomThemeColors.textSecondary,
  );

  /// Error text
  static TextStyle get errorText => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: MomThemeColors.error,
  );

  /// Helper text
  static TextStyle get helperText => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: MomThemeColors.textSecondary,
  );

  // === Chat Styles ===
  static TextStyle get chatMessage => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: MomThemeColors.textPrimary,
  );

  static TextStyle get chatTimestamp => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: MomThemeColors.textSecondary,
  );

  // === Tab Bar ===
  static TextStyle get tabLabel => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // === Navigation ===
  static TextStyle get navLabel => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );
} 