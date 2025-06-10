import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mom_theme_colors.dart';
import 'mom_typography.dart';

/// Główny temat aplikacji MomFriend
/// Zoptymalizowany dla matek z ciepłymi kolorami i przyjazną typografią
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // === Podstawowa konfiguracja ===
      useMaterial3: true,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // === Schemat kolorów ===
      colorScheme: ColorScheme.fromSeed(
        seedColor: MomThemeColors.primary,
        brightness: Brightness.light,
        primary: MomThemeColors.primary,
        secondary: MomThemeColors.secondary,
        tertiary: MomThemeColors.accent,
        surface: MomThemeColors.surface,
        background: MomThemeColors.background,
        error: MomThemeColors.error,
        onPrimary: MomThemeColors.textOnColor,
        onSecondary: MomThemeColors.textOnColor,
        onSurface: MomThemeColors.textPrimary,
        onBackground: MomThemeColors.textPrimary,
        onError: MomThemeColors.textOnColor,
      ),

      // === Scaffold ===
      scaffoldBackgroundColor: MomThemeColors.background,
      
      // === AppBar ===
      appBarTheme: AppBarTheme(
        backgroundColor: MomThemeColors.background,
        foregroundColor: MomThemeColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: MomThemeColors.primary,
        shadowColor: MomThemeColors.primary.withOpacity(0.1),
        centerTitle: true,
        titleTextStyle: MomTypography.headline5.copyWith(
          color: MomThemeColors.textPrimary,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // === Typografia ===
      textTheme: TextTheme(
        displayLarge: MomTypography.headline1,
        displayMedium: MomTypography.headline2,
        displaySmall: MomTypography.headline3,
        headlineLarge: MomTypography.headline4,
        headlineMedium: MomTypography.headline5,
        headlineSmall: MomTypography.headline6,
        titleLarge: MomTypography.headline6,
        titleMedium: MomTypography.subtitle1,
        titleSmall: MomTypography.subtitle2,
        bodyLarge: MomTypography.body1,
        bodyMedium: MomTypography.body2,
        bodySmall: MomTypography.caption,
        labelLarge: MomTypography.buttonText,
        labelMedium: MomTypography.buttonTextSmall,
        labelSmall: MomTypography.caption,
      ),

      // === Przyciski ===
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MomThemeColors.primary,
          foregroundColor: MomThemeColors.textOnColor,
          elevation: 4,
          shadowColor: MomThemeColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: MomTypography.buttonText,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MomThemeColors.primary,
          textStyle: MomTypography.buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MomThemeColors.primary,
          side: BorderSide(color: MomThemeColors.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: MomTypography.buttonText,
        ),
      ),

      // === Floating Action Button ===
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: MomThemeColors.primary,
        foregroundColor: MomThemeColors.textOnColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // === Karty ===
      cardTheme: const CardThemeData(
        color: MomThemeColors.surface,
        shadowColor: MomThemeColors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: EdgeInsets.all(8),
      ),

      // === Input Fields ===
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: MomThemeColors.surface,
        // Note: Styles będą stosowane przez komponenty bezpośrednio
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: MomThemeColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: MomThemeColors.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: MomThemeColors.error,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),

      // === Chip ===
      chipTheme: ChipThemeData(
        backgroundColor: MomThemeColors.surface,
        selectedColor: MomThemeColors.primary.withOpacity(0.2),
        disabledColor: MomThemeColors.surface.withOpacity(0.5),
        labelStyle: MomTypography.body2,
        secondaryLabelStyle: MomTypography.body2.copyWith(
          color: MomThemeColors.primary,
        ),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: MomThemeColors.primary.withOpacity(0.3),
        ),
      ),

      // === Dialog ===
      dialogTheme: const DialogThemeData(
        backgroundColor: MomThemeColors.background,
        surfaceTintColor: MomThemeColors.primary,
        elevation: 8,
        shadowColor: MomThemeColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),

      // === Bottom Sheet ===
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: MomThemeColors.background,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),

      // === Tab Bar ===
      tabBarTheme: const TabBarThemeData(
        labelColor: MomThemeColors.primary,
        unselectedLabelColor: MomThemeColors.textSecondary,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: MomThemeColors.primary,
            width: 3,
          ),
          insets: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),

      // === Bottom Navigation Bar ===
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: MomThemeColors.background,
        selectedItemColor: MomThemeColors.primary,
        unselectedItemColor: MomThemeColors.textSecondary,
        selectedLabelStyle: MomTypography.navLabel,
        unselectedLabelStyle: MomTypography.navLabel,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // === Switch ===
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return MomThemeColors.primary;
          }
          return MomThemeColors.textSecondary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return MomThemeColors.primary.withOpacity(0.5);
          }
          return MomThemeColors.surface;
        }),
      ),

      // === Checkbox ===
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return MomThemeColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(MomThemeColors.textOnColor),
        side: BorderSide(color: MomThemeColors.primary, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // === Radio ===
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return MomThemeColors.primary;
          }
          return MomThemeColors.textSecondary;
        }),
      ),

      // === Slider ===
      sliderTheme: SliderThemeData(
        activeTrackColor: MomThemeColors.primary,
        inactiveTrackColor: MomThemeColors.surface,
        thumbColor: MomThemeColors.primary,
        overlayColor: MomThemeColors.primary.withOpacity(0.2),
        valueIndicatorColor: MomThemeColors.primary,
        valueIndicatorTextStyle: MomTypography.caption.copyWith(
          color: MomThemeColors.textOnColor,
        ),
      ),

      // === Progress Indicator ===
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: MomThemeColors.primary,
        linearTrackColor: MomThemeColors.surface,
        circularTrackColor: MomThemeColors.surface,
      ),

      // === Divider ===
      dividerTheme: DividerThemeData(
        color: MomThemeColors.surface,
        thickness: 1,
        space: 16,
      ),
    );
  }

  static ThemeData get darkTheme {
    // TODO: Implementować dark theme w przyszłości
    // Na razie zwracamy light theme
    return lightTheme;
  }
}

/// Deprecated - zachowane dla kompatybilności z istniejącym kodem
/// Używaj MomThemeColors zamiast tego
class AppColors {
  static const Color primary = MomThemeColors.primary;
  static const Color secondary = MomThemeColors.secondary;
  static const Color accent = MomThemeColors.accent;
  static const Color background = MomThemeColors.background;
  static const Color surface = MomThemeColors.surface;
  static const Color white = MomThemeColors.textOnColor;
  static const Color textPrimary = MomThemeColors.textPrimary;
  static const Color textSecondary = MomThemeColors.textSecondary;
  
  static const LinearGradient primaryGradient = MomThemeColors.primaryGradient;
} 