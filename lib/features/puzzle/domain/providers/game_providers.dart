
/// <cursor>
/// LUCHY - Providers centraux du jeu de puzzle
///
/// Gestionnaire d'état central pour toute la logique métier du jeu
/// de puzzle Luchy utilisant Riverpod pour la gestion d'état.
///
/// COMPOSANTS PRINCIPAUX:
/// - gameSettingsProvider: Configuration paramètres de jeu
/// - gameStateProvider: État central du jeu (pièces, progression)
/// - imageProcessingProvider: Gestion traitement et optimisation images
/// - initializationProvider: État d'initialisation application
/// - GameStateNotifier: Logique métier puzzle et interactions
/// - ImageProcessingNotifier: Logique traitement images et performance
///
/// ÉTAT ACTUEL:
/// - Gestion état: Riverpod avec StateNotifierProvider
/// - Performance: Monitoring intégré avec profiler
/// - Erreurs: Gestion robuste avec états d'erreur
/// - Optimisation: Cache et optimisation mémoire
///
/// HISTORIQUE RÉCENT:
/// - Amélioration performance traitement grandes images
/// - Intégration monitoring temps réel
/// - Optimisation gestion mémoire et cache
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - State updates: Toujours immutables avec copyWith()
/// - Memory leaks: Dispose correctement les ressources images
/// - Performance: Surveiller temps traitement et RAM usage
/// - Thread safety: Async operations bien gérées
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter sauvegarde/restauration état jeu
/// - Implémenter undo/redo pour mouvements
/// - Optimiser algorithmes shuffle et détection completion
/// - Ajouter statistiques avancées (temps, mouvements, etc.)
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/models/game_state.dart: Modèles d'état
/// - features/puzzle/domain/models/image_processing_data.dart: Données processing
/// - core/utils/image_optimizer.dart: Utilitaires optimisation
/// - core/utils/profiler.dart: Monitoring performance
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur logique métier application)
/// </cursor>
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

import 'package:luchy/features/puzzle/domain/models/game_state.dart';

import 'package:luchy/features/puzzle/domain/models/image_processing_data.dart';

import 'package:luchy/core/utils/image_optimizer.dart';
import 'package:luchy/core/utils/profiler.dart';

final gameSettingsProvider =
    StateNotifierProvider<GameSettingsNotifier, GameSettings>((ref) {
  return GameSettingsNotifier();
});

// Providers
final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier(ref);
});

final imageProcessingProvider =
    StateNotifierProvider<ImageProcessingNotifier, ImageProcessingState>((ref) {
  return ImageProcessingNotifier(ref);
});

final initializationProvider = StateProvider<bool>((ref) => false);

// Notifier pour les paramètres du jeu
class GameSettingsNotifier extends StateNotifier<GameSettings> {
  GameSettingsNotifier() : super(GameSettings.initial());

  void resetToDefaultDifficulty() {
    state = state.copyWith(
      difficultyCols: 3,
      difficultyRows: 3,
      useCustomGridSize: false,
    );
  }

  void setDifficulty(int cols, int rows) {
    state = state.copyWith(
      difficultyCols: cols,
      difficultyRows: rows,
      useCustomGridSize: true,
    );
  }
}

class GameStateNotifier extends StateNotifier<GameState> {
  static const int minPuzzlePieces = 6;
  final Ref ref;

  GameStateNotifier(this.ref) : super(GameState.initial());

  int countCorrectPieces() {
    if (!state.isInitialized) return 0;

    return state.currentArrangement
        .asMap()
        .entries
        .where((entry) => entry.value == entry.key)
        .length;
  }

  double getCompletionPercentage() {
    if (!state.isInitialized) return 0.0;

    final correctPieces = countCorrectPieces();
    return (correctPieces / state.pieces.length) * 100;
  }

  Future<void> initializePuzzle({
    required Uint8List imageBytes,
    required List<Uint8List> pieces,
    required int columns,
    required int rows,
    required Size imageSize,
    required bool shouldShuffle,
  }) async {
    final initialArrangement =
        List<int>.generate(pieces.length, (index) => index);
    List<int> shuffledArrangement;

    if (shouldShuffle) {
      shuffledArrangement = _createShuffledArrangement(pieces.length);
    } else {
      shuffledArrangement = List<int>.from(initialArrangement);
    }

    state = state.copyWith(
      pieces: pieces,
      columns: columns,
      rows: rows,
      imageSize: imageSize,
      initialArrangement: initialArrangement,
      currentArrangement: shuffledArrangement,
      isInitialized: true,
      swapCount: 0,
      minimalMoves: shouldShuffle ? pieces.length : 0,
    );
  }

  bool isGameComplete() {
    if (!state.isInitialized) return false;

    return state.currentArrangement
        .asMap()
        .entries
        .every((entry) => entry.value == entry.key);
  }

  void onPuzzleComplete() {
    // Cette méthode peut être enrichie plus tard pour gérer
    // les événements de fin de partie (score, animations, etc.)
  }

  void resetGame() {
    if (!state.isInitialized) return;

    state = state.copyWith(
      currentArrangement: List<int>.from(state.initialArrangement),
      swapCount: 0,
      minimalMoves: 0,
    );
  }

  void shufflePieces() {
    if (!state.isInitialized) return;

    final newArrangement = _createShuffledArrangement(state.pieces.length);

    state = state.copyWith(
      currentArrangement: newArrangement,
      swapCount: 0,
      minimalMoves: state.pieces.length,
    );
  }

  void swapPieces(int index1, int index2) {
    if (index1 == index2 || !state.isInitialized) return;

    final newArrangement = List<int>.from(state.currentArrangement);
    final temp = newArrangement[index1];
    newArrangement[index1] = newArrangement[index2];
    newArrangement[index2] = temp;

    state = state.copyWith(
      currentArrangement: newArrangement,
      swapCount: state.swapCount + 1,
    );

    // Vérifie si le puzzle est complété après le swap
    if (isGameComplete()) {
      onPuzzleComplete();
    }
  }

  // Nouvelle méthode pour créer un arrangement mélangé garantissant qu'aucune pièce
  // n'est à sa position initiale
  List<int> _createShuffledArrangement(int length) {
    final random = Random();
    final arrangement = List<int>.generate(length, (index) => index);

    // Algorithme de Fisher-Yates modifié pour garantir un dérangement
    for (int i = 0; i < length; i++) {
      int j;
      do {
        j = random.nextInt(length);
      } while (j == i); // S'assurer que l'élément ne reste pas à sa place

      // Effectuer l'échange
      final temp = arrangement[i];
      arrangement[i] = arrangement[j];
      arrangement[j] = temp;
    }

    // Vérification finale
    bool isValid = true;
    for (int i = 0; i < length; i++) {
      if (arrangement[i] == i) {
        isValid = false;
        break;
      }
    }

    // Si le mélange n'est pas valide, recommencer
    if (!isValid) {
      return _createShuffledArrangement(length);
    }

    return arrangement;
  }
}

// Notifier pour l'historique de traitement d'image
class ImageProcessingHistoryNotifier
    extends StateNotifier<List<ImageProcessingData>> {
  ImageProcessingHistoryNotifier() : super([]);

  void addEntry(ImageProcessingData data) {
    state = [...state, data];
  }

  void clear() {
    state = [];
  }

  double getAverageProcessingTime() {
    if (state.isEmpty) return 0.0;
    return state
            .map((data) =>
                data.decodeImageTime +
                data.createPuzzlePiecesTime +
                data.shufflePiecesTime +
                data.processAndInitializePuzzleTime)
            .reduce((a, b) => a + b) /
        state.length;
  }
}

class ImageProcessingNotifier extends StateNotifier<ImageProcessingState> {
  final Ref ref;

  ImageProcessingNotifier(this.ref) : super(ImageProcessingState());

  Future<List<Uint8List>> createPuzzlePieces(
    Uint8List imageBytes,
    int columns,
    int rows,
  ) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) throw Exception("Impossible de décoder l'image");

      final pieceWidth = image.width ~/ columns;
      final pieceHeight = image.height ~/ rows;
      final pieces = <Uint8List>[];

      for (var y = 0; y < rows; y++) {
        for (var x = 0; x < columns; x++) {
          final piece = img.copyCrop(
            image,
            x: x * pieceWidth,
            y: y * pieceHeight,
            width: pieceWidth,
            height: pieceHeight,
          );
          pieces.add(Uint8List.fromList(img.encodeJpg(piece, quality: 85)));
        }
      }

      return pieces;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> processImage(
      Uint8List imageBytes, String imageName, bool isAsset) async {
    state = state.copyWith(isLoading: true);
    profiler.reset(); // Réinitialiser le profiler

    try {
      // Mesurer l'optimisation de l'image
      profiler.start('image_optimization');
      final optimizedBytes = await simpleOptimizeImage(imageBytes);
      profiler.end('image_optimization');

      // Mesurer le décodage de l'image
      profiler.start('image_decoding');
      final image = img.decodeImage(optimizedBytes);
      if (image == null) throw Exception("Impossible de décoder l'image");
      profiler.end('image_decoding');

      final optimizedDimensions =
          Size(image.width.toDouble(), image.height.toDouble());

      state = state.copyWith(
        fullImage: optimizedBytes,
        optimizedImageDimensions: optimizedDimensions,
        currentImageName: imageName,
        currentImageTitle: imageName,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }
}

// Provider de traitement d'image
class ImageProcessingState {
  final bool isLoading;
  final String? error;
  final Uint8List? fullImage;
  final Size optimizedImageDimensions;
  final String currentImageName;
  final String currentImageTitle;

  ImageProcessingState({
    this.isLoading = false,
    this.error,
    this.fullImage,
    this.optimizedImageDimensions = Size.zero,
    this.currentImageName = '',
    this.currentImageTitle = '',
  });

  ImageProcessingState copyWith({
    bool? isLoading,
    String? error,
    Uint8List? fullImage,
    Size? optimizedImageDimensions,
    String? currentImageName,
    String? currentImageTitle,
  }) {
    return ImageProcessingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      fullImage: fullImage ?? this.fullImage,
      optimizedImageDimensions:
          optimizedImageDimensions ?? this.optimizedImageDimensions,
      currentImageName: currentImageName ?? this.currentImageName,
      currentImageTitle: currentImageTitle ?? this.currentImageTitle,
    );
  }
}
