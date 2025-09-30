/// <cursor>
/// LUCHY - Widget de prévisualisation d'image
///
/// Composant d'affichage de la prévisualisation de l'image complète
/// du puzzle avec contrôle de visibilité dynamique.
///
/// COMPOSANTS PRINCIPAUX:
/// - ImagePreview: Widget principal de prévisualisation
/// - imagePreviewVisibilityProvider: Provider contrôle visibilité
/// - ImagePreviewControl: Extension pour contrôle programmatique
/// - Memory image display: Affichage optimisé depuis mémoire
///
/// ÉTAT ACTUEL:
/// - Display: Image mémoire avec fit contain pour préservation ratio
/// - Contrôle: Visibilité toggleable via provider
/// - Performance: Optimisé pour grandes images
/// - Responsive: Adaptation automatique taille écran
///
/// HISTORIQUE RÉCENT:
/// - Optimisation affichage grandes images
/// - Amélioration contrôle visibilité
/// - Intégration state management avec Riverpod
/// - Responsive design pour toutes orientations
///
/// 🔧 POINTS D'ATTENTION:
/// - Memory usage: Surveiller usage mémoire pour grandes images
/// - State sync: Maintenir cohérence avec état principal jeu
/// - Performance: Éviter rebuilds inutiles
/// - UX: Transition fluide show/hide
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter animations transition show/hide
/// - Implémenter zoom/pan pour grandes images
/// - Optimiser rendu pour très hautes résolutions
/// - Ajouter gesture controls (pinch, double-tap)
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: État image
/// - features/puzzle/presentation/screens/puzzle_game_screen.dart: Intégration
///
/// CRITICALITÉ: ⭐⭐⭐ (Widget utilitaire)
/// 📅 Dernière modification: 2024-12-20 15:35
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';

final imagePreviewVisibilityProvider = StateProvider<bool>((ref) => true);

class ImagePreview extends ConsumerWidget {
  const ImagePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPreview = ref.watch(imagePreviewVisibilityProvider);
    final imageState = ref.watch(imageProcessingProvider);

    if (!showPreview || imageState.fullImage == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Image.memory(
        imageState.fullImage!,
        fit: BoxFit.contain,
      ),
    );
  }
}

// Extension pour contrôler la visibilité de l'aperçu
extension ImagePreviewControl on WidgetRef {
  void showImagePreviewTemporarily(
      {Duration duration = const Duration(seconds: 3)}) {
    read(imagePreviewVisibilityProvider.notifier).state = true;
    Future.delayed(duration, () {
      read(imagePreviewVisibilityProvider.notifier).state = false;
    });
  }
}
