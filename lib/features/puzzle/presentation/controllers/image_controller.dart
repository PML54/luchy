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
/// - Mon Sep 29 08:09: CORRECTION FILTRAGE PORTRAIT - Ajout dimensions nouvelles images
/// - Ajout de toutes les nouvelles images dans le dictionnaire _isPortraitImage()
/// - Correction des extensions .png vers .jpg (mathieu_chanceux, mathieu_sailor_man)
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
/// 📅 Dernière modification: Mon Sep 29 08:09:00 CEST 2025
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
      const String assetPath = 'assets/mathieu_chanceux.jpg';
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
  /// * Random image selection from predefined list (filtered by orientation if portrait)
  /// * Image loading and processing
  /// * Puzzle piece creation
  /// * Game state initialization
  /// * Forces 3x3 grid size for random images
  ///
  /// Throws an error if image processing fails
  Future<void> loadRandomImage([BuildContext? context]) async {
    state = ImageControllerState(isLoading: true);

    try {
      profiler.reset();
      profiler.start('loadRandomImage');

      // Forcer la difficulté à 3x3 pour les images aléatoires
      ref.read(gameSettingsProvider.notifier).setDifficulty(3, 3);

      // Filtrer les images selon l'orientation de l'écran
      final filteredImages = _getImagesForCurrentOrientation(context);

      // Image selection and processing
      final random = Random();
      final randomImage = filteredImages[random.nextInt(filteredImages.length)];
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
    print(
        '🖼️ [IMAGE_CONTROLLER] pickImageFromGallery called with context: $context');

    state = ImageControllerState(isLoading: true);

    try {
      debugPrint('📱 Ouverture de la galerie...');
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        debugPrint(
            '📸 Image sélectionnée: ${image.name}, taille: ${await image.length()} bytes');
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

      debugPrint(
          'Traitement de l\'image: $imageName (${imageBytes.length} bytes)');

      print(
          '🎨 [IMAGE_CONTROLLER] Calling processImage with context: $context');
      await ref.read(imageProcessingProvider.notifier).processImage(
            imageBytes,
            imageName,
            isAsset,
            context,
          );
      print('✅ [IMAGE_CONTROLLER] processImage completed successfully');

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
      throw Exception(
          'Image non disponible pour l\'initialisation du jeu après traitement');
    }

    if (dimensions == Size.zero ||
        dimensions.width <= 0 ||
        dimensions.height <= 0) {
      throw Exception(
          'Dimensions d\'image invalides pour l\'initialisation du jeu');
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

  /// Filtre les images selon l'orientation de l'écran
  /// En mode portrait iPhone : sélectionne seulement les images plus hautes que larges
  List<Map<String, String>> _getImagesForCurrentOrientation(
      BuildContext? context) {
    // Si pas de contexte, retourner toutes les images
    if (context == null) return imageList;

    // Vérifier l'orientation de l'écran
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final isPhone = mediaQuery.size.shortestSide < 600; // iPhone/petit écran

    // Si iPhone en portrait, filtrer pour images portrait (hauteur > largeur)
    if (isPortrait && isPhone) {
      final portraitImages = imageList.where((image) {
        final fileName = image['file']!;
        return _isPortraitImage(fileName);
      }).toList();

      // Si aucune image portrait trouvée, retourner toutes les images
      return portraitImages.isNotEmpty ? portraitImages : imageList;
    }

    // Sinon, retourner toutes les images
    return imageList;
  }

  /// Détermine si une image est en orientation portrait (hauteur > largeur)
  bool _isPortraitImage(String fileName) {
    // Dimensions connues des images (basées sur identify)
    final imageDimensions = {
      // Art classique conservé
      'mona_lisa_vinci.jpg': (685, 1024), // Portrait ✅

      // Illustrations diverses
      'popeye.jpg': (412, 612), // Portrait ✅

      // Mathieu (présentation)
      'mathieu_chanceux.jpg': (1024, 1536), // Portrait ✅
      'mathieu_sailor_man.jpg': (1024, 1536), // Portrait ✅

      // Collection Épicerie DALL-E (toutes portrait)
      'epicerie-02.jpg': (1024, 1792), // Portrait ✅
      'epicerie-04.jpg': (1024, 1792), // Portrait ✅ (estimé)
      'epicerie-05.jpg': (1024, 1792), // Portrait ✅ (estimé)
      'epicerie-06.jpg': (1024, 1792), // Portrait ✅ (estimé)
      'epicerie-07.jpg': (1024, 1792), // Portrait ✅ (estimé)
      'epicerie-08.jpg': (1024, 1792), // Portrait ✅ (estimé)
      'epicerie-09.jpg': (1024, 1792), // Portrait ✅ (estimé)
      'epicerie-10.jpg': (1024, 1792), // Portrait ✅ (estimé)
      'epicerie-11.jpg': (1024, 1792), // Portrait ✅ (estimé)
      'epicerie-12.jpg': (1024, 1792), // Portrait ✅
      'epicerie-13.jpg': (1024, 1792), // Portrait ✅
      'epicerie-14.jpg': (1024, 1792), // Portrait ✅
      'epicerie-15.jpg': (1024, 1792), // Portrait ✅
      'epicerie-16.jpg': (1024, 1792), // Portrait ✅
      'epicerie-18.jpg': (1024, 1792), // Portrait ✅
      'epicerie-19.jpg': (1024, 1792), // Portrait ✅
      'epicerie-20.jpg': (1024, 1792), // Portrait ✅
      'epicerie-21.jpg': (1024, 1792), // Portrait ✅
      'epicerie-22.jpg': (1024, 1792), // Portrait ✅
      'epicerie-23.jpg': (1024, 1792), // Portrait ✅
      'epicerie-25.jpg': (1024, 1792), // Portrait ✅
      'epicerie-26.jpg': (1024, 1792), // Portrait ✅
      'epicerie-27.jpg': (1024, 1792), // Portrait ✅
      'epicerie-28.jpg': (1024, 1792), // Portrait ✅
      'epicerie-29.jpg': (1024, 1792), // Portrait ✅
      'epicerie-30.jpg': (1024, 1792), // Portrait ✅
      'epicerie-33.jpg': (1024, 1792), // Portrait ✅
      'epicerie-34.jpg': (1024, 1792), // Portrait ✅
      'epicerie-35.jpg': (1024, 1792), // Portrait ✅
      'epicerie-36.jpg': (1024, 1792), // Portrait ✅
      'epicerie-39.jpg': (1024, 1792), // Portrait ✅
      'epicerie-40.jpg': (1024, 1792), // Portrait ✅
      'epicerie-41.jpg': (1024, 1792), // Portrait ✅
      'epicerie-43.jpg': (1024, 1792), // Portrait ✅
      'epicerie-45.jpg': (1024, 1792), // Portrait ✅

      // Images artistiques (Picasso, Van Gogh)
      'Picasso-FemmeAssiseAuBraceletMontre.jpg': (810, 1112), // Portrait ✅
      'Picasso-FemmeTenantUnLivre.jpg': (810, 1112), // Portrait ✅ (estimé)
      'VVG-10.jpg': (497, 614), // Portrait ✅

      // Images personnelles et familiales
      'eva - 1.jpeg': (768, 1024), // Portrait ✅
      'clemchat - 1.jpeg': (768, 1024), // Portrait ✅ (estimé)
      '2cv - 1.jpeg': (768, 1024), // Portrait ✅ (estimé)
      'HISTOIRE-CE1 - 3.jpeg': (768, 1024), // Portrait ✅ (estimé)

      // Images de personnages et mascottes
      'pokemon9.jpg': (1024, 1536), // Portrait ✅ (estimé)

      // Images de l'app et icônes
      'icartuzz.jpg': (1024, 1536), // Portrait ✅ (estimé)
      'luchy_village_sign.jpg': (1024, 1536), // Portrait ✅ (estimé)
    };

    final dimensions = imageDimensions[fileName];
    if (dimensions == null) return false; // Image inconnue = paysage par défaut

    final (width, height) = dimensions;
    return height > width; // Portrait si hauteur > largeur
  }

  /// Processes a picked image file and prepares it for the puzzle.
  Future<void> _processPickedImage(XFile image, [BuildContext? context]) async {
    print(
        '📂 [IMAGE_CONTROLLER] _processPickedImage called with context: $context');
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
