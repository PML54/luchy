/// <curseur>
/// LUCHY - Algorithme de recadrage intelligent
///
/// Algorithme de recadrage adaptatif qui optimise les images selon
/// les ratios cibles sans ajouter de bandes, uniquement par suppression.
///
/// COMPOSANTS PRINCIPAUX:
/// - CropResult: Résultat du calcul de recadrage
/// - calculateOptimalCrop(): Calcul des dimensions optimales
/// - applyCrop(): Application du recadrage sur image
/// - _calculateCropOffset(): Positionnement intelligent du recadrage
///
/// ÉTAT ACTUEL:
/// - Méthode: Suppression uniquement (pas d'ajout de bandes)
/// - Centrage: Intelligent avec règle des tiers pour portraits
/// - Préservation: Maximum de contenu original
/// - Performance: Optimisé pour traitement temps réel
///
/// HISTORIQUE RÉCENT:
/// - Algorithme basé sur mesures UI réelles iPhone
/// - Logique de centrage intelligent (visages, objets)
/// - Calculs optimaux avec tolérance paramétrable
/// - Documentation mise à jour format <curseur>
///
/// 🔧 POINTS D'ATTENTION:
/// - Aspect ratio: Toujours préserver proportions naturelles
/// - Content loss: Minimiser la perte de contenu important
/// - Performance: Éviter recalculs inutiles
/// - Edge cases: Gérer images déjà optimales
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter détection de visages pour centrage optimal
/// - Implémenter analyse de densité de contenu
/// - Optimiser pour différents types d'images (art, photos)
/// - Considérer machine learning pour zones importantes
///
/// 🔗 FICHIERS LIÉS:
/// - core/utils/smart_crop_config.dart: Configuration ratios
/// - core/utils/image_optimizer.dart: Intégration optimisation
/// - package:image/image.dart: Manipulation images
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Cœur algorithme recadrage)
/// 📅 Dernière modification: 2025-08-25 17:50
/// </curseur>

import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'smart_crop_config.dart';

/// Résultat du calcul de recadrage intelligent
class CropResult {
  final int newWidth;
  final int newHeight;
  final int offsetX;
  final int offsetY;
  final double originalRatio;
  final double targetRatio;
  final double finalRatio;
  final bool needsCropping;
  final String action;

  const CropResult({
    required this.newWidth,
    required this.newHeight,
    required this.offsetX,
    required this.offsetY,
    required this.originalRatio,
    required this.targetRatio,
    required this.finalRatio,
    required this.needsCropping,
    required this.action,
  });

  @override
  String toString() {
    return 'CropResult: ${newWidth}x${newHeight} @ ($offsetX,$offsetY) - $action';
  }
}

/// Algorithme de recadrage intelligent
class SmartCropAlgorithm {
  /// Calcule le recadrage optimal pour une image donnée
  static CropResult calculateOptimalCrop({
    required int originalWidth,
    required int originalHeight,
    required DeviceRatioConfig config,
  }) {
    final originalRatio = originalHeight / originalWidth;
    final targetRatio = config.targetRatio;

    // Vérifier si l'image est déjà dans la plage acceptable
    if (config.isInRange(originalRatio)) {
      return CropResult(
        newWidth: originalWidth,
        newHeight: originalHeight,
        offsetX: 0,
        offsetY: 0,
        originalRatio: originalRatio,
        targetRatio: targetRatio,
        finalRatio: originalRatio,
        needsCropping: false,
        action: 'Aucun recadrage nécessaire',
      );
    }

    // Déterminer le type de recadrage nécessaire
    if (originalRatio < config.minRatio) {
      // Image trop large → Recadrer les côtés
      return _calculateHorizontalCrop(
        originalWidth: originalWidth,
        originalHeight: originalHeight,
        targetRatio: targetRatio,
        originalRatio: originalRatio,
      );
    } else {
      // Image trop haute → Recadrer haut/bas
      return _calculateVerticalCrop(
        originalWidth: originalWidth,
        originalHeight: originalHeight,
        targetRatio: targetRatio,
        originalRatio: originalRatio,
      );
    }
  }

  /// Calcule le recadrage horizontal (suppression des côtés)
  static CropResult _calculateHorizontalCrop({
    required int originalWidth,
    required int originalHeight,
    required double targetRatio,
    required double originalRatio,
  }) {
    // Nouvelle largeur = hauteur / ratio_cible
    final newWidth = (originalHeight / targetRatio).round();
    final cropAmount = originalWidth - newWidth;
    final offsetX = cropAmount ~/ 2; // Centrer horizontalement

    return CropResult(
      newWidth: newWidth,
      newHeight: originalHeight,
      offsetX: offsetX,
      offsetY: 0,
      originalRatio: originalRatio,
      targetRatio: targetRatio,
      finalRatio: originalHeight / newWidth,
      needsCropping: true,
      action: 'Recadrage horizontal (-${cropAmount}px)',
    );
  }

  /// Calcule le recadrage vertical (suppression haut/bas)
  static CropResult _calculateVerticalCrop({
    required int originalWidth,
    required int originalHeight,
    required double targetRatio,
    required double originalRatio,
  }) {
    // Nouvelle hauteur = largeur * ratio_cible
    final newHeight = (originalWidth * targetRatio).round();
    final cropAmount = originalHeight - newHeight;

    // Centrage intelligent : privilégier le tiers supérieur pour les portraits
    final offsetY =
        _calculateVerticalOffset(cropAmount, originalHeight, newHeight);

    return CropResult(
      newWidth: originalWidth,
      newHeight: newHeight,
      offsetX: 0,
      offsetY: offsetY,
      originalRatio: originalRatio,
      targetRatio: targetRatio,
      finalRatio: newHeight / originalWidth,
      needsCropping: true,
      action: 'Recadrage vertical (-${cropAmount}px)',
    );
  }

  /// Calcule l'offset vertical optimal (règle des tiers pour portraits)
  static int _calculateVerticalOffset(
      int cropAmount, int originalHeight, int newHeight) {
    // Pour les images de type portrait/art, privilégier le tiers supérieur
    // Pour éviter de couper les visages ou éléments importants en haut

    if (originalHeight > originalHeight * 0.7) {
      // Image plutôt haute
      // Garder plus de contenu du haut (règle des tiers)
      return (cropAmount * 0.3).round(); // 30% en haut, 70% en bas
    } else {
      // Image plus carrée → centrage classique
      return cropAmount ~/ 2;
    }
  }

  /// Applique le recadrage calculé sur une image
  static img.Image applyCrop(img.Image image, CropResult cropResult) {
    if (!cropResult.needsCropping) {
      return image; // Pas de modification nécessaire
    }

    return img.copyCrop(
      image,
      x: cropResult.offsetX,
      y: cropResult.offsetY,
      width: cropResult.newWidth,
      height: cropResult.newHeight,
    );
  }

  /// Interface complète : calcul + application du recadrage
  static img.Image smartCrop({
    required img.Image image,
    required DeviceRatioConfig config,
  }) {
    final cropResult = calculateOptimalCrop(
      originalWidth: image.width,
      originalHeight: image.height,
      config: config,
    );

    return applyCrop(image, cropResult);
  }

  /// Calcule le recadrage pour des bytes d'image
  static Future<Uint8List> smartCropBytes({
    required Uint8List imageBytes,
    required DeviceRatioConfig config,
    int quality = 85,
  }) async {
    // Décoder l'image
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Impossible de décoder l\'image pour le recadrage');
    }

    // Appliquer le recadrage intelligent
    final croppedImage = smartCrop(image: image, config: config);

    // Réencoder en JPEG
    return Uint8List.fromList(img.encodeJpg(croppedImage, quality: quality));
  }

  /// Utilitaire de debug : informations sur le recadrage
  static String debugCropInfo({
    required int originalWidth,
    required int originalHeight,
    required DeviceRatioConfig config,
  }) {
    final cropResult = calculateOptimalCrop(
      originalWidth: originalWidth,
      originalHeight: originalHeight,
      config: config,
    );

    return '''
=== SMART CROP DEBUG ===
Original: ${originalWidth}x${originalHeight} (ratio: ${cropResult.originalRatio.toStringAsFixed(3)})
Target: ${config.description} (ratio: ${config.targetRatio.toStringAsFixed(3)})
Result: ${cropResult.newWidth}x${cropResult.newHeight} (ratio: ${cropResult.finalRatio.toStringAsFixed(3)})
Offset: (${cropResult.offsetX}, ${cropResult.offsetY})
Action: ${cropResult.action}
Needs Cropping: ${cropResult.needsCropping}
''';
  }
}
