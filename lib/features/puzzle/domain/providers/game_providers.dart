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
/// - 2025-01-08: Ajout types de puzzles éducatifs (type 2)
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
/// - Étendre système types puzzles (type 3, 4, etc.)
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
/// 📅 Dernière modification: 2025-08-25 14:42
/// </cursor>
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

import 'package:luchy/core/utils/image_optimizer.dart';
import 'package:luchy/core/utils/profiler.dart';
import 'package:luchy/features/puzzle/domain/models/game_state.dart';
import 'package:luchy/features/puzzle/domain/models/image_processing_data.dart';

final gameSettingsProvider =
    StateNotifierProvider<GameSettingsNotifier, GameSettings>((ref) {
  return GameSettingsNotifier(ref);
});

// Provider pour charger les paramètres de façon asynchrone
final gameSettingsLoadedProvider = FutureProvider<GameSettings>((ref) async {
  final notifier = ref.read(gameSettingsProvider.notifier);
  await notifier.ensureLoaded();
  return ref.read(gameSettingsProvider);
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
  final Ref ref;
  bool _isLoaded = false;
  Future<void>? _loadingFuture;

  GameSettingsNotifier(this.ref) : super(GameSettings.initial()) {
    _loadingFuture = _loadSettingsFromDatabase();
  }

  Future<void> ensureLoaded() async {
    if (!_isLoaded && _loadingFuture != null) {
      await _loadingFuture;
    }
  }

  Future<void> _loadSettingsFromDatabase() async {
    if (_isLoaded) return;

    // ⚠️ CHARGEMENT BASE DE DONNÉES TEMPORAIREMENT DÉSACTIVÉ
    print('⏸️ Chargement SQLite désactivé - utilisation valeurs par défaut');
    
    // Utiliser les valeurs par défaut de GameSettings.initial()
    _isLoaded = true;
    print('✅ GameSettings initialisés avec valeurs par défaut');
    
    // Code de chargement SQLite commenté
    /*
    try {
      final repository = ref.read(gameSettingsRepositoryProvider);
      final dbSettings = await repository.getSettings();

      print(
          '🗃️ SQLite settings loaded: ${dbSettings.difficultyCols}x${dbSettings.difficultyRows}');

      // Convertir les paramètres SQLite vers le modèle Freezed
      state = state.copyWith(
        difficultyCols: dbSettings.difficultyCols,
        difficultyRows: dbSettings.difficultyRows,
        useCustomGridSize: dbSettings.useCustomGridSize,
        hasSeenDocumentation: dbSettings.hasSeenDocumentation,
        puzzleType: dbSettings.puzzleType,
      );

      _isLoaded = true;
      print('✅ GameSettings state updated with SQLite data');
    } catch (e) {
      // En cas d'erreur, garder les valeurs par défaut
      print('❌ Erreur chargement paramètres SQLite: $e');
      _isLoaded = true; // Marquer comme chargé même en cas d'erreur
    }
    */
  }

  Future<void> resetToDefaultDifficulty() async {
    state = state.copyWith(
      difficultyCols: 3,
      difficultyRows: 3,
      useCustomGridSize: false,
    );

    // Sauvegarder en base
    await _saveToDatabase();
  }

  Future<void> setDifficulty(int cols, int rows) async {
    state = state.copyWith(
      difficultyCols: cols,
      difficultyRows: rows,
      useCustomGridSize: true,
    );

    // Sauvegarder en base
    await _saveToDatabase();
  }

  Future<void> markDocumentationSeen() async {
    if (!state.hasSeenDocumentation) {
      state = state.copyWith(hasSeenDocumentation: true);
      await _saveToDatabase();
    }
  }

  Future<void> setPuzzleType(int type) async {
    state = state.copyWith(puzzleType: type);
    await _saveToDatabase();
  }

  Future<void> _saveToDatabase() async {
    // ⚠️ SAUVEGARDE TEMPORAIREMENT DÉSACTIVÉE
    print('⏸️ Sauvegarde désactivée temporairement');
    return;

    // Code de sauvegarde commenté
    /*
    try {
      final repository = ref.read(gameSettingsRepositoryProvider);
      final dbSettings = GameSettingsDb(
        difficultyRows: state.difficultyRows,
        difficultyCols: state.difficultyCols,
        useCustomGridSize: state.useCustomGridSize,
        hasSeenDocumentation: state.hasSeenDocumentation,
        puzzleType: state.puzzleType,
      );

      print(
          '💾 Saving to SQLite: ${dbSettings.difficultyCols}x${dbSettings.difficultyRows}');
      await repository.saveSettings(dbSettings);
      print('✅ SQLite save completed');
    } catch (e) {
      print('❌ Erreur sauvegarde paramètres SQLite: $e');
    }
    */
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

  /// Compte le nombre de correspondances éducatives correctes (pour puzzles type 2 et 3)
  /// Retourne le nombre de lignes où les éléments des colonnes 1 et 2 correspondent
  int countCorrectEducationalCorrespondences() {
    if (!state.isInitialized ||
        (state.puzzleType != 2 && state.puzzleType != 3)) {
      return 0;
    }

    int correctCorrespondences = 0;
    for (int row = 0; row < state.rows; row++) {
      if (_isRowComplete(row)) {
        correctCorrespondences++;
      }
    }
    return correctCorrespondences;
  }

  /// Calcule le temps écoulé depuis le début du puzzle éducatif
  Duration getElapsedTime() {
    if (state.startTime == null) {
      return Duration.zero;
    }
    return DateTime.now().difference(state.startTime!);
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
    int puzzleType = 1, // Par défaut type classique
    List<int>? educationalMapping, // Mapping original pour puzzles éducatifs
    String? imageName, // Nom de l'image pour messages personnalisés
  }) async {
    final initialArrangement =
        List<int>.generate(pieces.length, (index) => index);
    List<int> shuffledArrangement;

    if (shouldShuffle) {
      // Choix de l'algorithme de mélange selon le type
      switch (puzzleType) {
        case 2:
          shuffledArrangement = _createType2ShuffledArrangement(columns, rows);
          break;
        case 3: // Puzzles de combinaisons
          shuffledArrangement = _createType2ShuffledArrangement(columns, rows);
          break;
        default:
          shuffledArrangement = _createShuffledArrangement(pieces.length);
      }
    } else {
      shuffledArrangement = List<int>.from(initialArrangement);
    }

    // Démarrer le chronométrage pour les puzzles éducatifs
    final startTime =
        (puzzleType == 2 || puzzleType == 3) ? DateTime.now() : null;

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
      puzzleType: puzzleType,
      educationalMapping: educationalMapping,
      startTime: startTime,
      currentImageName: imageName,
    );
  }

  bool isGameComplete() {
    if (!state.isInitialized) return false;

    // Vérification selon le type de puzzle
    switch (state.puzzleType) {
      case 2:
        return _isType2Complete();
      case 3: // Puzzles de combinaisons - même logique que type 2
        return _isType2Complete();
      default:
        return state.currentArrangement
            .asMap()
            .entries
            .every((entry) => entry.value == entry.key);
    }
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

    List<int> newArrangement;
    switch (state.puzzleType) {
      case 2:
        newArrangement =
            _createType2ShuffledArrangement(state.columns, state.rows);
        break;
      default:
        newArrangement = _createShuffledArrangement(state.pieces.length);
    }

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

  // ============ MÉTHODES SPÉCIFIQUES AU TYPE 2 (ÉDUCATIF) ============

  /// Crée un arrangement mélangé pour le type 2 : mélange uniquement la colonne 2 (droite)
  /// La colonne 1 (gauche) reste fixe pour garder la correspondance éducative
  List<int> _createType2ShuffledArrangement(int columns, int rows) {
    final arrangement = List<int>.generate(columns * rows, (index) => index);
    final random = Random();

    // Extraire les indices de la colonne 2 (droite)
    final column2Indices = <int>[];
    for (int row = 0; row < rows; row++) {
      column2Indices.add(row * columns + 1); // Colonne 2 (index 1)
    }

    // Mélanger seulement les valeurs de la colonne 2
    final column2Values =
        column2Indices.map((index) => arrangement[index]).toList();
    column2Values.shuffle(random);

    // Remettre les valeurs mélangées dans la colonne 2
    for (int i = 0; i < column2Indices.length; i++) {
      arrangement[column2Indices[i]] = column2Values[i];
    }

    return arrangement;
  }

  /// Vérifie si le puzzle type 2 est complété
  /// Pour le type 2 : les éléments en vis-à-vis (sur chaque ligne) doivent avoir
  /// le même numéro d'ordre initial selon le mapping éducatif
  bool _isType2Complete() {
    for (int row = 0; row < state.rows; row++) {
      if (!_isRowComplete(row)) {
        return false;
      }
    }
    return true;
  }

  /// Vérifie si une ligne spécifique est complète pour le type 2
  /// La ligne est complète si les éléments en vis-à-vis ont le même numéro d'ordre initial
  bool _isRowComplete(int row) {
    if (state.columns < 2) {
      return false;
    }

    final col1Index = row * state.columns + 0; // Colonne 1 (gauche)
    final col2Index = row * state.columns + 1; // Colonne 2 (droite)

    // Si nous avons un mapping éducatif, l'utiliser
    if (state.educationalMapping != null) {
      // Récupérer les pièces actuelles sur cette ligne
      final currentCol1Piece = state.currentArrangement[col1Index];
      final currentCol2Piece = state.currentArrangement[col2Index];

      // Trouver les numéros d'ordre initial de ces pièces
      final originalOrderCol1 = _findOriginalOrder(currentCol1Piece);
      final originalOrderCol2 = _findOriginalOrder(currentCol2Piece);

      // Vérifier si ces pièces correspondent selon le mapping éducatif
      return originalOrderCol1 != null &&
          originalOrderCol2 != null &&
          state.educationalMapping![originalOrderCol1] ==
              state.educationalMapping![originalOrderCol2];
    } else {
      // Pour les puzzles éducatifs simples sans mapping,
      // vérifier que les pièces sont simplement à leur position correcte
      return state.currentArrangement[col1Index] == col1Index &&
          state.currentArrangement[col2Index] == col2Index;
    }
  }

  /// Trouve le numéro d'ordre initial d'une pièce donnée
  int? _findOriginalOrder(int pieceValue) {
    // Convertir l'index de pièce en coordonnées
    final pieceRow = pieceValue ~/ state.columns;

    // Pour les puzzles éducatifs, on considère que chaque ligne correspond à un élément
    // L'ordre initial est déterminé par la ligne
    return pieceRow;
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
    int rows, {
    double? ratioLargeurColonnes, // Ratio pour largeurs dynamiques
  }) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) throw Exception("Impossible de décoder l'image");

      final pieces = <Uint8List>[];
      final pieceHeight = image.height ~/ rows;

      // Calcul des largeurs selon le ratio (pour puzzles éducatifs)
      if (ratioLargeurColonnes != null && columns == 2) {
        // Largeurs dynamiques pour puzzles éducatifs
        final leftWidth = (image.width * ratioLargeurColonnes).round();
        final rightWidth = image.width - leftWidth;

        for (var y = 0; y < rows; y++) {
          // Colonne gauche (largeur dynamique)
          final leftPiece = img.copyCrop(
            image,
            x: 0,
            y: y * pieceHeight,
            width: leftWidth,
            height: pieceHeight,
          );
          pieces.add(Uint8List.fromList(img.encodeJpg(leftPiece, quality: 85)));

          // Colonne droite (largeur dynamique)
          final rightPiece = img.copyCrop(
            image,
            x: leftWidth,
            y: y * pieceHeight,
            width: rightWidth,
            height: pieceHeight,
          );
          pieces
              .add(Uint8List.fromList(img.encodeJpg(rightPiece, quality: 85)));
        }
      } else {
        // Découpage uniforme classique
        final pieceWidth = image.width ~/ columns;

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
      }

      return pieces;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> processImage(
      Uint8List imageBytes, String imageName, bool isAsset,
      [BuildContext? context]) async {
    state = state.copyWith(isLoading: true);
    profiler.reset(); // Réinitialiser le profiler

    try {
      // Vérification des données d'entrée
      if (imageBytes.isEmpty) {
        throw Exception('Les données d\'image sont vides');
      }

      debugPrint('🔄 Début traitement image: $imageName (${imageBytes.length} bytes)');

      // Mesurer l'optimisation de l'image
      profiler.start('image_optimization');

      Uint8List optimizedBytes;
      String optimizationInfo = '';

      if (context != null) {
        // Utiliser le recadrage intelligent si contexte disponible
        debugPrint('🧠 Utilisation optimisation intelligente');
        final result = await smartOptimizeImage(imageBytes, context);
        optimizedBytes = result.imageBytes;
        optimizationInfo = result.optimizationInfo;
        debugPrint('🔧 Smart Optimization: $optimizationInfo');
      } else {
        // Fallback vers optimisation simple
        debugPrint('🔧 Utilisation optimisation simple (pas de contexte)');
        optimizedBytes = await simpleOptimizeImage(imageBytes);
        optimizationInfo = 'Optimisation simple (pas de contexte)';
        debugPrint('🔧 Simple Optimization: Legacy mode');
      }

      // Vérification que l'optimisation a produit des données valides
      if (optimizedBytes.isEmpty) {
        throw Exception('L\'optimisation de l\'image a produit des données vides');
      }

      profiler.end('image_optimization');
      debugPrint('✅ Optimisation terminée: ${optimizedBytes.length} bytes');

      // Mesurer le décodage de l'image
      profiler.start('image_decoding');
      debugPrint('🔄 Début décodage image');
      final image = img.decodeImage(optimizedBytes);
      if (image == null) {
        throw Exception("Impossible de décoder l'image optimisée - format non supporté ou données corrompues");
      }
      profiler.end('image_decoding');
      debugPrint('✅ Décodage réussi: ${image.width}x${image.height}');

      final optimizedDimensions =
          Size(image.width.toDouble(), image.height.toDouble());

      // Vérification des dimensions
      if (optimizedDimensions.width <= 0 || optimizedDimensions.height <= 0) {
        throw Exception('Dimensions d\'image invalides après optimisation');
      }

      state = state.copyWith(
        fullImage: optimizedBytes,
        optimizedImageDimensions: optimizedDimensions,
        currentImageName: imageName,
        currentImageTitle: imageName,
        isLoading: false,
      );

      debugPrint(
          '✅ Image optimisée: ${optimizedDimensions.width}x${optimizedDimensions.height}');
    } catch (e) {
      debugPrint('❌ Erreur dans processImage: $e');
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
