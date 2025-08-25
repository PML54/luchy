import 'package:flutter/material.dart';

/// Utilitaire pour calculer l'occupation d'écran et suggérer des rotations
class RotationHelper {
  /// Seuil minimum de gain d'occupation pour suggérer une rotation (en %)
  static const double _minimumGainThreshold = 15.0;

  /// Seuil d'aspect ratio pour considérer une image comme "paysage"
  static const double _landscapeThreshold = 1.3;

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

  /// Détermine si on devrait suggérer une rotation
  static bool shouldSuggestRotation({
    required Size screenSize,
    required double appBarHeight,
    required double imageAspectRatio,
    required Orientation currentOrientation,
  }) {
    // Ne suggérer que si on est en portrait avec une image paysage
    if (currentOrientation != Orientation.portrait) {
      return false;
    }

    // L'image doit être suffisamment "paysage"
    if (imageAspectRatio < _landscapeThreshold) {
      return false;
    }

    // Calculer l'occupation actuelle (portrait)
    final currentOccupation = calculateOccupationPercentage(
      screenSize: screenSize,
      appBarHeight: appBarHeight,
      imageAspectRatio: imageAspectRatio,
    );

    // Simuler l'occupation en paysage (inverser dimensions écran)
    final landscapeScreenSize = Size(screenSize.height, screenSize.width);
    final landscapeOccupation = calculateOccupationPercentage(
      screenSize: landscapeScreenSize,
      appBarHeight: appBarHeight,
      imageAspectRatio: imageAspectRatio,
    );

    // Calculer le gain potentiel
    final gain = landscapeOccupation - currentOccupation;
    
    return gain >= _minimumGainThreshold;
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
