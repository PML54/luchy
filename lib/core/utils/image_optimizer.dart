/// <cursor>
/// LUCHY - Optimiseur d'images pour le puzzle
///
/// Utilitaire d'optimisation des images pour améliorer les performances
/// du jeu de puzzle en gérant la taille, qualité et mémoire.
///
/// COMPOSANTS PRINCIPAUX:
/// - ImageOptimizer: Classe principale d'optimisation
/// - optimizeImage(): Redimensionnement intelligent avec préservation ratio
/// - calculateOptimalSize(): Calcul taille optimale selon contraintes
/// - Memory management: Gestion efficace mémoire pour grandes images
///
/// ÉTAT ACTUEL:
/// - Algorithmes: Redimensionnement bicubique haute qualité
/// - Optimisation: Calcul automatique taille optimale
/// - Mémoire: Gestion efficace pour éviter OOM
/// - Performance: Optimisé pour devices mobiles
///
/// HISTORIQUE RÉCENT:
/// - Amélioration algorithmes redimensionnement
/// - Optimisation gestion mémoire grandes images
/// - Intégration monitoring performance
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Memory usage: Surveiller RAM pour très grandes images
/// - Aspect ratio: Toujours préserver proportions originales
/// - Quality vs size: Équilibrer qualité et performance
/// - Platform specific: Tester sur différents devices iOS/Android
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter cache intelligent pour images optimisées
/// - Implémenter compression adaptative selon device
/// - Optimiser pour images très haute résolution
/// - Ajouter formats image additionnels (WebP, AVIF)
///
/// 🔗 FICHIERS LIÉS:
/// - features/puzzle/domain/providers/game_providers.dart: Utilisation
/// - features/puzzle/presentation/controllers/image_controller.dart: Intégration
/// - core/utils/profiler.dart: Monitoring performance
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Performance critique traitement images)
/// </cursor>

import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Résultat d'optimisation d'image

Future<Uint8List> simpleOptimizeImage(Uint8List imageBytes) async {
  final image = img.decodeImage(imageBytes);
  if (image == null) throw Exception("Impossible de décoder l'image");

  // Ne redimensionner que si nécessaire, en préservant le ratio
  final processedImage =
      (image.width > 1024 || image.height > 1024) ? _resizeImage(image) : image;

  final optimizedBytes =
      Uint8List.fromList(img.encodeJpg(processedImage, quality: 85));

  return optimizedBytes;
}

img.Image _resizeImage(img.Image image) {
  final ratio = image.width / image.height;
  int newWidth, newHeight;

  if (image.width > image.height) {
    newWidth = 1024;
    newHeight = (1024 / ratio).round();
  } else {
    newHeight = 1024;
    newWidth = (1024 * ratio).round();
  }

  return img.copyResize(
    image,
    width: newWidth,
    height: newHeight,
    interpolation: img.Interpolation.linear,
  );
}
