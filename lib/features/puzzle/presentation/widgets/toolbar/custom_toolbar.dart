/// <cursor>
/// LUCHY - Barre d'outils personnalisée du jeu
///
/// Interface de contrôle principale pour toutes les actions du jeu
/// de puzzle avec sélection difficulté et sources d'images.
///
/// COMPOSANTS PRINCIPAUX:
/// - CustomToolbar: Widget principal barre d'outils
/// - Difficulty slider: Contrôle niveau difficulté (3x3 à 6x6)
/// - Image sources: Boutons galerie, caméra, aléatoire
/// - Game controls: Preview, aide, version
/// - ToolbarButton: Widget bouton réutilisable
///
/// ÉTAT ACTUEL:
/// - Difficultés: 3x3, 4x4, 5x5, 6x6 grilles supportées
/// - Sources: Galerie, caméra, sélection aléatoire assets
/// - Interface: Responsive, adaptation automatique écran
/// - Version: Affichage v1.1.0+3 en temps réel
///
/// HISTORIQUE RÉCENT:
/// - Correction avertissements withOpacity deprecated
/// - Amélioration responsive design pour petits écrans
/// - Intégration affichage version dynamique
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Responsive: Tester sur différentes tailles écran
/// - State sync: Maintenir cohérence avec game providers
/// - Performance: Éviter rebuilds inutiles slider
/// - Permissions: Vérifier accès caméra/galerie
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter grilles asymétriques (4x6, etc.)
/// - Implémenter preset difficultés nommés
/// - Améliorer feedback visuel sélections
/// - Ajouter raccourcis clavier pour desktop
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: État jeu
/// - features/puzzle/presentation/controllers/image_controller.dart: Actions
/// - features/puzzle/presentation/screens/help_screen.dart: Navigation aide
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Interface contrôle principale)
/// </cursor>
/// - CustomToolbar: Main toolbar container
/// - Level controls
/// - Action buttons
///
/// CONTROL LOGIC:
/// - Grid size mapping
/// - Level calculation
/// - Difficulty management
/// - Image processing coordination
///
/// STATE MANAGEMENT:
/// - Uses Riverpod consumers
/// - Manages game settings
/// - Controls image processing
/// - Handles UI state
///
/// HISTORY:
/// v1.0 (2024-01-30):
/// - Initial documentation
/// - Documented widget structure
/// - Added control logic section
///
/// </claude>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            iconSize: 28,
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
  static const _iconSize = 28.0;

  static const _levelLabelStyle = TextStyle(
    color: Colors.white,
    fontSize: 12,
  );

  static const _levelNumberStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  // Icons constants
  static const _leftChevronIcon = Icon(Icons.chevron_left, color: Colors.white);
  static const _rightChevronIcon =
      Icon(Icons.chevron_right, color: Colors.white);

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

  Widget _buildLevelDisplay(String title, String level) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: _levelLabelStyle),
        Text(level, style: _levelNumberStyle),
      ],
    );
  }

  Widget _buildVersionDisplay(String version) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        'v$version',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
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
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final packageInfoAsync = ref.watch(packageInfoProvider);

    final currentLevel = _getCurrentLevel(gameState.columns, gameState.rows);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bouton source d'image
        ToolbarButton(
          icon: Icons.add_photo_alternate,
          label: l10n.photoGalleryLabel,
          color: Colors.white,
          onPressed: () => PuzzleGameScreen.showImageSourceDialog(context),
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
            _buildLevelDisplay("🧩", currentLevel.toString()),
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
            ToolbarButton(
              icon: Icons.refresh,
              label: l10n.surpriseLabel,
              color: Colors.white,
              onPressed: () =>
                  ref.read(imageControllerProvider.notifier).loadRandomImage(),
            ),
            if (gameState.swapCount > 20) ...[
              const SizedBox(width: 8),
              ToolbarButton(
                icon: Icons.remove_red_eye,
                label: l10n.previewLabel,
                color: Colors.white,
                onPressed: () => PuzzleGameScreen.toggleFullImage(context),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
