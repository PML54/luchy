/// <cursor>
/// LUCHY - Données de traitement et métriques images
///
/// Structure de données pour tracker les métriques de performance
/// du traitement d'images avec monitoring complet des opérations.
///
/// COMPOSANTS PRINCIPAUX:
/// - ImageProcessingData: Classe Freezed pour métriques immutables
/// - Timing metrics: Durées traitement, optimisation, découpage
/// - Size tracking: Dimensions originales vs optimisées
/// - Performance data: Complexity score, RAM usage, efficacité
/// - Grid information: Taille grille, nombre pièces
///
/// ÉTAT ACTUEL:
/// - Métriques: Timing précis toutes opérations critique
/// - Monitoring: RAM, CPU, temps traitement temps réel
/// - Optimisation: Calcul ratio compression et qualité
/// - Performance: Score complexité pour adaptation algorithmes
///
/// HISTORIQUE RÉCENT:
/// - Intégration monitoring temps réel avec profiler
/// - Amélioration calculs métriques performance
/// - Optimisation structure données pour overhead minimal
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Immutabilité: Toujours utiliser copyWith() pour updates
/// - Performance overhead: Minimiser impact mesures sur vitesse
/// - Memory tracking: Surveiller accumulation données métriques
/// - Timing precision: Gérer variations platform pour mesures
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter métriques qualité visuelle post-processing
/// - Implémenter historique métriques pour analytics
/// - Optimiser pour monitoring temps réel sans impact
/// - Intégrer avec dashboard performance développeur
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: Utilisation métriques
/// - core/utils/profiler.dart: Integration monitoring
/// - image_processing_data.freezed.dart: Code généré Freezed
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Monitoring performance critique)
/// </cursor>
/// - Processing durations
/// - Optimization metrics
/// - Complexity scoring
///
/// PERFORMANCE MONITORING:
/// - Detailed timing breakdowns
/// - Size optimization tracking
/// - Resource usage monitoring
/// - Complexity assessment
///
/// HISTORY:
/// v1.0 (2024-01-30):
/// - Initial documentation
/// - Documented metrics tracking
/// - Added performance monitoring section
///
/// </claude>

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_processing_data.freezed.dart';

/// Model for tracking image processing metrics and performance data.
///
/// Tracks comprehensive metrics including:
/// * Grid dimensions and image sizes
/// * Processing times for various operations
/// * Image complexity metrics
/// * Performance measurements
///
/// Usage:
/// ```dart
/// final metrics = ImageProcessingData(
///   columns: 3,
///   rows: 3,
///   imageSize: Size(800, 600),
///   // ... other parameters
/// );
///
/// // Access metrics
/// print('Processing time: ${metrics.decodeImageTime}ms');
/// print('Complexity: ${metrics.complexityLevel}');
/// ```
@freezed
class ImageProcessingData with _$ImageProcessingData {
  /// Creates an instance with complete processing metrics.
  ///
  /// Parameters:
  /// * [columns] Number of columns in puzzle grid
  /// * [rows] Number of rows in puzzle grid
  /// * [imageSize] Current image dimensions
  /// * [originalImageSize] Size in bytes of original image
  /// * [optimizedImageSize] Size in bytes after optimization
  /// * [originalImageDimensions] Original width and height
  /// * [optimizedImageDimensions] Dimensions after optimization
  /// * [decodeImageTime] Time taken to decode image in ms
  /// * [createPuzzlePiecesTime] Time taken to create pieces in ms
  /// * [shufflePiecesTime] Time taken to shuffle pieces in ms
  /// * [applyNewDifficultyTime] Time to apply difficulty changes in ms
  /// * [pickImageTime] Time taken to pick/select image in ms
  /// * [processAndInitializePuzzleTime] Total initialization time in ms
  /// * [imageEntropy] Calculated image complexity score
  /// * [complexityLevel] Human-readable complexity description
  const factory ImageProcessingData({
    required int columns,
    required int rows,
    required Size imageSize,
    required int originalImageSize,
    required int optimizedImageSize,
    required Size originalImageDimensions,
    required Size optimizedImageDimensions,
    required double decodeImageTime,
    required double createPuzzlePiecesTime,
    required double shufflePiecesTime,
    required double applyNewDifficultyTime,
    required double pickImageTime,
    required double processAndInitializePuzzleTime,
    required double imageEntropy,
    required String complexityLevel,
  }) = _ImageProcessingData;

  /// Creates an initial instance with default values.
  ///
  /// Used for:
  /// * Initial state before processing
  /// * Reset after errors
  /// * Default values in state management
  factory ImageProcessingData.initial() => ImageProcessingData(
        columns: 0,
        rows: 0,
        imageSize: Size.zero,
        originalImageSize: 0,
        optimizedImageSize: 0,
        originalImageDimensions: Size.zero,
        optimizedImageDimensions: Size.zero,
        decodeImageTime: 0.0,
        createPuzzlePiecesTime: 0.0,
        shufflePiecesTime: 0.0,
        applyNewDifficultyTime: 0.0,
        pickImageTime: 0.0,
        processAndInitializePuzzleTime: 0.0,
        imageEntropy: 0.0,
        complexityLevel: '',
      );
}
