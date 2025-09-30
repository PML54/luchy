/// <cursor>
/// LUCHY - Configuration principale de l'application
///
/// Fichier de configuration central pour l'application Luchy gérant
/// les environnements, paramètres et configurations système.
///
/// COMPOSANTS PRINCIPAUX:
/// - Environment: Enum pour dev/staging/production
/// - ImageConfig: Configuration traitement images (max size, qualité)
/// - AppConfig: Configuration globale application
/// - configProvider: Provider Riverpod pour accès configuration
///
/// ÉTAT ACTUEL:
/// - Firebase: Désactivé (config dummy pour éviter erreurs)
/// - Environnements: Development et Production supportés
/// - Images: Optimisation configurée (maxSize, qualité)
/// - État: Stable après suppression Firebase
///
/// HISTORIQUE RÉCENT:
/// - Suppression Firebase (garde config dummy pour compatibilité)
/// - Remplacement credentials Firebase par placeholders
/// - Nettoyage exports firebase_config_prod.dart
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Firebase config: Garder placeholders non-vides (évite crashes)
/// - Environment detection: Basé sur kDebugMode Flutter
/// - Freezed generation: Nécessaire après modifications
/// - Immutabilité: Toutes configs sont immutables
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter configuration pour cache images
/// - Implémenter feature flags dynamiques
/// - Optimiser config pour performance différents devices
/// - Considérer configuration utilisateur persistante
///
/// 🔗 FICHIERS LIÉS:
/// - app/config/index.dart: Export central configurations
/// - app/config/app_config.freezed.dart: Code généré Freezed
/// - main.dart: Utilisation configuration principale
///
/// CRITICALITÉ: ⭐⭐⭐⭐⭐ (Configuration centrale critique)
/// </cursor>
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';

enum Environment {
  development,
  staging,
  production,
}

@freezed
class FirebaseConfig with _$FirebaseConfig {
  const factory FirebaseConfig({
    required String apiKey,
    required String projectId,
    required String storageBucket,
    required String appId,
    required String messagingSenderId,
    String? iosClientId,
  }) = _FirebaseConfig;
}

@freezed
class ImageConfig with _$ImageConfig {
  const factory ImageConfig({
    required int maxDimension,
    required int quality,
    required int maxFileSize,
    required List<String> supportedFormats,
  }) = _ImageConfig;

  factory ImageConfig.standard() => const ImageConfig(
        maxDimension: 1024,
        quality: 85,
        maxFileSize: 5 * 1024 * 1024,
        supportedFormats: ['jpg', 'jpeg', 'png'],
      );
}

@freezed
class AppConfig with _$AppConfig {
  const AppConfig._();

  const factory AppConfig({
    required String appName,
    required String version,
    required Environment environment,
    required FirebaseConfig firebase,
    required ImageConfig imageConfig,
    @Default(false) bool isDebugMode,
    @Default(true) bool enableAnalytics,
    @Default(true) bool enableCrashlytics,
  }) = _AppConfig;

  factory AppConfig.development() => AppConfig(
        appName: 'PuzzHub Dev',
        version: '1.0.0',
        environment: Environment.development,
        firebase: const FirebaseConfig(
          apiKey: 'disabled',
          projectId: 'luchy-app',
          storageBucket: 'luchy-app.firebaseapp.com',
          appId: '1:000000000000:ios:disabled',
          messagingSenderId: '000000000000',
        ),
        imageConfig: ImageConfig.standard(),
        isDebugMode: true,
        enableAnalytics: false,
        enableCrashlytics: false,
      );

  factory AppConfig.production() => AppConfig(
        appName: 'PuzzHub',
        version: '1.0.0',
        environment: Environment.production,
        firebase: const FirebaseConfig(
          apiKey: 'disabled',
          projectId: 'luchy-app',
          storageBucket: 'luchy-app.firebaseapp.com',
          appId: '1:000000000000:ios:disabled',
          messagingSenderId: '000000000000',
        ),
        imageConfig: ImageConfig.standard(),
        isDebugMode: false,
        enableAnalytics: true,
        enableCrashlytics: true,
      );
}

final configProvider = Provider<AppConfig>((ref) {
  if (kDebugMode) {
    return AppConfig.development();
  }
  return AppConfig.production();
});
