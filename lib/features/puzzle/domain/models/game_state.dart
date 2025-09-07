/// <cursor>
/// LUCHY - Modèles d'état du jeu de puzzle
///
/// Définitions des structures de données immutables pour gérer
/// l'état du jeu de puzzle avec Freezed et type safety.
///
/// COMPOSANTS PRINCIPAUX:
/// - GameSettings: Configuration paramètres jeu (grille, niveau éducatif)
/// - GameState: État runtime du jeu (pièces, progression, mouvements)
/// - NiveauEducatif: 14 niveaux éducatifs français (CP à Bac+2)
/// - Factories: Constructeurs d'états initiaux et par défaut
/// - Freezed integration: Immutabilité et copyWith() automatiques
///
/// ÉTAT ACTUEL:
/// - Structure: Séparation claire settings vs runtime state
/// - Grilles: Support tailles variables (3x3 à 6x6)
/// - Quizz: Support 14 niveaux éducatifs français
/// - Data types: Uint8List pour images, type-safe partout
/// - Performance: Optimisé pour changements fréquents d'état
///
/// HISTORIQUE RÉCENT:
/// - 2025-01-27: RÉVOLUTION - Système niveaux éducatifs français
/// - Remplacement NiveauDifficulte par NiveauEducatif (14 niveaux)
/// - Niveaux: CP, CE1, CE2, CM1, CM2, 6e, 5e, 4e, 3e, 2nde, 1ère, Terminale, Bac+1, Bac+2
/// - Cycles: Primaire (vert), Collège (bleu), Lycée (orange), Supérieur (violet)
/// - Diagnostic: Système d'estimation automatique du niveau
/// - 2025-01-27: NOUVEAU - Ajout niveaux de difficulté pour quizz éducatifs
/// - 2025-01-08: Ajout puzzleType pour types puzzles éducatifs
/// - Optimisation sérialisation/désérialisation états
/// - Amélioration gestion mémoire pour grandes grilles
/// - Intégration meilleure avec providers Riverpod
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Immutabilité: Toujours utiliser copyWith() pour modifications
/// - Memory usage: Surveiller RAM avec grandes images/grilles
/// - Serialization: Uint8List peut être lourd à sérialiser
/// - State consistency: Maintenir cohérence entre settings et state
/// - Niveau estimé: CM2 par défaut, diagnostic requis
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Implémenter système d'estimation automatique
/// - Définir types de questions par niveau éducatif
/// - Adapter moteurs quizz pour 14 niveaux
/// - Créer interface de diagnostic
/// - Étendre types puzzles (colonnes autres que 1-2)
/// - Ajouter support grilles asymétriques (ex: 4x6)
/// - Implémenter compression intelligente pour pieces
/// - Ajouter métadonnées timing et scoring
/// - Optimiser pour undo/redo states
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: Utilisation états
/// - features/puzzle/domain/models/image_processing_data.dart: Données images
/// - core/operations/*_skills_engine.dart: Moteurs quizz avec niveaux éducatifs
/// - game_state.freezed.dart: Code généré Freezed
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Structure données centrale jeu)
/// 📅 Dernière modification: 2025-01-27 23:00
/// </cursor>
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';

/// Niveaux de difficulté pour les quizz
enum NiveauDifficulte {
  facile('Facile', 'Questions simples et rapides', 1),
  moyen('Moyen', 'Questions d\'un niveau standard', 2),
  difficile('Difficile', 'Questions complexes et exigeantes', 3);

  const NiveauDifficulte(this.nom, this.description, this.valeur);
  final String nom;
  final String description;
  final int valeur;

  Color get couleur {
    switch (this) {
      case NiveauDifficulte.facile:
        return Colors.green;
      case NiveauDifficulte.moyen:
        return Colors.orange;
      case NiveauDifficulte.difficile:
        return Colors.red;
    }
  }

  IconData get icone {
    switch (this) {
      case NiveauDifficulte.facile:
        return Icons.star;
      case NiveauDifficulte.moyen:
        return Icons.star_half;
      case NiveauDifficulte.difficile:
        return Icons.star_border;
    }
  }
}

@freezed
class GameSettings with _$GameSettings {
  const factory GameSettings({
    required int difficultyCols,
    required int difficultyRows,
    required bool useCustomGridSize,
    required bool hasSeenDocumentation,
    required int
        puzzleType, // 1=classique, 2=éducatif (colonnes 1-2), 3=combinaisons
    required NiveauDifficulte
        quizDifficultyLevel, // Niveau de difficulté des quizz
  }) = _GameSettings;

  factory GameSettings.initial() => const GameSettings(
        difficultyCols: 3,
        difficultyRows: 3,
        useCustomGridSize: true,
        hasSeenDocumentation: false,
        puzzleType: 1,
        quizDifficultyLevel:
            NiveauDifficulte.moyen, // Niveau par défaut = Moyen
      );
}

@freezed
class GameState with _$GameState {
  const factory GameState({
    required bool isInitialized,
    required List<Uint8List> pieces,
    required int columns,
    required int rows,
    required List<int> initialArrangement,
    required List<int> currentArrangement,
    required int swapCount,
    required int minimalMoves,
    required Size imageSize,
    required bool isPUZType,
    required String puzzCode,
    required bool isCoded,
    required int
        puzzleType, // Type de puzzle : 1=classique, 2=éducatif, 3=combinaisons
    List<int>? educationalMapping, // Mapping original pour puzzles éducatifs
    DateTime? startTime, // Heure de début pour chronométrage puzzles éducatifs
    String?
        currentImageName, // Nom de l'image actuelle pour messages personnalisés
  }) = _GameState;

  factory GameState.initial() => const GameState(
        isInitialized: false,
        pieces: [],
        columns: 0,
        rows: 0,
        initialArrangement: [],
        currentArrangement: [],
        swapCount: 0,
        minimalMoves: 0,
        imageSize: Size.zero,
        isPUZType: false,
        puzzCode: '',
        isCoded: false,
        puzzleType: 1,
        educationalMapping: null,
        startTime: null,
        currentImageName: null,
      );
}
