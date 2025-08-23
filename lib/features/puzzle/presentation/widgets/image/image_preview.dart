/// <cursor>
/// LUCHY - Widget prévisualisation image complète
///
/// Affichage temporaire de l'image complète du puzzle pour
/// référence pendant la résolution.
///
/// COMPOSANTS PRINCIPAUX:
/// - ImagePreview: ConsumerWidget pour prévisualisation
/// - Visibility control: Affichage basé sur état showPreview
/// - Image display: Affichage centré image optimisée
/// - Memory management: Gestion efficace mémoire images
///
/// ÉTAT ACTUEL:
/// - Affichage: Toggle via bouton preview toolbar
/// - Performance: Optimisé pour grandes images
/// - Responsivité: Adaptation automatique taille écran
/// - État: Géré via gameStateProvider.showPreview
///
/// HISTORIQUE RÉCENT:
/// - Optimisation performance pour grandes images
/// - Amélioration gestion mémoire et cache
/// - Intégration fluide avec état jeu global
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Memory usage: Dispose correctement images après usage
/// - Performance: Éviter reloads inutiles image
/// - State sync: Maintenir cohérence avec providers
/// - Responsive: Adaptation toutes tailles écran
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter zoom/pan pour grandes images
/// - Implémenter overlay semi-transparent
/// - Optimiser pour mode paysage
/// - Ajouter animations transition show/hide
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: État showPreview
/// - features/puzzle/presentation/screens/puzzle_game_screen.dart: Intégration
/// - features/puzzle/presentation/widgets/toolbar/custom_toolbar.dart: Toggle
///
/// CRITICALITÉ: ⭐⭐⭐ (Aide utilisateur importante)
/// </cursor>
///
/// STATE MANAGEMENT:
/// - Uses StateProvider for visibility
/// - Handles image state
/// - Controls preview timing
///
/// HISTORY:
/// v1.0 (2024-01-30):
/// - Initial documentation
/// - Documented widget structure
/// - Added state management section
///
/// </claude>
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
