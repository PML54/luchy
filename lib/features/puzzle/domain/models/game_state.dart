/// <cursor>
/// LUCHY - Modèles d'état du jeu de puzzle
///
/// Définitions des structures de données immutables pour gérer
/// l'état du jeu de puzzle avec Freezed et type safety.
///
/// COMPOSANTS PRINCIPAUX:
/// - GameSettings: Configuration paramètres jeu (grille, difficulté)
/// - GameState: État runtime du jeu (pièces, progression, mouvements)
/// - Factories: Constructeurs d'états initiaux et par défaut
/// - Freezed integration: Immutabilité et copyWith() automatiques
///
/// ÉTAT ACTUEL:
/// - Structure: Séparation claire settings vs runtime state
/// - Grilles: Support tailles variables (3x3 à 6x6)
/// - Data types: Uint8List pour images, type-safe partout
/// - Performance: Optimisé pour changements fréquents d'état
///
/// HISTORIQUE RÉCENT:
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
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Étendre types puzzles (colonnes autres que 1-2)
/// - Ajouter support grilles asymétriques (ex: 4x6)
/// - Implémenter compression intelligente pour pieces
/// - Ajouter métadonnées timing et scoring
/// - Optimiser pour undo/redo states
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: Utilisation états
/// - features/puzzle/domain/models/image_processing_data.dart: Données images
/// - game_state.freezed.dart: Code généré Freezed
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Structure données centrale jeu)
/// </cursor>
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';

@freezed
class GameSettings with _$GameSettings {
  const factory GameSettings({
    required int difficultyCols,
    required int difficultyRows,
    required bool useCustomGridSize,
    required bool hasSeenDocumentation,
    required int
        puzzleType, // 1=classique, 2=éducatif (colonnes 1-2), 3=combinaisons
  }) = _GameSettings;

  factory GameSettings.initial() => const GameSettings(
        difficultyCols: 3,
        difficultyRows: 3,
        useCustomGridSize: true,
        hasSeenDocumentation: false,
        puzzleType: 1,
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
    String? currentImageName, // Nom de l'image actuelle pour messages personnalisés
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
