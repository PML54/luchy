/// Configuration temporaire sans Freezed pour test
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Environment {
  development,
  staging,
  production,
}

class FirebaseConfig {
  const FirebaseConfig({
    required this.apiKey,
    required this.projectId,
    required this.storageBucket,
    required this.appId,
    required this.messagingSenderId,
    this.iosClientId,
  });

  final String apiKey;
  final String projectId;
  final String storageBucket;
  final String appId;
  final String messagingSenderId;
  final String? iosClientId;
}

class ImageConfig {
  const ImageConfig({
    required this.maxDimension,
    required this.maxFileSize,
    required this.quality,
    required this.supportedFormats,
  });

  final int maxDimension;
  final int maxFileSize;
  final int quality;
  final List<String> supportedFormats;

  static ImageConfig standard() => const ImageConfig(
        maxDimension: 1024,
        maxFileSize: 5 * 1024 * 1024, // 5MB
        quality: 85,
        supportedFormats: ['jpg', 'jpeg', 'png'],
      );
}

class AppConfig {
  const AppConfig({
    required this.appName,
    required this.version,
    required this.environment,
    required this.firebase,
    required this.imageConfig,
    this.isDebugMode = false,
    this.enableAnalytics = true,
    this.enableCrashlytics = true,
  });

  final String appName;
  final String version;
  final Environment environment;
  final FirebaseConfig firebase;
  final ImageConfig imageConfig;
  final bool isDebugMode;
  final bool enableAnalytics;
  final bool enableCrashlytics;

  factory AppConfig.development() => AppConfig(
        appName: 'Luchy Dev',
        version: '1.1.0+3',
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
        appName: 'Luchy',
        version: '1.1.0+3',
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
  } else {
    return AppConfig.production();
  }
});
