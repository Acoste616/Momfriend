import 'package:flutter/material.dart';

/// Paleta kolorów zoptymalizowana dla matek
/// Ciepłe, wspierające kolory budujące zaufanie i komfort
class MomThemeColors {
  // === Kolory główne ===
  /// Delikatny róż - główny kolor aplikacji, ciepły i przyjazny
  static const Color primary = Color(0xFFE8B4CB);
  
  /// Spokojny błękit - kolor wsparcia, budujący zaufanie  
  static const Color secondary = Color(0xFF9FCCF0);
  
  /// Słoneczny żółty - kolor akcentu, pozytywny i energetyzujący
  static const Color accent = Color(0xFFFDD835);
  
  // === Kolory tła i powierzchni ===
  /// Ciepły biały - główne tło aplikacji
  static const Color background = Color(0xFFFFFBFE);
  
  /// Neutralny szary - powierzchnie kart i kontenerów
  static const Color surface = Color(0xFFF5F5F5);
  
  /// Bardzo jasny róż - subtle surface dla specjalnych sekcji
  static const Color surfaceVariant = Color(0xFFFDF2F8);
  
  // === Kolory funkcjonalne ===
  /// Przyjazny zielony - sukces, zatwierdzenie
  static const Color success = Color(0xFF4CAF50);
  
  /// Delikatny pomarańczowy - ostrzeżenia
  static const Color warning = Color(0xFFFF9800);
  
  /// Łagodny czerwony - błędy (nie agresywny)
  static const Color error = Color(0xFFE57373);
  
  /// Informacyjny niebieski
  static const Color info = Color(0xFF2196F3);
  
  // === Kolory tekstu ===
  /// Główny kolor tekstu - ciepły czarny
  static const Color textPrimary = Color(0xFF2C2C2C);
  
  /// Drugorzędny kolor tekstu - szary
  static const Color textSecondary = Color(0xFF757575);
  
  /// Tekst na kolorowym tle
  static const Color textOnColor = Color(0xFFFFFFFF);
  
  /// Placeholder text
  static const Color textPlaceholder = Color(0xFFBDBDBD);
  
  // === Kolory dla matchingu ===
  /// Kolor "like" - ciepły róż
  static const Color like = Color(0xFFFF6B9D);
  
  /// Kolor "pass" - neutralny szary
  static const Color pass = Color(0xFF9E9E9E);
  
  /// Kolor "super like" - złoty
  static const Color superLike = Color(0xFFFFD700);
  
  // === Kolory weryfikacji ===
  /// Zweryfikowany profil - zielony
  static const Color verified = Color(0xFF4CAF50);
  
  /// Niezweryfikowany - szary
  static const Color unverified = Color(0xFF9E9E9E);
  
  // === Gradienty ===
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE8B4CB), Color(0xFFD197B8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF9FCCF0), Color(0xFF87CEEB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFDD835), Color(0xFFFBC02D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // === Cienie ===
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
  
  static List<BoxShadow> get strongShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
} 