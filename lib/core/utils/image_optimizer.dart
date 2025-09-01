/// <curseur>
/// LUCHY - Optimiseur d'images pour le puzzle
///
/// Utilitaire d'optimisation des images pour améliorer les performances
/// du jeu de puzzle en gérant la taille, qualité et recadrage intelligent.
///
/// COMPOSANTS PRINCIPAUX:
/// - smartOptimizeImage(): Optimisation complète avec recadrage adaptatif (contexte optionnel)
/// - simpleOptimizeImage(): Version simple sans recadrage (legacy)
/// - _resizeImage(): Redimensionnement avec préservation ratio
/// - Smart cropping: Recadrage selon ratios UI mesurés empiriquement
///
/// ÉTAT ACTUEL:
/// - Recadrage intelligent: Basé sur mesures iPhone réelles (1.90/0.37)
/// - Algorithmes: Redimensionnement bicubique haute qualité
/// - Optimisation: Calcul automatique taille optimale par appareil
/// - Performance: Optimisé pour devices mobiles, fallback gracieux sans contexte
///
/// HISTORIQUE RÉCENT:
/// - Intégration recadrage intelligent selon appareil/orientation
/// - Algorithme sans ajout de bandes (suppression uniquement)
/// - Configuration modulaire par type d'appareil
/// - Documentation mise à jour format <curseur>
///
/// 🔧 POINTS D'ATTENTION:
/// - Context optional: BuildContext pour recadrage intelligent (fallback automatique)
/// - Memory usage: Surveiller RAM pour très grandes images
/// - Content preservation: Minimiser perte de contenu important
/// - Quality vs size: Équilibrer qualité et performance
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter détection de visages pour centrage optimal
/// - Implémenter cache intelligent pour images optimisées
/// - Optimiser pour images très haute résolution
/// - Considérer machine learning pour zones importantes
///
/// 🔗 FICHIERS LIÉS:
/// - core/utils/smart_crop_config.dart: Configuration ratios par appareil
/// - core/utils/smart_crop_algorithm.dart: Algorithme recadrage
/// - features/puzzle/presentation/controllers/image_controller.dart: Intégration
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Performance critique + UX optimale)
/// 📅 Dernière modification: 2025-08-25 18:00
/// </curseur>

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'smart_crop_algorithm.dart';
import 'smart_crop_config.dart';

/// Résultat d'optimisation d'image avec informations de recadrage
class OptimizationResult {
  final Uint8List imageBytes;
  final int originalWidth;
  final int originalHeight;
  final int finalWidth;
  final int finalHeight;
  final bool wasCropped;
  final bool wasResized;
  final String optimizationInfo;

  const OptimizationResult({
    required this.imageBytes,
    required this.originalWidth,
    required this.originalHeight,
    required this.finalWidth,
    required this.finalHeight,
    required this.wasCropped,
    required this.wasResized,
    required this.optimizationInfo,
  });

  double get compressionRatio =>
      (originalWidth * originalHeight) / (finalWidth * finalHeight);

  @override
  String toString() {
    return 'Optimization: ${originalWidth}x${originalHeight} → ${finalWidth}x${finalHeight} '
        '(cropped: $wasCropped, resized: $wasResized)';
  }
}

/// Optimisation intelligente avec recadrage adaptatif selon l'appareil
Future<OptimizationResult> smartOptimizeImage(
  Uint8List imageBytes,
  BuildContext? context, {
  int maxDimension = 1024,
  int quality = 85,
  bool enableSmartCrop = true,
}) async {
  print('🚀 [IMAGE_OPTIMIZER] smartOptimizeImage called');
  print(
      '📊 [IMAGE_OPTIMIZER] Parameters: imageBytes.length=${imageBytes.length}, context=$context, enableSmartCrop=$enableSmartCrop');

  // Vérification des données d'entrée
  if (imageBytes.isEmpty) {
    print('❌ [IMAGE_OPTIMIZER] ERROR: Empty image bytes');
    throw Exception('Les données d\'image à optimiser sont vides');
  }

  final image = img.decodeImage(imageBytes);
  if (image == null) {
    throw Exception(
        "Impossible de décoder l'image - format non supporté ou données corrompues");
  }

  // Vérification des dimensions de base
  if (image.width <= 0 || image.height <= 0) {
    throw Exception('Dimensions d\'image invalides après décodage');
  }

  final originalWidth = image.width;
  final originalHeight = image.height;
  var processedImage = image;
  var wasCropped = false;
  var wasResized = false;
  var optimizationSteps = <String>[];

  // Étape 1: Recadrage intelligent selon l'appareil (si activé et contexte disponible)
  print('🔄 [IMAGE_OPTIMIZER] Step 1: Smart cropping check');
  print(
      '📋 [IMAGE_OPTIMIZER] enableSmartCrop=$enableSmartCrop, context=$context');

  if (enableSmartCrop && context != null) {
    print('✅ [IMAGE_OPTIMIZER] Smart cropping enabled and context available');

    // Vérifier si le contexte est encore valide
    if (context.debugDoingBuild || !context.mounted) {
      print('❌ [IMAGE_OPTIMIZER] Context is DEFUNCT, skipping smart cropping');
      optimizationSteps.add('Recadrage: Ignoré (contexte invalide)');
    } else {
      try {
        print('🎯 [IMAGE_OPTIMIZER] Calling SmartCropConfig.getRatioConfig...');
        final config = SmartCropConfig.getRatioConfig(context);
        print('✅ [IMAGE_OPTIMIZER] Config obtained: ${config.description}');

        print('🔍 [IMAGE_OPTIMIZER] Calculating optimal crop...');
        final cropResult = SmartCropAlgorithm.calculateOptimalCrop(
          originalWidth: originalWidth,
          originalHeight: originalHeight,
          config: config,
        );
        print(
            '✅ [IMAGE_OPTIMIZER] Crop result: ${cropResult.action}, needsCropping: ${cropResult.needsCropping}');

        if (cropResult.needsCropping) {
          print('✂️ [IMAGE_OPTIMIZER] Applying crop...');
          processedImage =
              SmartCropAlgorithm.applyCrop(processedImage, cropResult);
          wasCropped = true;
          optimizationSteps.add('Recadrage: ${cropResult.action}');
          print('✅ [IMAGE_OPTIMIZER] Crop applied successfully');
        } else {
          optimizationSteps.add('Recadrage: ${cropResult.action}');
          print('⏭️ [IMAGE_OPTIMIZER] No cropping needed');
        }
      } catch (e, stackTrace) {
        print('❌ [IMAGE_OPTIMIZER] ERROR in smart cropping: $e');
        print('🔍 [IMAGE_OPTIMIZER] Stack trace: $stackTrace');
        rethrow;
      }
    }
  } else if (enableSmartCrop && context == null) {
    print('⚠️ [IMAGE_OPTIMIZER] Smart cropping enabled but context is null');
    optimizationSteps.add('Recadrage: Ignoré (contexte indisponible)');
  } else {
    print('⏭️ [IMAGE_OPTIMIZER] Smart cropping disabled or skipped');
  }

  // Étape 2: Redimensionnement si nécessaire
  if (processedImage.width > maxDimension ||
      processedImage.height > maxDimension) {
    processedImage = _resizeImage(processedImage, maxDimension);
    wasResized = true;
    optimizationSteps.add(
        'Redimensionnement: ${processedImage.width}x${processedImage.height}');
  }

  // Étape 3: Encodage final
  final optimizedBytes =
      Uint8List.fromList(img.encodeJpg(processedImage, quality: quality));

  return OptimizationResult(
    imageBytes: optimizedBytes,
    originalWidth: originalWidth,
    originalHeight: originalHeight,
    finalWidth: processedImage.width,
    finalHeight: processedImage.height,
    wasCropped: wasCropped,
    wasResized: wasResized,
    optimizationInfo: optimizationSteps.join(' → '),
  );
}

/// Version simple sans recadrage intelligent (legacy)
Future<Uint8List> simpleOptimizeImage(Uint8List imageBytes) async {
  // Vérification des données d'entrée
  if (imageBytes.isEmpty) {
    throw Exception('Les données d\'image à optimiser sont vides');
  }

  final image = img.decodeImage(imageBytes);
  if (image == null) {
    throw Exception(
        "Impossible de décoder l'image - format non supporté ou données corrompues");
  }

  // Vérification des dimensions de l'image décodée
  if (image.width <= 0 || image.height <= 0) {
    throw Exception('Dimensions d\'image invalides après décodage');
  }

  // Ne redimensionner que si nécessaire, en préservant le ratio
  final processedImage =
      (image.width > 1024 || image.height > 1024) ? _resizeImage(image) : image;

  final optimizedBytes =
      Uint8List.fromList(img.encodeJpg(processedImage, quality: 85));

  // Vérification que l'encodage a produit des données
  if (optimizedBytes.isEmpty) {
    throw Exception('L\'encodage JPEG a produit des données vides');
  }

  return optimizedBytes;
}

img.Image _resizeImage(img.Image image, [int maxDimension = 1024]) {
  final ratio = image.width / image.height;
  int newWidth, newHeight;

  if (image.width > image.height) {
    newWidth = maxDimension;
    newHeight = (maxDimension / ratio).round();
  } else {
    newHeight = maxDimension;
    newWidth = (maxDimension * ratio).round();
  }

  return img.copyResize(
    image,
    width: newWidth,
    height: newHeight,
    interpolation: img.Interpolation.linear,
  );
}
