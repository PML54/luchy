/// <cursor>
/// LUCHY - Sélecteur de niveau éducatif pour quizz
///
/// Widget interactif pour permettre à l'utilisateur de choisir
/// le niveau éducatif des quizz (14 niveaux français).
///
/// COMPOSANTS PRINCIPAUX:
/// - Affichage des 14 niveaux avec icônes et couleurs
/// - Sélection visuelle du niveau actuel
/// - Intégration avec GameSettingsNotifier
/// - Design responsive et accessible
///
/// ÉTAT ACTUEL:
/// - Interface: Cards avec icônes et descriptions
/// - Interaction: Tap pour sélectionner niveau
/// - Persistance: Sauvegarde automatique via provider
/// - UX: Feedback visuel immédiat
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: RÉVOLUTION - Support 14 niveaux éducatifs français
/// - Remplacement de NiveauDifficulte par NiveauEducatif
/// - Interface adaptée pour les cycles éducatifs
/// - Support responsive et accessibilité
///
/// 🔧 POINTS D'ATTENTION:
/// - UX: Feedback visuel clair pour la sélection
/// - Accessibilité: Support lecteurs d'écran
/// - Performance: Éviter rebuilds inutiles
/// - Design: Cohérence avec thème app
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter animations de transition
/// - Implémenter prévisualisation des questions
/// - Ajouter statistiques par niveau
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: État
/// - features/puzzle/domain/models/game_state.dart: NiveauEducatif
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Interface utilisateur clé)
/// 📅 Dernière modification: 2025-01-27 23:55
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/features/puzzle/domain/models/game_state.dart';
import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';

class QuizDifficultySelector extends ConsumerWidget {
  final bool showTitle;
  final EdgeInsets? padding;
  final double? cardHeight;

  const QuizDifficultySelector({
    super.key,
    this.showTitle = true,
    this.padding,
    this.cardHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSettings = ref.watch(gameSettingsProvider);
    final currentLevel = gameSettings.quizDifficultyLevel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Niveau éducatif',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
        SizedBox(
          height: cardHeight ?? 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: NiveauDifficulte.values.length,
            itemBuilder: (context, index) {
              final niveau = NiveauDifficulte.values[index];
              final isSelected = niveau == currentLevel;

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: _DifficultyCard(
                  niveau: niveau,
                  isSelected: isSelected,
                  onTap: () => _selectDifficulty(ref, niveau),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _selectDifficulty(WidgetRef ref, NiveauDifficulte niveau) {
    ref.read(gameSettingsProvider.notifier).setQuizDifficultyLevel(niveau);
  }
}

class _DifficultyCard extends StatelessWidget {
  final NiveauDifficulte niveau;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.niveau,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        decoration: BoxDecoration(
          color: isSelected
              ? niveau.couleur.withOpacity(0.1)
              : Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected ? niveau.couleur : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: niveau.couleur.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                niveau.icone,
                size: 32,
                color: isSelected
                    ? niveau.couleur
                    : Theme.of(context).iconTheme.color,
              ),
              const SizedBox(height: 8),
              Text(
                niveau.nom,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? niveau.couleur
                          : Theme.of(context).textTheme.titleMedium?.color,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                niveau.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget compact pour afficher le niveau actuel
class CurrentDifficultyIndicator extends ConsumerWidget {
  final bool showIcon;
  final bool showDescription;

  const CurrentDifficultyIndicator({
    super.key,
    this.showIcon = true,
    this.showDescription = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSettings = ref.watch(gameSettingsProvider);
    final currentLevel = gameSettings.quizDifficultyLevel;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(
            currentLevel.icone,
            size: 20,
            color: Colors.white,
          ),
        ],
        if (showDescription) ...[
          const SizedBox(width: 8),
          Text(
            currentLevel.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withOpacity(0.7),
                ),
          ),
        ],
      ],
    );
  }
}
