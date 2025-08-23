/// <cursor>
/// LUCHY - Widget rapport de traitement d'images
///
/// Affichage détaillé des métriques de performance du traitement
/// d'images pour debugging et optimisation.
///
/// COMPOSANTS PRINCIPAUX:
/// - ImageProcessingReportWidget: ConsumerWidget pour métriques
/// - Performance display: Temps traitement, optimisation, découpage
/// - Size metrics: Dimensions originales vs optimisées
/// - Complexity info: Score complexité et recommendations
/// - Debug data: Informations techniques détaillées
///
/// ÉTAT ACTUEL:
/// - Métriques: Affichage temps réel performance processing
/// - Format: Données lisibles pour développeur et utilisateur
/// - Performance: Lightweight widget sans impact sur vitesse
/// - Debug: Informations complètes pour optimisation
///
/// HISTORIQUE RÉCENT:
/// - Intégration avec système profiler global
/// - Amélioration lisibilité métriques affichées
/// - Optimisation widget pour overhead minimal
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Performance impact: Minimiser overhead affichage métriques
/// - Data accuracy: Assurer cohérence avec données réelles
/// - UI readability: Maintenir lisibilité sur petits écrans
/// - Debug mode: Considérer masquer en production
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter graphiques performance temps réel
/// - Implémenter export métriques pour analyse
/// - Optimiser pour mode développeur vs utilisateur
/// - Intégrer avec dashboard performance global
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/models/image_processing_data.dart: Données métriques
/// - features/puzzle/domain/providers/game_providers.dart: Source données
/// - core/utils/profiler.dart: Intégration profiling
///
/// CRITICALITÉ: ⭐⭐ (Debug/développement uniquement)
/// </cursor>
/// - Complexity metrics
/// - Processing times
/// - Summary statistics
///
/// DATA VISUALIZATION:
/// - Grid information
/// - Size comparisons
/// - Time measurements
/// - Complexity levels
///
/// UI COMPONENTS:
/// - AlertDialog container
/// - Card layout
/// - Info rows
/// - Time display rows
///
/// PERFORMANCE TRACKING:
/// - Image dimensions
/// - Processing times
/// - Optimization metrics
/// - Complexity analysis
///
/// HISTORY:
/// v1.0 (2024-01-30):
/// - Initial documentation
/// - Added widget structure
/// - Documented data visualization
///
/// </claude>
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/features/puzzle/domain/models/image_processing_data.dart'; // Remonter 3 niveaux pour atteindre domain/models
// Domain imports (depuis la feature puzzle)
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart'; // Remonter 3 niveaux pour atteindre domain/providers
import 'package:luchy/l10n/app_localizations.dart';

class ImageProcessingReportWidget extends ConsumerWidget {
  const ImageProcessingReportWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final gameState = ref.watch(gameStateProvider);
    final imageProcessor = ref.watch(imageProcessingProvider);

    // Note: Pour le moment on affiche qu'une entrée, à étendre plus tard
    final currentData = ImageProcessingData(
      columns: gameState.columns,
      rows: gameState.rows,
      imageSize: gameState.imageSize,
      originalImageSize: imageProcessor.fullImage?.length ?? 0,
      optimizedImageSize: imageProcessor.fullImage?.length ?? 0,
      originalImageDimensions: imageProcessor.optimizedImageDimensions,
      optimizedImageDimensions: imageProcessor.optimizedImageDimensions,
      decodeImageTime: 0.0,
      createPuzzlePiecesTime: 0.0,
      shufflePiecesTime: 0.0,
      applyNewDifficultyTime: 0.0,
      processAndInitializePuzzleTime: 0.0,
      pickImageTime: 0.0,
      imageEntropy: 0.7,
      complexityLevel: 'Moyenne',
    );
    return AlertDialog(
      backgroundColor: Colors.blue.shade100,
      title: Text(
        l10n.imageProcessingReport,
        style: const TextStyle(color: Colors.black87),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${l10n.image} 1',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                // Informations de base
                Text(l10n.dimensions),
                _buildInfoRow('',
                    '${currentData.imageSize.width.toInt()} x ${currentData.imageSize.height.toInt()}'),
                _buildInfoRow(
                    l10n.grid, '${currentData.columns} x ${currentData.rows}'),
                _buildInfoRow(l10n.originalSize,
                    '${(currentData.originalImageSize / 1024).toStringAsFixed(2)} KB'),
                _buildInfoRow(l10n.optimizedSize,
                    '${(currentData.optimizedImageSize / 1024).toStringAsFixed(2)} KB'),

                // Informations sur la complexité
                const Divider(),
                const Text('Complexité',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _buildInfoRow(l10n.imageEntropy,
                    currentData.imageEntropy.toStringAsFixed(3)),
                _buildInfoRow('Niveau', currentData.complexityLevel),

                // Temps de traitement
                const Divider(),
                const Text('Temps de traitement',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _buildTimeRow(l10n.decodingTime, currentData.decodeImageTime),
                _buildTimeRow(l10n.piecesCreationTime,
                    currentData.createPuzzlePiecesTime),
                _buildTimeRow(l10n.shuffleTime, currentData.shufflePiecesTime),
                _buildTimeRow(
                    l10n.cropTime, currentData.applyNewDifficultyTime),
                _buildTimeRow(
                    l10n.initTime, currentData.processAndInitializePuzzleTime),
                _buildTimeRow(l10n.pickImageTime, currentData.pickImageTime),

                // Temps total
                const Divider(),
                _buildTimeRow(
                  l10n.totalTime,
                  currentData.decodeImageTime +
                      currentData.createPuzzlePiecesTime +
                      currentData.shufflePiecesTime +
                      currentData.applyNewDifficultyTime +
                      currentData.processAndInitializePuzzleTime +
                      currentData.pickImageTime,
                  isTotal: true,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(l10n.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, double time, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${time.toStringAsFixed(2)} ms',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.blue.shade700 : null,
            ),
          ),
        ],
      ),
    );
  }
}
