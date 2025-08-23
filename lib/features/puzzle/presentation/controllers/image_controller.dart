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
/// </cursor>

import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Domain imports

import 'package:luchy/features/puzzle/domain/providers/game_providers.dart';
// Core imports

import 'package:luchy/core/utils/profiler.dart'; // Nouvel import

// Constants
import 'package:luchy/core/constants/image_list.dart'; // Il semble que vous utilisiez imageList aussi

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
  Future<void> pickImageFromGallery() async {
    state = ImageControllerState(isLoading: true);

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _processPickedImage(image);
      }
      state = ImageControllerState(isLoading: false);
    } catch (e) {
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
  Future<void> takePhoto() async {
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
        await _processImageBytes(rotatedBytes, imageName, false);
      }
      state = ImageControllerState(isLoading: false);
    } catch (e) {
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
  Future<void> _processImageBytes(
      Uint8List imageBytes, String imageName, bool isAsset) async {
    try {
      await ref.read(imageProcessingProvider.notifier).processImage(
            imageBytes,
            imageName,
            isAsset,
          );

      await _initializeGameWithProcessedImage();
    } catch (e) {
      rethrow;
    }
  }

  /// Initializes the game state with processed image.
  ///
  /// Creates puzzle pieces and sets up initial game state.
  Future<void> _initializeGameWithProcessedImage() async {
    final imageState = ref.read(imageProcessingProvider);
    if (imageState.fullImage != null) {
      final pieces =
          await ref.read(imageProcessingProvider.notifier).createPuzzlePieces(
                imageState.fullImage!,
                ref.read(gameSettingsProvider).difficultyCols,
                ref.read(gameSettingsProvider).difficultyRows,
              );

      await ref.read(gameStateProvider.notifier).initializePuzzle(
            imageBytes: imageState.fullImage!,
            pieces: pieces,
            columns: ref.read(gameSettingsProvider).difficultyCols,
            rows: ref.read(gameSettingsProvider).difficultyRows,
            imageSize: imageState.optimizedImageDimensions,
            shouldShuffle: true,
          );
    }
  }

  /// Processes a picked image file and prepares it for the puzzle.
  Future<void> _processPickedImage(XFile image) async {
    final Uint8List imageBytes = await image.readAsBytes();
    await _processImageBytes(imageBytes, image.name, false);
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
