/// <cursor>
/// LUCHY - Barre d'outils personnalisée du jeu
///
/// Widget de barre d'outils principal avec contrôles de difficulté,
/// gestion des images et informations de version.
///
/// COMPOSANTS PRINCIPAUX:
/// - CustomToolbar: Widget principal barre d'outils responsive
/// - ToolbarButton: Bouton standardisé avec icône et label
/// - DifficultySelector: Sélecteur de grille (3x3 à 6x6)
/// - ImageControls: Boutons galerie, caméra, images prédéfinies
/// - VersionDisplay: Affichage version app en bas
///
/// ÉTAT ACTUEL:
/// - Interface: Responsive avec adaptation orientation
/// - Contrôles: Difficulté, sources images, navigation aide
/// - Design: Material Design 3 avec thème cohérent
/// - Fonctionnalités: Complètes et stables
///
/// HISTORIQUE RÉCENT:
/// - Optimisation responsive design pour toutes orientations
/// - Amélioration accessibilité et feedback utilisateur
/// - Intégration informations version dynamiques
/// - Suppression compteur mouvements (déplacé vers victory message)
///
/// 🔧 POINTS D'ATTENTION:
/// - Responsive: S'adapter automatiquement aux différentes tailles écran
/// - State management: Utiliser Riverpod pour cohérence avec app
/// - Performance: Éviter rebuilds inutiles lors changements état
/// - UX: Feedback visuel clair pour toutes interactions
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter animations de transition entre états
/// - Améliorer feedback haptique sur boutons
/// - Optimiser layout pour très petits écrans
/// - Considérer mode accessibilité étendu
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: État du jeu
/// - features/puzzle/presentation/controllers/image_controller.dart: Contrôle images
/// - features/puzzle/presentation/screens/help_screen.dart: Écran d'aide
/// - l10n/app_localizations.dart: Système de traduction
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Interface contrôle principale)
/// 📅 Dernière modification: 2025-08-25 15:01
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Core imports
import 'package:luchy/core/utils/educational_image_generator.dart';
// Domain imports

import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'package:luchy/features/puzzle/presentation/controllers/image_controller.dart';
// Feature imports
import 'package:luchy/features/puzzle/presentation/screens/puzzle_game_screen.dart';
import 'package:luchy/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Provider pour les informations de version
final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return await PackageInfo.fromPlatform();
});

/// Widget d'un bouton de la barre d'outils
class ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const ToolbarButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(icon, color: color),
            iconSize: 32,
            onPressed: onPressed,
            padding: const EdgeInsets.all(2.0),
            constraints: const BoxConstraints(minHeight: 32),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Barre d'outils principale
class CustomToolbar extends ConsumerWidget {
  const CustomToolbar({super.key});

  // Styles et constantes
  static const _buttonPadding = EdgeInsets.all(2.0);
  static const _buttonConstraints = BoxConstraints(minHeight: 32);
  static const _iconSize = 32.0;

  // Icons constants
  static const _leftChevronIcon =
      Icon(Icons.keyboard_arrow_down, color: Colors.white);
  static const _rightChevronIcon =
      Icon(Icons.keyboard_arrow_up, color: Colors.white);

  /// Conversion niveau en taille de grille (colonnes, lignes)
  static (int, int) _getGridSize(int level) {
    // Chaque colonne aura la même largeur
    // Chaque ligne aura la même hauteur
    switch (level) {
      case 0:
        return (2, 2); // 4 pièces uniformes
      case 1:
        return (3, 2); // 6 pièces: 3 colonnes égales × 2 lignes égales
      case 2:
        return (2, 3); // 6 pièces: 2 colonnes égales × 3 lignes égales
      case 3:
        return (3, 3); // 9 pièces: 3×3
      case 4:
        return (4, 3); // 12 pièces: 4 colonnes égales × 3 lignes égales
      case 5:
        return (3, 4); // 12 pièces: 3 colonnes égales × 4 lignes égales
      case 6:
        return (4, 4); // 16 pièces: 4×4
      case 7:
        return (5, 4); // 20 pièces: 5 colonnes égales × 4 lignes égales
      case 8:
        return (4, 5); // 20 pièces: 4 colonnes égales × 5 lignes égales
      case 9:
        return (5, 5); // 25 pièces: 5×5
      case 10:
        return (6, 5); // 30 pièces: 6 colonnes égales × 5 lignes égales
      case 11:
        return (5, 6); // 30 pièces: 5 colonnes égales × 6 lignes égales
      default:
        return (2, 2); // Par défaut: 4 pièces uniformes
    }
  }

  /// Obtenir le niveau actuel à partir des dimensions
  static int _getCurrentLevel(int cols, int rows) {
    if (cols == 2 && rows == 2) return 0;
    if (cols == 3 && rows == 2) return 1;
    if (cols == 2 && rows == 3) return 2;
    if (cols == 3 && rows == 3) return 3;
    if (cols == 4 && rows == 3) return 4;
    if (cols == 3 && rows == 4) return 5;
    if (cols == 4 && rows == 4) return 6;
    if (cols == 5 && rows == 4) return 7;
    if (cols == 4 && rows == 5) return 8;
    if (cols == 5 && rows == 5) return 9;
    if (cols == 6 && rows == 5) return 10;
    if (cols == 5 && rows == 6) return 11;
    return 0; // Par défaut
  }

  Future<void> _changeDifficulty(WidgetRef ref, int cols, int rows) async {
    final imageState = ref.read(imageProcessingProvider);
    if (imageState.fullImage == null) return;

    // Mettre à jour les paramètres
    ref.read(gameSettingsProvider.notifier).setDifficulty(cols, rows);

    // Recréer les pièces avec la nouvelle grille
    final pieces =
        await ref.read(imageProcessingProvider.notifier).createPuzzlePieces(
              imageState.fullImage!, // Utiliser l'image complète
              cols,
              rows,
            );

    // Initialiser le nouveau puzzle
    await ref.read(gameStateProvider.notifier).initializePuzzle(
          imageBytes: imageState.fullImage!, // Utiliser l'image complète
          pieces: pieces,
          columns: cols,
          rows: rows,
          imageSize: imageState.optimizedImageDimensions,
          shouldShuffle: true,
          puzzleType: ref.read(gameSettingsProvider).puzzleType,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    final currentLevel = _getCurrentLevel(gameState.columns, gameState.rows);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bouton source d'image
        /*ToolbarButton(
          icon: Icons.camera_alt_outlined,
          label: l10n.photoGalleryLabel,
          color: Colors.white,
          onPressed: () => PuzzleGameScreen.showImageSourceDialog(context),
        ),
*/
        IconButton(
          icon: const Icon(Icons.camera_alt_outlined),
          iconSize: _iconSize,
          onPressed: () => PuzzleGameScreen.showImageSourceDialog(context),
          tooltip: l10n.photoGalleryLabel, // garde l'accessibilité
          color: Colors.white,
        ),
        // Bouton éducation
        IconButton(
          icon: const Icon(Icons.school_outlined),
          iconSize: _iconSize,
          onPressed: () => _showEducationalDialog(context, ref),
          tooltip: "Puzzles éducatifs",
          color: Colors.white,
        ),
        // Contrôle du niveau
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: _leftChevronIcon,
              iconSize: _iconSize,
              padding: _buttonPadding,
              constraints: _buttonConstraints,
              onPressed: currentLevel > 0
                  ? () async {
                      final (cols, rows) = _getGridSize(currentLevel - 1);
                      await _changeDifficulty(ref, cols, rows);
                    }
                  : null,
            ),
            IconButton(
              icon: _rightChevronIcon,
              iconSize: _iconSize,
              padding: _buttonPadding,
              constraints: _buttonConstraints,
              onPressed: currentLevel < 11
                  ? () async {
                      final (cols, rows) = _getGridSize(currentLevel + 1);
                      await _changeDifficulty(ref, cols, rows);
                    }
                  : null,
            ),
          ],
        ),

        // Boutons d'action
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              iconSize: _iconSize,
              tooltip: l10n.surpriseLabel,
              color: Colors
                  .white, // ou: style: IconButton.styleFrom(foregroundColor: Colors.white)
              onPressed: () =>
                  ref.read(imageControllerProvider.notifier).loadRandomImage(),
            ),
            if (gameState.swapCount > 20) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.remove_red_eye),
                iconSize: _iconSize,
                tooltip: l10n.previewLabel,
                color: Colors
                    .white, // ou: style: IconButton.styleFrom(foregroundColor: Colors.white)
                onPressed: () => PuzzleGameScreen.toggleFullImage(context),
              ),
            ]
          ],
        ),
      ],
    );
  }

  /// Affiche le dialog de sélection des puzzles éducatifs
  void _showEducationalDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EducationalPresetDialog(ref: ref);
      },
    );
  }
}

/// Dialog de sélection des presets éducatifs
class EducationalPresetDialog extends StatefulWidget {
  final WidgetRef ref;

  const EducationalPresetDialog({
    super.key,
    required this.ref,
  });

  @override
  State<EducationalPresetDialog> createState() =>
      _EducationalPresetDialogState();
}

class _EducationalPresetDialogState extends State<EducationalPresetDialog> {
  int _selectedPuzzleType = 1; // 1=classique, 2=éducatif

  @override
  Widget build(BuildContext context) {
    final presets = EducationalImageGenerator.getAllPresets();

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.school, color: Colors.blue),
          SizedBox(width: 8),
          Text('Puzzles Éducatifs'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 500,
        child: Column(
          children: [
            // Sélecteur de type de puzzle
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Type de puzzle :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        Row(
                          children: [
                            Radio<int>(
                              value: 1,
                              groupValue: _selectedPuzzleType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPuzzleType = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPuzzleType = 1;
                                  });
                                },
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Classique',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Toutes les pièces mélangées',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Radio<int>(
                              value: 2,
                              groupValue: _selectedPuzzleType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPuzzleType = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPuzzleType = 2;
                                  });
                                },
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Éducatif',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Mélange colonnes 1-2 uniquement',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Liste des presets
            Expanded(
              child: ListView.builder(
                itemCount: presets.length,
                itemBuilder: (context, index) {
                  final preset = presets[index];
                  return Card(
                    child: ListTile(
                      leading: _getPresetIcon(preset.id),
                      title: Text(preset.name),
                      subtitle: Text(preset.description),
                      trailing: Text(
                        '${preset.leftColumn.length} lignes',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _generateEducationalImage(context, preset);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
      ],
    );
  }

  /// Retourne l'icône appropriée selon le type de preset
  Widget _getPresetIcon(String presetId) {
    if (presetId.startsWith('multiplication_')) {
      return const Icon(Icons.calculate, color: Colors.orange);
    } else if (presetId.startsWith('vocab_')) {
      return const Icon(Icons.translate, color: Colors.green);
    } else if (presetId.startsWith('geo_')) {
      return const Icon(Icons.public, color: Colors.blue);
    }
    return const Icon(Icons.quiz, color: Colors.purple);
  }

  /// Génère et charge l'image éducative
  Future<void> _generateEducationalImage(
    BuildContext context,
    EducationalPreset preset,
  ) async {
    try {
      // Générer l'image avec mélange éducatif si type 2
      final applyEducationalShuffle = _selectedPuzzleType == 2;
      final result = await EducationalImageGenerator.generateFromPreset(
        preset,
        cellWidth: 600,
        cellHeight: 200,
        applyEducationalShuffle: applyEducationalShuffle,
      );

      // Mettre à jour le type de puzzle dans les paramètres
      await widget.ref
          .read(gameSettingsProvider.notifier)
          .setPuzzleType(_selectedPuzzleType);

      // Charger l'image dans le jeu avec grille forcée 2 colonnes
      await widget.ref
          .read(imageControllerProvider.notifier)
          .loadEducationalImage(
            result.pngBytes,
            rows: result.rows,
            columns: result.columns,
            description: result.description,
            puzzleType: _selectedPuzzleType,
            educationalMapping: result.originalMapping,
          );

      // Afficher un message de confirmation
      if (context.mounted) {
        final typeLabel = _selectedPuzzleType == 2 ? 'éducatif' : 'classique';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Puzzle $typeLabel "${preset.name}" chargé !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Afficher l'erreur
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
