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
/// - Navigation quiz: Calcul et Géographie uniquement
///
/// ÉTAT ACTUEL:
/// - Interface: Responsive avec adaptation orientation
/// - Contrôles: Difficulté, sources images, navigation aide
/// - Design: Material Design 3 avec thème cohérent
/// - Eval: Navigation vers ModernMathSkillsScreen et QuizCategoryScreen
/// - Fonctionnalités: Complètes et stables
///
/// HISTORIQUE RÉCENT:
/// - Mon Sep 29 08:25: ESPACEMENT OPTIMAL - Augmentation espace entre flèches pour lisibilité parfaite
/// - Espace entre flèches: 8px → 12px pour meilleure séparation visuelle
/// - Mon Sep 29 08:23: ESPACEMENT ET RÉDUCTION FINALE - Ajout espace entre flèches et réduction finale
/// - Espace de 8px ajouté entre les flèches de difficulté pour meilleure lisibilité
/// - Toutes les 4 petites icônes réduites: 20px → 18px, cercles: 36px → 32px
/// - Mon Sep 29 08:20: CERCLES BLEUS FLÈCHES - Ajout cercles bleus autour des flèches de difficulté
/// - Flèches haut/bas entourées de cercles bleus (36x36px) pour cohérence visuelle
/// - Icônes aide et photo réduites à 20px, cercles à 36px pour meilleure proportion
/// - Mon Sep 29 08:17: COULEUR BLEUE - Changement fond cercles aide et photo vers bleu clair
/// - Cercles aide et photo: blanc → bleu clair (Colors.blue.shade100) pour distinction
/// - Mon Sep 29 08:15: RÉDUCTION CERCLES - Diminution taille des cercles entourant aide et photo
/// - Cercles aide et photo réduits à 40px pour proportionnalité avec icônes 24px
/// - Mon Sep 29 08:12: RÉDUCTION ICÔNES - Diminution taille icônes aide et photo pour mettre en valeur puzzle/quiz
/// - Icônes aide et photo réduites de 32px à 24px pour moins d'encombrement
/// - Mon Sep 29 07:46: AIDE DOUBLE-CLIC - Ajout explication double-clic pour voir toutes les images
/// - 2025-09-29: AIDE ÉDUCATIVE - Amélioration de l'aide avec détails pédagogiques
/// - 2025-09-29: AIDE BULLETIN - Ajout section Bulletin de Notes dans l'aide
/// - 2025-01-27: CORRECTION LARGEUR NÉGATIVE - Fix contraintes invalides
/// - Remplacement SizedBox(width: -8) par Transform.translate
/// - Espacement visuel sans contraintes négatives
/// - Fri Sep 26 21:56: AJOUT ESPACE ENTRE GLOBE ET CAMÉRA - Interface équilibrée
/// - Ajout SizedBox(width: 8) entre icône quiz et icône caméra
/// - Séparation visuelle des deux icônes entourées de blanc
/// - Interface plus lisible et moins serrée
///
/// 🔧 POINTS D'ATTENTION:
/// - Navigation: Seulement 2 types de quiz (Calcul + Géographie)
/// - Responsive: S'adapter automatiquement aux différentes tailles écran
/// - State management: Utiliser Riverpod pour cohérence avec app
/// - Performance: Éviter rebuilds inutiles lors changements état
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Tests de régression après nettoyage
/// - Ajouter animations de transition entre états
/// - Améliorer feedback haptique sur boutons
/// - Optimiser layout pour très petits écrans
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/presentation/screens/modern_math_skills_screen.dart: Eval Calcul
/// - features/puzzle/presentation/screens/geography_skills_screen.dart: Eval Géographie
/// - features/puzzle/domain/providers/game_providers.dart: État du jeu
/// - features/puzzle/presentation/controllers/image_controller.dart: Contrôle images
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Interface contrôle principale)
/// 📅 Dernière modification: Mon Sep 29 08:25:09 CEST 2025
/// </cursor>

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Core imports
import 'package:luchy/core/formulas/prepa_math_engine.dart';
import 'package:luchy/core/utils/educational_image_generator.dart';
// Domain imports

import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
import 'package:luchy/features/puzzle/presentation/controllers/image_controller.dart';
import 'package:luchy/features/puzzle/presentation/screens/puzzle_game_screen.dart';
// Feature imports
import 'package:luchy/features/puzzle/presentation/screens/quiz_category_screen.dart';
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
  static const _buttonPadding = EdgeInsets.all(1.0);
  static const _buttonConstraints = BoxConstraints(minHeight: 28, minWidth: 28);
  static const _iconSize = 28.0;
  static const _smallIconSize = 18.0; // Taille réduite pour aide et photo
  static const _smallCircleSize =
      32.0; // Taille réduite pour cercles aide et photo

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

    // Vérifications de sécurité
    final fullImage = imageState.fullImage;
    final dimensions = imageState.optimizedImageDimensions;

    // Les vérifications null ont déjà été faites plus haut

    // Mettre à jour les paramètres
    ref.read(gameSettingsProvider.notifier).setDifficulty(cols, rows);

    // Recréer les pièces avec la nouvelle grille
    final pieces =
        await ref.read(imageProcessingProvider.notifier).createPuzzlePieces(
              fullImage!,
              cols,
              rows,
            );

    // Initialiser le nouveau puzzle
    await ref.read(gameStateProvider.notifier).initializePuzzle(
          imageBytes: fullImage,
          pieces: pieces,
          columns: cols,
          rows: rows,
          imageSize: dimensions,
          shouldShuffle: true,
          puzzleType: ref.read(gameSettingsProvider).puzzleType,
          imageName: imageState.currentImageName,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final imageState = ref.watch(imageProcessingProvider);

    // Vérification de sécurité pour éviter les erreurs de contraintes
    if (!gameState.isInitialized ||
        gameState.columns == 0 ||
        gameState.rows == 0) {
      return const SizedBox.shrink();
    }

    final currentLevel = _getCurrentLevel(gameState.columns, gameState.rows);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Pomme verte (première position)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.apple),
              iconSize: _iconSize + 4, // Plus grosse
              tooltip: l10n.surpriseLabel,
              color: Colors.green,
              onPressed: () => ref
                  .read(imageControllerProvider.notifier)
                  .loadRandomImage(context),
            ),
          ),

          // 2. Flèches (contrôle difficulté)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: _smallCircleSize,
                height: _smallCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                  iconSize: _smallIconSize,
                  padding: _buttonPadding,
                  constraints: _buttonConstraints,
                  onPressed: currentLevel > 0
                      ? () async {
                          final (cols, rows) = _getGridSize(currentLevel - 1);
                          await _changeDifficulty(ref, cols, rows);
                        }
                      : null,
                ),
              ),
              const SizedBox(width: 12), // Espace entre les flèches
              // ✅ CORRECTION: Remplacement SizedBox négatif par Transform.translate
              Transform.translate(
                offset: const Offset(
                    -8, 0), // Décalage visuel sans contrainte négative
                child: Container(
                  width: _smallCircleSize,
                  height: _smallCircleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_up, color: Colors.black),
                    iconSize: _smallIconSize,
                    padding: _buttonPadding,
                    constraints: _buttonConstraints,
                    onPressed: currentLevel < 11
                        ? () async {
                            final (cols, rows) = _getGridSize(currentLevel + 1);
                            await _changeDifficulty(ref, cols, rows);
                          }
                        : null,
                  ),
                ),
              ),
            ],
          ),

          // 3. Tous les quiz (globe)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.public),
              iconSize: _iconSize + 4,
              onPressed: () => _navigateToEvalCategory(context),
              tooltip: "Tous les Eval",
              color: Colors.blue,
            ),
          ),

          const SizedBox(width: 4), // Petit espace entre globe et caméra

          // 4. Appareil photo
          Container(
            width: _smallCircleSize,
            height: _smallCircleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.black),
              iconSize: _smallIconSize,
              onPressed: () => PuzzleGameScreen.showImageSourceDialog(context),
              tooltip: l10n.photoGalleryLabel,
              color: Colors.green,
            ),
          ),

          const SizedBox(width: 4), // Espace avant aide

          // 5. Aide en ligne
          Container(
            width: _smallCircleSize,
            height: _smallCircleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.black),
              iconSize: _smallIconSize,
              onPressed: () => _showHelpDialog(context),
              tooltip: "Aide en ligne",
              color: Colors.orange,
            ),
          ),

          // Bouton aperçu (si nécessaire)
          if (gameState.swapCount >= 5) ...[
            IconButton(
              icon: const Icon(Icons.remove_red_eye),
              iconSize: _iconSize,
              tooltip: l10n.previewLabel,
              color: Colors.white,
              onPressed: () => PuzzleGameScreen.toggleFullImage(context),
            ),
          ],
        ],
      ),
    );
  }

  /// Navigue vers l'écran des catégories de quiz (géographie, etc.)
  void _navigateToEvalCategory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizCategoryScreen(),
      ),
    );
  }

  /// Affiche le dialog d'aide en ligne
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.help_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text('Aide Luchy'),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Comment jouer :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• Glissez les pièces pour les déplacer'),
                Text('• Cliquez sur les flèches pour changer la difficulté'),
                Text(
                    '• Double-cliquez sur l\'image pour voir toutes les images'),
                Text(
                    '• Tapez sur l\'image de votre choix pour la sélectionner'),
                Text('• Utilisez l\'appareil photo pour vos images'),
                Text('• Le globe vous mène aux quiz éducatifs'),
                SizedBox(height: 16),
                Text(
                  'Évaluations éducatives :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• Rétablissez le bon ordre à droite'),
                Text('• Cliquez sur "Vérifier" pour valider'),
                Text('• Les explications apparaissent en rouge si faux'),
                SizedBox(height: 16),
                Text(
                  'Eval Maths - Habileté au calcul :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• Calcul mental et ordres de grandeur'),
                Text('• 14 niveaux du CP au Bac+2'),
                Text('• Progression adaptative automatique'),
                Text('• Teste la rapidité et la précision'),
                SizedBox(height: 16),
                Text(
                  'Eval Philo & SVT - Bac :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• Connaissance du cours + imagination'),
                Text('• Concepts clés pour futurs bacheliers'),
                Text('• Définitions et explications détaillées'),
                Text('• Préparation aux épreuves du Bac'),
                SizedBox(height: 16),
                Text(
                  'Bulletin de Notes :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('• Cliquez sur l\'icône école 🏫 pour voir vos notes'),
                Text('• Consultez votre moyenne générale sur 20'),
                Text('• Suivez vos progrès par évaluation'),
                Text('• Chaque contrôle est noté automatiquement'),
                SizedBox(height: 16),
                Text(
                  'Version 1.2.0 - Bulletin de Notes',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
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
  // Détermine le type de puzzle selon le questionnaire
  int _getPuzzleType(QuestionnairePreset questionnaire) {
    switch (questionnaire.typeDeJeu) {
      case TypeDeJeu.habileteMaths:
        return 7; // Type spécial pour habileté maths (nouveau système)
      case TypeDeJeu.habileteGeographie:
        return 8; // Type spécial pour habileté géographie
      // Type spécial pour épicerie
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionnaires = EducationalImageGenerator.getAllQuestionnaires();

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.school, color: Colors.blue),
          SizedBox(width: 8),
          Text('Puzzle Habileté'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 500,
        child: Column(
          children: [
            // Liste des presets (sélecteur de type supprimé)
            Expanded(
              child: ListView.builder(
                itemCount: questionnaires.length,
                itemBuilder: (context, index) {
                  final questionnaire = questionnaires[index];
                  return Card(
                    child: ListTile(
                      leading: _getQuestionnaireIcon(questionnaire),
                      title: Text(questionnaire.nom),
                      onTap: () {
                        Navigator.of(context).pop();
                        _handleQuestionnaireSelection(context, questionnaire);
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

  /// Retourne l'icône appropriée selon le questionnaire
  Widget _getQuestionnaireIcon(QuestionnairePreset questionnaire) {
    IconData iconData;
    switch (questionnaire.typeDeJeu) {
      case TypeDeJeu.habileteMaths:
        iconData = Icons.functions;
        break;
      case TypeDeJeu.habileteGeographie:
        iconData = Icons.public;
        break;
    }

    return Icon(
      iconData,
      color: _getColorForLevel(questionnaire.niveau),
    );
  }

  Color _getColorForLevel(NiveauEducatif niveau) {
    switch (niveau) {
      case NiveauEducatif.cp:
      case NiveauEducatif.ce1:
      case NiveauEducatif.ce2:
      case NiveauEducatif.cm1:
      case NiveauEducatif.cm2:
        return Colors.green;
      case NiveauEducatif.sixieme:
      case NiveauEducatif.cinquieme:
      case NiveauEducatif.quatrieme:
      case NiveauEducatif.troisieme:
        return Colors.blue;
      case NiveauEducatif.seconde:
      case NiveauEducatif.premiere:
      case NiveauEducatif.terminale:
        return Colors.orange;
      case NiveauEducatif.bacPlus1:
      case NiveauEducatif.bacPlus2:
        return Colors.purple;
    }
  }

  /// Gère la sélection d'un questionnaire (puzzle normal ou formulaire LaTeX)
  void _handleQuestionnaireSelection(
    BuildContext context,
    QuestionnairePreset questionnaire,
  ) {
    // Navigation vers les écrans Habileté
    if (questionnaire.typeDeJeu == TypeDeJeu.habileteMaths) {
      // Si c'est habileté maths, naviguer vers la liste des quiz (qui contient les habiletés maths)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const QuizCategoryScreen(),
        ),
      );
    } else if (questionnaire.typeDeJeu == TypeDeJeu.habileteGeographie) {
      // Si c'est habileté géographie, naviguer vers les catégories de quiz
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const QuizCategoryScreen(),
        ),
      );
    } else {
      // Sinon, générer l'image de puzzle éducatif classique
      _generateQuestionnaireImage(context, questionnaire);
    }
  }

  /// Génère et charge l'image questionnaire avec largeurs dynamiques
  Future<void> _generateQuestionnaireImage(
    BuildContext context,
    QuestionnairePreset questionnaire,
  ) async {
    try {
      // Générer avec la nouvelle méthode qui supporte les largeurs dynamiques
      final result =
          await EducationalImageGenerator.generateFromQuestionnairePreset(
        questionnaire,
        cellWidth: 600,
        cellHeight: 200,
        applyEducationalShuffle: true,
      );

      // Mettre à jour le type de puzzle dans les paramètres
      final puzzleType = _getPuzzleType(questionnaire);
      await widget.ref
          .read(gameSettingsProvider.notifier)
          .setPuzzleType(puzzleType);

      // Charger l'image dans le jeu
      await widget.ref
          .read(imageControllerProvider.notifier)
          .loadEducationalImage(
            result.pngBytes,
            rows: result.rows,
            columns: result.columns,
            description: result.description,
            puzzleType: puzzleType,
            educationalMapping: result.originalMapping,
          );

      // Afficher un message de confirmation
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Questionnaire "${questionnaire.nom}" chargé !'),
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
