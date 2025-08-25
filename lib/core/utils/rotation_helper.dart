import 'package:flutter/material.dart';

/// Utilitaire pour suggérer des rotations selon logique simple
class RotationHelper {

  /// Calcule le pourcentage d'occupation d'une image dans l'espace disponible
  static double calculateOccupationPercentage({
    required Size screenSize,
    required double appBarHeight,
    required double imageAspectRatio,
  }) {
    final availableHeight = screenSize.height - appBarHeight;
    final availableArea = screenSize.width * availableHeight;

    // Calcul des dimensions image selon la logique actuelle
    double imageWidth, imageHeight;
    if (imageAspectRatio > screenSize.width / availableHeight) {
      imageWidth = screenSize.width;
      imageHeight = screenSize.width / imageAspectRatio;
    } else {
      imageHeight = availableHeight;
      imageWidth = availableHeight * imageAspectRatio;
    }

    final imageArea = imageWidth * imageHeight;
    return (imageArea / availableArea) * 100;
  }

  /// Détermine si on devrait suggérer une rotation (logique simplifiée)
  static bool shouldSuggestRotation({
    required Size screenSize,
    required double appBarHeight,
    required double imageAspectRatio,
    required Orientation currentOrientation,
  }) {
    // Debug des paramètres d'entrée
    debugPrint('🔄 Simple Rotation Logic:');
    debugPrint('  Image ratio: ${imageAspectRatio.toStringAsFixed(2)}');
    debugPrint('  Current orientation: $currentOrientation');

    bool shouldSuggest = false;
    String reason = '';

    if (currentOrientation == Orientation.portrait && imageAspectRatio > 1.0) {
      // En portrait avec image paysage → Suggérer paysage
      shouldSuggest = true;
      reason = 'Portrait + image paysage (ratio > 1) → Suggérer PAYSAGE';
    } else if (currentOrientation == Orientation.landscape && imageAspectRatio < 1.0) {
      // En paysage avec image portrait → Suggérer portrait
      shouldSuggest = true;
      reason = 'Paysage + image portrait (ratio < 1) → Suggérer PORTRAIT';
    } else {
      reason = 'Orientation et image déjà compatibles';
    }

    debugPrint('  💭 $reason');
    debugPrint('  🎯 Should suggest: $shouldSuggest');

    return shouldSuggest;
  }

  /// Calcule le gain d'occupation potentiel avec la rotation
  static double calculateRotationGain({
    required Size screenSize,
    required double appBarHeight,
    required double imageAspectRatio,
  }) {
    final currentOccupation = calculateOccupationPercentage(
      screenSize: screenSize,
      appBarHeight: appBarHeight,
      imageAspectRatio: imageAspectRatio,
    );

    final landscapeScreenSize = Size(screenSize.height, screenSize.width);
    final landscapeOccupation = calculateOccupationPercentage(
      screenSize: landscapeScreenSize,
      appBarHeight: appBarHeight,
      imageAspectRatio: imageAspectRatio,
    );

    return landscapeOccupation - currentOccupation;
  }

  /// Formatage user-friendly du gain
  static String formatGainMessage(double gain) {
    if (gain <= 0) return '';

    if (gain < 10) {
      return 'Gain modeste de ${gain.toStringAsFixed(1)}%';
    } else if (gain < 25) {
      return 'Gain significatif de ${gain.toStringAsFixed(1)}%';
    } else {
      return 'Gain important de ${gain.toStringAsFixed(1)}%';
    }
  }
}
