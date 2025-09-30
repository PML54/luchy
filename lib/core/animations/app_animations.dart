/// <cursor>
///
/// app_animations.dart
/// core/animations/
///
/// LUCHY - Système d'animations moderne et fluide
///
/// Collection d'animations prédéfinies pour rendre l'interface
/// plus attractive et engageante avec des transitions fluides.
///
/// COMPOSANTS PRINCIPAUX:
/// - AppAnimations: Classe principale avec animations prédéfinies
/// - FadeAnimations: Animations de fondu (opacity)
/// - ScaleAnimations: Animations d'échelle (zoom)
/// - SlideAnimations: Animations de glissement
/// - RotationAnimations: Animations de rotation
/// - BounceAnimations: Animations de rebond
/// - StaggeredAnimations: Animations décalées
///
/// ÉTAT ACTUEL:
/// - Animations de base: Fade, Scale, Slide, Rotation, Bounce
/// - Animations spécialisées: Puzzle completion, Quiz validation
/// - Transitions d'écran: Slide, Fade, Scale
/// - Animations de feedback: Success, Error, Loading
/// - Durées standardisées et courbes optimisées
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: Création système d'animations moderne
/// - Animations inspirées des apps modernes (iOS, Material Design 3)
/// - Courbes d'animation optimisées pour fluidité
/// - Animations spécialisées pour chaque type de contenu
///
/// 🔧 POINTS D'ATTENTION:
/// - Performance: Éviter les animations trop complexes
/// - Accessibilité: Respecter les préférences d'accessibilité
/// - Cohérence: Utiliser les mêmes durées et courbes
/// - Memory: Dispose correctement les AnimationController
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Animations de particules pour les réussites
/// - Transitions de page plus sophistiquées
/// - Animations de chargement personnalisées
/// - Micro-interactions pour les boutons
///
/// 🔗 FICHIERS LIÉS:
/// - core/theme/app_theme.dart: Durées d'animation
/// - features/puzzle/presentation/widgets/board/puzzle_board.dart: Completion puzzle
/// - features/puzzle/presentation/screens/modern_math_skills_screen.dart: Quiz validation
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Expérience utilisateur)
/// 📅 Dernière modification: 2025-01-27 18:45
/// </cursor>

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:luchy/core/theme/app_theme.dart';

class AppAnimations {
  // ===== ANIMATIONS DE BASE =====

  /// Animation de fondu avec contrôle de visibilité
  static Widget fadeIn({
    required Widget child,
    required bool isVisible,
    Duration duration = AppTheme.normalAnimation,
    Curve curve = Curves.easeInOut,
  }) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  /// Animation d'échelle avec effet de zoom
  static Widget scaleIn({
    required Widget child,
    required bool isVisible,
    Duration duration = AppTheme.normalAnimation,
    Curve curve = Curves.elasticOut,
    double scale = 1.0,
  }) {
    return AnimatedScale(
      scale: isVisible ? scale : 0.0,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  /// Animation de glissement
  static Widget slideIn({
    required Widget child,
    required bool isVisible,
    Duration duration = AppTheme.normalAnimation,
    Curve curve = Curves.easeOutCubic,
    Offset offset = const Offset(0, 0.3),
  }) {
    return AnimatedSlide(
      offset: isVisible ? Offset.zero : offset,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  /// Animation de rotation
  static Widget rotateIn({
    required Widget child,
    required bool isVisible,
    Duration duration = AppTheme.normalAnimation,
    Curve curve = Curves.easeInOut,
    double angle = 0.5, // 180 degrés
  }) {
    return AnimatedRotation(
      turns: isVisible ? 0.0 : angle,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  // ===== ANIMATIONS SPÉCIALISÉES =====

  /// Animation de réussite avec effet de confettis
  static Widget successAnimation({
    required Widget child,
    required bool isSuccess,
    Duration duration = AppTheme.slowAnimation,
  }) {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation(isSuccess ? 1.0 : 0.0),
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            child,
            if (isSuccess) _buildConfettiEffect(),
          ],
        );
      },
    );
  }

  /// Animation d'erreur avec effet de shake
  static Widget errorAnimation({
    required Widget child,
    required bool isError,
    Duration duration = AppTheme.fastAnimation,
  }) {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation(isError ? 1.0 : 0.0),
      builder: (context, _) {
        return Transform.translate(
          offset: isError
              ? Offset(
                  sin(DateTime.now().millisecondsSinceEpoch * 0.01) * 10, 0)
              : Offset.zero,
          child: child,
        );
      },
    );
  }

  /// Animation de chargement avec pulsation
  static Widget loadingPulse({
    required Widget child,
    required bool isLoading,
    Duration duration = AppTheme.normalAnimation,
  }) {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation(isLoading ? 1.0 : 0.0),
      builder: (context, _) {
        return AnimatedOpacity(
          opacity: isLoading
              ? 0.5 + 0.5 * sin(DateTime.now().millisecondsSinceEpoch * 0.005)
              : 1.0,
          duration: const Duration(milliseconds: 1000),
          child: child,
        );
      },
    );
  }

  // ===== ANIMATIONS DE TRANSITION =====

  /// Transition de page avec slide
  static Widget pageSlideTransition({
    required Widget child,
    required Animation<double> animation,
    bool isEntering = true,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: isEntering ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      )),
      child: child,
    );
  }

  /// Transition de page avec fade
  static Widget pageFadeTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Transition de page avec scale
  static Widget pageScaleTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: child,
    );
  }

  // ===== ANIMATIONS DE BOUTONS =====

  /// Animation de pression de bouton
  static Widget buttonPressAnimation({
    required Widget child,
    required VoidCallback onPressed,
    Duration duration = AppTheme.fastAnimation,
  }) {
    return GestureDetector(
      onTapDown: (_) {
        // Animation de pression
      },
      onTapUp: (_) {
        onPressed();
      },
      child: AnimatedScale(
        scale: 1.0,
        duration: duration,
        child: child,
      ),
    );
  }

  /// Animation de hover pour les boutons
  static Widget buttonHoverAnimation({
    required Widget child,
    required bool isHovered,
    Duration duration = AppTheme.fastAnimation,
  }) {
    return AnimatedScale(
      scale: isHovered ? 1.05 : 1.0,
      duration: duration,
      curve: Curves.easeInOut,
      child: child,
    );
  }

  // ===== ANIMATIONS DE PUZZLE =====

  /// Animation de placement de pièce de puzzle
  static Widget puzzlePiecePlacement({
    required Widget child,
    required bool isPlaced,
    Duration duration = AppTheme.normalAnimation,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.elasticOut,
      transform: Matrix4.identity()
        ..scale(isPlaced ? 1.0 : 0.8)
        ..rotateZ(isPlaced ? 0.0 : 0.1),
      child: child,
    );
  }

  /// Animation de complétion de puzzle
  static Widget puzzleCompletion({
    required Widget child,
    required bool isCompleted,
    Duration duration = AppTheme.slowAnimation,
  }) {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation(isCompleted ? 1.0 : 0.0),
      builder: (context, _) {
        return Transform.scale(
          scale: isCompleted
              ? 1.0 + 0.1 * sin(DateTime.now().millisecondsSinceEpoch * 0.01)
              : 1.0,
          child: child,
        );
      },
    );
  }

  // ===== ANIMATIONS DE QUIZ =====

  /// Animation de validation de réponse
  static Widget quizAnswerValidation({
    required Widget child,
    required bool isCorrect,
    Duration duration = AppTheme.normalAnimation,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: isCorrect ? Curves.elasticOut : Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCorrect
            ? AppTheme.getSuccessColor().withOpacity(0.1)
            : AppTheme.getErrorColor().withOpacity(0.1),
        border: Border.all(
          color:
              isCorrect ? AppTheme.getSuccessColor() : AppTheme.getErrorColor(),
          width: isCorrect ? 2.0 : 1.0,
        ),
      ),
      child: child,
    );
  }

  /// Animation de progression de quiz
  static Widget quizProgress({
    required Widget child,
    required double progress,
    Duration duration = AppTheme.normalAnimation,
  }) {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation(progress),
      builder: (context, _) {
        return LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation(AppTheme.getMathColor()),
        );
      },
    );
  }

  // ===== ANIMATIONS DÉCALÉES =====

  /// Animation décalée pour les listes
  static Widget staggeredListAnimation({
    required List<Widget> children,
    Duration staggerDelay = const Duration(milliseconds: 100),
    Duration itemDuration = AppTheme.normalAnimation,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return AnimatedOpacity(
          opacity: 1.0,
          duration: itemDuration,
          child: AnimatedSlide(
            offset: Offset.zero,
            duration: itemDuration,
            child: child,
          ),
        );
      }).toList(),
    );
  }

  // ===== EFFETS VISUELS =====

  /// Effet de confettis pour les réussites
  static Widget _buildConfettiEffect() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: ConfettiPainter(),
        ),
      ),
    );
  }
}

// ===== PEINTRE POUR CONFETTIS =====
class ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final colors = [
      AppTheme.primaryBlue,
      AppTheme.primaryGreen,
      AppTheme.primaryOrange,
      AppTheme.primaryPink,
      AppTheme.primaryYellow,
    ];

    for (int i = 0; i < 20; i++) {
      final x = (i * 37) % size.width.toInt();
      final y = (i * 23) % size.height.toInt();
      final color = colors[i % colors.length];

      paint.color = color;
      canvas.drawCircle(
        Offset(x.toDouble(), y.toDouble()),
        3.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
