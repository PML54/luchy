/// <cursor>
/// LUCHY - Contrôleur de gestion des images
///
/// Contrôleur principal pour toutes les opérations liées aux images
/// dans le jeu de puzzle Luchy avec gestion d'état Riverpod.
///
/// COMPOSANTS PRINCIPAUX:
/// - ImageController: StateNotifier principal pour gestion images
/// - loadRandomImage(): Chargement image aléatoire depuis assets
/// - pickImageFromGallery(): Sélection depuis galerie utilisateur
/// - captureImageFromCamera(): Capture photo via caméra
/// - _processAndInitializeGame(): Traitement et initialisation jeu
///
/// ÉTAT ACTUEL:
/// - Sources: Assets prédéfinis, galerie, caméra
/// - Processing: Optimisation taille, rotation EXIF, découpage pièces
/// - État: Stable avec gestion erreurs complète
/// - Performance: Optimisé pour grandes images
///
/// HISTORIQUE RÉCENT:
/// - Amélioration gestion erreurs et feedback utilisateur
/// - Optimisation traitement images et performance
/// - Intégration profiler pour monitoring performance
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Memory management: Dispose images après traitement
/// - EXIF rotation: Nécessaire pour photos caméra correctes
/// - Async operations: Bien gérer états loading/error
/// - File permissions: Caméra et galerie nécessitent autorisations
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter cache intelligent pour images traitées
/// - Optimiser algorithme découpage pièces
/// - Améliorer preview temps réel pendant traitement
/// - Considérer compression adaptative selon device
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: État du jeu
/// - core/utils/image_optimizer.dart: Utilitaires optimisation
/// - core/utils/profiler.dart: Monitoring performance
/// - core/constants/image_list.dart: Liste images prédéfinies
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur logique traitement images)
/// 📅 Dernière modification: 2025-08-25 15:00
/// </cursor>

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
// Constants
import 'package:luchy/core/constants/image_list.dart'; // Il semble que vous utilisiez imageList aussi
// Core imports

import 'package:luchy/core/utils/profiler.dart'; // Nouvel import
// Domain imports

import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';

/// Provider for the image controller
///
/// Usage:
/// ```dart
/// final controller = ref.watch(imageControllerProvider.notifier);
/// await controller.loadRandomImage();
/// ```
final imageControllerProvider =
    StateNotifierProvider<ImageController, ImageControllerState>((ref) {
  return ImageController(ref);
});

/// Controller handling image processing and management for the puzzle game.
///
/// Key responsibilities:
/// * Image loading from various sources (gallery, camera, assets)
/// * Image processing and optimization
/// * Puzzle piece creation
/// * Game state initialization with processed images
class ImageController extends StateNotifier<ImageControllerState> {
  final Ref ref;
  final ImagePicker _picker = ImagePicker();

  ImageController(this.ref) : super(ImageControllerState());

  /// Loads the opening image (Mathieu Sailor Man) with 2x2 puzzle
  Future<void> loadOpeningImage() async {
    state = ImageControllerState(isLoading: true);

    try {
      profiler.reset();
      profiler.start('loadOpeningImage');

      // Charger l'image d'ouverture spécifique
      const String assetPath = 'assets/mathieu_chanceux.png';
      final ByteData data = await rootBundle.load(assetPath);
      final imageBytes = data.buffer.asUint8List();

      // Forcer la difficulté à 2x2 pour l'image d'ouverture
      ref.read(gameSettingsProvider.notifier).setDifficulty(2, 2);

      // Process image and initialize game
      await ref
          .read(imageProcessingProvider.notifier)
          .processImage(imageBytes, 'Mathieu Chanceux', true);

      await _initializeGameWithProcessedImage();

      profiler.end('loadOpeningImage');
      state = ImageControllerState(isLoading: false);
    } catch (e) {
      state = ImageControllerState(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Loads a random image from the assets and prepares it for the puzzle.
  ///
  /// Process includes:
  /// * Random image selection from predefined list
  /// * Image loading and processing
  /// * Puzzle piece creation
  /// * Game state initialization
  ///
  /// Throws an error if image processing fails
  Future<void> loadRandomImage() async {
    state = ImageControllerState(isLoading: true);

    try {
      profiler.reset();
      profiler.start('loadRandomImage');

      // Image selection and processing
      final random = Random();
      final randomImage = imageList[random.nextInt(imageList.length)];
      final String assetPath = 'assets/${randomImage['file']}';
      final ByteData data = await rootBundle.load(assetPath);
      final imageBytes = data.buffer.asUint8List();

      // Process image and initialize game
      await ref
          .read(imageProcessingProvider.notifier)
          .processImage(imageBytes, randomImage['name']!, true);

      await _initializeGameWithProcessedImage();

      profiler.end('loadRandomImage');
      state = ImageControllerState(isLoading: false);
    } catch (e) {
      state = ImageControllerState(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Allows user to select an image from the device gallery.
  ///
  /// Process includes:
  /// * Gallery image picker launch
  /// * Selected image processing
  /// * Game initialization with selected image
  Future<void> pickImageFromGallery([BuildContext? context]) async {
    state = ImageControllerState(isLoading: true);

    try {
      debugPrint('📱 Ouverture de la galerie...');
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        debugPrint('📸 Image sélectionnée: ${image.name}, taille: ${await image.length()} bytes');
        await _processPickedImage(image, context);
      } else {
        // L'utilisateur a annulé la sélection
        debugPrint('❌ Sélection d\'image annulée par l\'utilisateur');
      }
      state = ImageControllerState(isLoading: false);
    } catch (e) {
      debugPrint('💥 Erreur lors de la sélection d\'image: $e');
      state = ImageControllerState(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Captures a photo using device camera for the puzzle.
  ///
  /// Features:
  /// * Image capture with quality settings
  /// * Automatic EXIF rotation handling
  /// * Image optimization for puzzle use
  Future<void> takePhoto([BuildContext? context]) async {
    state = ImageControllerState(isLoading: true);

    try {
      final XFile? imageFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );

      if (imageFile != null) {
        final File rotatedImage =
            await FlutterExifRotation.rotateImage(path: imageFile.path);
        final Uint8List rotatedBytes = await rotatedImage.readAsBytes();
        final String imageName =
            'Photo_${DateTime.now().toIso8601String()}.jpg';
        await _processImageBytes(rotatedBytes, imageName, false, context);
      } else {
        // L'utilisateur a annulé la prise de photo
        debugPrint('Prise de photo annulée par l\'utilisateur');
      }
      state = ImageControllerState(isLoading: false);
    } catch (e) {
      debugPrint('Erreur lors de la prise de photo: $e');
      state = ImageControllerState(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Processes raw image bytes and prepares them for puzzle use.
  ///
  /// Parameters:
  /// * [imageBytes] - Raw image data to process
  /// * [imageName] - Name/identifier for the image
  /// * [isAsset] - Whether the image is from assets or user selected
  /// * [context] - Build context for smart cropping (optional)
  Future<void> _processImageBytes(
      Uint8List imageBytes, String imageName, bool isAsset,
      [BuildContext? context]) async {
    try {
      // Vérification que les données d'entrée sont valides
      if (imageBytes.isEmpty) {
        throw Exception('Les données d\'image sont vides');
      }

      if (imageName.isEmpty) {
        throw Exception('Le nom de l\'image est vide');
      }

      debugPrint('Traitement de l\'image: $imageName (${imageBytes.length} bytes)');

      await ref.read(imageProcessingProvider.notifier).processImage(
            imageBytes,
            imageName,
            isAsset,
            context,
          );

      debugPrint('Image traitée avec succès, initialisation du jeu...');
      await _initializeGameWithProcessedImage();
      debugPrint('Jeu initialisé avec succès');

    } catch (e) {
      debugPrint('Erreur dans _processImageBytes: $e');
      rethrow;
    }
  }

  /// Initializes the game state with processed image.
  ///
  /// Creates puzzle pieces and sets up initial game state.
  Future<void> _initializeGameWithProcessedImage() async {
    final imageState = ref.read(imageProcessingProvider);

    // Vérifications de sécurité
    final fullImage = imageState.fullImage;
    final dimensions = imageState.optimizedImageDimensions;

    if (fullImage == null) {
      throw Exception('Image non disponible pour l\'initialisation du jeu après traitement');
    }

    if (dimensions == Size.zero || dimensions.width <= 0 || dimensions.height <= 0) {
      throw Exception('Dimensions d\'image invalides pour l\'initialisation du jeu');
    }

    final pieces =
        await ref.read(imageProcessingProvider.notifier).createPuzzlePieces(
              fullImage,
              ref.read(gameSettingsProvider).difficultyCols,
              ref.read(gameSettingsProvider).difficultyRows,
            );

    await ref.read(gameStateProvider.notifier).initializePuzzle(
          imageBytes: fullImage,
          pieces: pieces,
          columns: ref.read(gameSettingsProvider).difficultyCols,
          rows: ref.read(gameSettingsProvider).difficultyRows,
          imageSize: dimensions,
          shouldShuffle: true,
          puzzleType: ref.read(gameSettingsProvider).puzzleType,
          imageName: imageState.currentImageName,
        );
  }

  /// Processes a picked image file and prepares it for the puzzle.
  Future<void> _processPickedImage(XFile image, [BuildContext? context]) async {
    try {
      debugPrint('Lecture des bytes de l\'image: ${image.name}');
      final Uint8List imageBytes = await image.readAsBytes();

      if (imageBytes.isEmpty) {
        throw Exception('L\'image sélectionnée est vide');
      }

      debugPrint('Bytes lus avec succès: ${imageBytes.length} bytes');
      await _processImageBytes(imageBytes, image.name, false, context);
    } catch (e) {
      debugPrint('Erreur lors de la lecture de l\'image sélectionnée: $e');
      rethrow;
    }
  }

  /// Loads an educational image generated from text content
  ///
  /// This method bypasses the usual image processing pipeline since
  /// educational images are already optimized and ready for puzzle use.
  Future<void> loadEducationalImage(
    Uint8List imageBytes, {
    required int rows,
    required int columns,
    required String description,
    int puzzleType = 1, // Par défaut type classique
    List<int>? educationalMapping, // Mapping éducatif
  }) async {
    profiler.start('educational_image_load');
    state = state.copyWith(isLoading: true, error: null);
    debugPrint(
        '🎓 START: loadEducationalImage - imageController.isLoading = true');

    try {
      // Décoder l'image pour obtenir les dimensions
      final img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Impossible de décoder l\'image éducative');
      }

      final imageSize = Size(image.width.toDouble(), image.height.toDouble());

      // Mettre à jour l'état de traitement d'image avec l'image complète
      final imageProcessingNotifier =
          ref.read(imageProcessingProvider.notifier);
      imageProcessingNotifier.state = imageProcessingNotifier.state.copyWith(
        fullImage: imageBytes,
        optimizedImageDimensions: imageSize,
        isLoading: true, // Garder loading pendant createPuzzlePieces
      );
      debugPrint('🎓 imageProcessingProvider.isLoading = true');

      // Créer les pièces du puzzle avec la grille forcée
      final pieces = await ref
          .read(imageProcessingProvider.notifier)
          .createPuzzlePieces(imageBytes, columns, rows);

      // S'assurer que l'état loading est à false après createPuzzlePieces
      imageProcessingNotifier.state = imageProcessingNotifier.state.copyWith(
        isLoading: false,
      );
      debugPrint('🎓 imageProcessingProvider.isLoading = false');

      // Forcer les paramètres de difficulté selon la grille éducative
      ref.read(gameSettingsProvider.notifier).setDifficulty(columns, rows);

      // Initialiser le puzzle avec les paramètres éducatifs
      await ref.read(gameStateProvider.notifier).initializePuzzle(
            imageBytes: imageBytes,
            pieces: pieces,
            columns: columns,
            rows: rows,
            imageSize: imageSize,
            shouldShuffle: true,
            puzzleType: puzzleType,
            educationalMapping: educationalMapping,
            imageName: description,
          );

      profiler.end('educational_image_load');
      debugPrint('🎓 Image éducative chargée: $description (${columns}x$rows)');

      state = state.copyWith(isLoading: false);
      debugPrint('🎓 END: imageController.isLoading = false');
    } catch (e) {
      profiler.end('educational_image_load');
      debugPrint('❌ Erreur chargement image éducative: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement de l\'image éducative: $e',
      );
    }
  }
}

/// State class for the image controller.
///
/// Tracks:
/// * Loading state during image processing
/// * Error state and messages
class ImageControllerState {
  final bool isLoading;
  final String? error;

  ImageControllerState({
    this.isLoading = false,
    this.error,
  });

  /// Creates a new state instance with optional updated values.
  ImageControllerState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return ImageControllerState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
