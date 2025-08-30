/// <cursor>
/// LUCHY - AppBar spécialisée pour les puzzles éducatifs
///
/// Widget d'AppBar dédiée aux puzzles éducatifs avec contrôles spécifiques :
/// bouton quitter, compteur de pièces, et génération aléatoire de quiz.
///
/// COMPOSANTS PRINCIPAUX:
/// - EducationalAppBar: AppBar principale pour mode éducatif
/// - Bouton quitter: Retour au mode puzzle normal
/// - Compteur pièces: Affichage compact progression
/// - Bouton aléatoire: Génération nouveau quiz éducatif
///
/// ÉTAT ACTUEL:
/// - Interface: Compacte et spécialisée pour éducatif
/// - Contrôles: Quitter, compteur, génération aléatoire
/// - Design: Material Design 3 cohérent avec app
/// - Fonctionnalités: En cours d'implémentation
///
/// HISTORIQUE RÉCENT:
/// - Simplification AppBar: suppression titre pour économiser espace
/// - Correction compteur: affichage correspondances éducatives (8/10) vs pièces
/// - Création initiale pour résoudre débordement boutons iPhone
/// - Documentation format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Responsive: S'adapter aux différentes tailles écran
/// - State management: Utiliser Riverpod pour cohérence
/// - UX: Contrôles intuitifs pour mode éducatif
/// - Performance: Éviter rebuilds inutiles
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Implémenter génération aléatoire presets
/// - Ajouter animations transitions
/// - Optimiser pour très petits écrans
/// - Tests complets sur différents devices
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: État du jeu
/// - core/utils/educational_image_generator.dart: Génération images éducatives
/// - features/puzzle/presentation/screens/puzzle_game_screen.dart: Écran principal
/// - features/puzzle/presentation/widgets/toolbar/custom_toolbar.dart: Toolbar normale
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Interface éducative spécialisée)
/// 📅 Dernière modification: 2025-01-27 17:25
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/core/utils/educational_image_generator.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'package:luchy/features/puzzle/presentation/controllers/image_controller.dart';
import 'package:luchy/features/puzzle/presentation/widgets/dialogs/verification_results_dialog.dart';

/// AppBar spécialisée pour les puzzles éducatifs
class EducationalAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const EducationalAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final totalQuestions =
        gameState.rows; // Nombre de lignes = nombre de questions

    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Bouton quitter (retour mode normal)
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            tooltip: 'Quitter mode éducatif',
            onPressed: () => _quitEducationalMode(ref),
          ),

          // Icône éducative (sans titre pour économiser l'espace)
          const Icon(Icons.school, color: Colors.white, size: 20),

          const Spacer(), // Prend l'espace disponible

          // Bouton de vérification des réponses
          Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.white),
              tooltip: 'Vérifier les réponses',
              onPressed: () => _verifyAnswers(context, ref, totalQuestions),
            ),
          ),

          const SizedBox(width: 8),

          // Bouton génération aléatoire
          IconButton(
            icon: const Icon(Icons.shuffle, color: Colors.white),
            tooltip: 'Quiz aléatoire',
            onPressed: () => _generateRandomEducationalQuiz(ref),
          ),
        ],
      ),
    );
  }

  /// Vérifier les réponses et afficher les résultats
  Future<void> _verifyAnswers(
      BuildContext context, WidgetRef ref, int totalQuestions) async {
    try {
      // Compter les bonnes réponses
      final correctAnswers = ref
          .read(gameStateProvider.notifier)
          .countCorrectEducationalCorrespondences();

      // Récupérer le temps écoulé depuis le début du puzzle
      final elapsedTime = ref.read(gameStateProvider.notifier).getElapsedTime();

      // Afficher le dialog des résultats
      final result = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => VerificationResultsDialog(
          correctAnswers: correctAnswers,
          totalQuestions: totalQuestions,
          elapsedTime: elapsedTime,
        ),
      );

      // Gérer les actions du dialog
      if (result == 'restart') {
        await _generateRandomEducationalQuiz(ref);
      }
    } catch (e) {
      debugPrint('Erreur lors de la vérification: $e');
    }
  }

  /// Quitter le mode éducatif et revenir au mode puzzle normal
  Future<void> _quitEducationalMode(WidgetRef ref) async {
    try {
      // Passer en mode puzzle normal (type 1)
      await ref.read(gameSettingsProvider.notifier).setPuzzleType(1);

      // Charger une image aléatoire normale
      await ref.read(imageControllerProvider.notifier).loadRandomImage();
    } catch (e) {
      debugPrint('Erreur lors de la sortie du mode éducatif: $e');
    }
  }

  /// Générer aléatoirement un nouveau quiz éducatif
  Future<void> _generateRandomEducationalQuiz(WidgetRef ref) async {
    try {
      // Récupérer tous les presets éducatifs disponibles
      final presets = EducationalImageGenerator.getAllPresets();
      if (presets.isEmpty) return;

      // Sélectionner un preset aléatoire
      final randomIndex =
          DateTime.now().millisecondsSinceEpoch % presets.length;
      final selectedPreset = presets[randomIndex];

      // Récupérer le type de puzzle actuel (éducatif ou classique)
      final currentSettings = ref.read(gameSettingsProvider);
      final applyEducationalShuffle = currentSettings.puzzleType == 2;

      // Générer l'image éducative
      final result = await EducationalImageGenerator.generateFromPreset(
        selectedPreset,
        cellWidth: 600,
        cellHeight: 200,
        applyEducationalShuffle: applyEducationalShuffle,
      );

      // Charger l'image dans le jeu
      await ref.read(imageControllerProvider.notifier).loadEducationalImage(
            result.pngBytes,
            rows: result.rows,
            columns: result.columns,
            description: result.description,
            puzzleType: currentSettings.puzzleType,
            educationalMapping: result.originalMapping,
          );
    } catch (e) {
      debugPrint('Erreur lors de la génération du quiz aléatoire: $e');
    }
  }
}
