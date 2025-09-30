/// <cursor>
///
/// app_theme.dart
/// core/theme/
///
/// LUCHY - Thème moderne et attractif de l'application
///
/// Système de thème unifié avec palette de couleurs riche,
/// dégradés et animations pour une interface moderne et engageante.
///
/// COMPOSANTS PRINCIPAUX:
/// - AppTheme: Classe principale de gestion des thèmes
/// - ColorPalette: Palette de couleurs moderne et cohérente
/// - GradientDefinitions: Dégradés pour boutons et backgrounds
/// - AnimationDurations: Durées standardisées pour animations
/// - ThemeExtensions: Extensions personnalisées pour couleurs spécifiques
///
/// ÉTAT ACTUEL:
/// - Palette de couleurs moderne avec 8 couleurs principales
/// - Dégradés pour boutons, backgrounds et cartes
/// - Support mode sombre/clair adaptatif
/// - Couleurs spécialisées par fonctionnalité (quiz, puzzles, etc.)
/// - Animations fluides et cohérentes
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création système de thème moderne
/// - Palette inspirée des apps modernes (Discord, Notion, etc.)
/// - Dégradés pour rendre l'interface plus attractive
/// - Couleurs spécialisées pour chaque type de contenu
///
/// 🔧 POINTS D'ATTENTION:
/// - Cohérence: Utiliser les couleurs définies partout
/// - Accessibilité: Contraste suffisant pour lisibilité
/// - Performance: Éviter les rebuilds inutiles
/// - Évolutivité: Facile d'ajouter de nouveaux thèmes
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Thèmes saisonniers (Noël, été, etc.)
/// - Personnalisation par l'utilisateur
/// - Animations de transition entre thèmes
/// - Mode sombre plus sophistiqué
///
/// 🔗 FICHIERS LIÉS:
/// - main.dart: Application du thème principal
/// - puzzle_game_screen.dart: Interface principale
/// - modern_math_skills_screen.dart: Quiz mathématiques
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Interface utilisateur)
/// 📅 Dernière modification: 2025-01-27 18:30
/// </cursor>

import 'package:flutter/material.dart';

class AppTheme {
  // ===== PALETTE DE COULEURS MODERNE =====
  static const Color primaryBlue = Color(0xFF6366F1); // Indigo moderne
  static const Color primaryPurple = Color(0xFF8B5CF6); // Violet vibrant
  static const Color primaryGreen = Color(0xFF10B981); // Vert émeraude
  static const Color primaryOrange = Color(0xFFF59E0B); // Orange ambré
  static const Color primaryPink = Color(0xFFEC4899); // Rose vif
  static const Color primaryTeal = Color(0xFF14B8A6); // Teal moderne
  static const Color primaryRed = Color(0xFFEF4444); // Rouge moderne
  static const Color primaryYellow = Color(0xFFEAB308); // Jaune doré

  // Couleurs de fond
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF0F0F23);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A2E);

  // Couleurs de texte
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);

  // ===== DÉGRADÉS MODERNES =====
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [primaryGreen, primaryTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [primaryOrange, primaryYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [primaryRed, primaryPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mathGradient = LinearGradient(
    colors: [primaryBlue, primaryTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient geographyGradient = LinearGradient(
    colors: [primaryGreen, primaryYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient puzzleGradient = LinearGradient(
    colors: [primaryPurple, primaryPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== DURÉES D'ANIMATION =====
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration verySlowAnimation = Duration(milliseconds: 800);

  // ===== THÈME CLAIR =====
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: CircleBorder(),
      ),
    );
  }

  // ===== THÈME SOMBRE =====
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textLight,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        shape: CircleBorder(),
      ),
    );
  }

  // ===== COULEURS SPÉCIALISÉES =====
  static Color getMathColor() => primaryBlue;
  static Color getGeographyColor() => primaryGreen;
  static Color getPuzzleColor() => primaryPurple;
  static Color getSuccessColor() => primaryGreen;
  static Color getWarningColor() => primaryOrange;
  static Color getErrorColor() => primaryRed;

  // ===== DÉGRADÉS SPÉCIALISÉS =====
  static LinearGradient getMathGradient() => mathGradient;
  static LinearGradient getGeographyGradient() => geographyGradient;
  static LinearGradient getPuzzleGradient() => puzzleGradient;
  static LinearGradient getSuccessGradient() => successGradient;
  static LinearGradient getWarningGradient() => warningGradient;
  static LinearGradient getErrorGradient() => errorGradient;

  // ===== ANIMATIONS =====
  static Widget buildAnimatedContainer({
    required Widget child,
    required bool isVisible,
    Duration duration = normalAnimation,
    Curve curve = Curves.easeInOut,
  }) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  static Widget buildScaleAnimation({
    required Widget child,
    required bool isVisible,
    Duration duration = normalAnimation,
    Curve curve = Curves.elasticOut,
  }) {
    return AnimatedScale(
      scale: isVisible ? 1.0 : 0.0,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  static Widget buildSlideAnimation({
    required Widget child,
    required bool isVisible,
    Duration duration = normalAnimation,
    Curve curve = Curves.easeInOut,
    Offset offset = const Offset(0, 0.3),
  }) {
    return AnimatedSlide(
      offset: isVisible ? Offset.zero : offset,
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}

// ===== EXTENSIONS POUR COULEURS =====
extension ColorExtensions on Color {
  Color withOpacity(double opacity) {
    return withValues(alpha: opacity);
  }

  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
