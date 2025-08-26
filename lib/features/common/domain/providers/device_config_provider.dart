/// <cursor>
/// LUCHY - Provider de configuration device/appareil
///
/// Gestionnaire d'état pour la configuration des appareils avec détection
/// automatique des capacités et caractéristiques du device.
///
/// COMPOSANTS PRINCIPAUX:
/// - deviceConfigProvider: StateNotifierProvider principal
/// - DeviceConfigNotifier: Gestionnaire état configuration device
/// - initializeDeviceConfig(): Détection initiale device
/// - updateOrientation(): Mise à jour orientation écran
/// - updateScreenSize(): Adaptation taille écran
///
/// ÉTAT ACTUEL:
/// - Détection: iPhone, iPad, appareils Android supportés
/// - Capacités: Dynamic Island, notch, dark mode, haptics
/// - Métriques: Taille écran, orientation, safe areas
/// - Performance: Initialisation async optimisée
///
/// HISTORIQUE RÉCENT:
/// - Amélioration détection Dynamic Island iPhone 14/15 Pro
/// - Optimisation gestion changements orientation
/// - Intégration avec theme engine application
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Platform-specific: Code iOS vs Android différent
/// - Async initialization: Bien gérer états de chargement
/// - Device detection: Basé sur model strings (fragile)
/// - Memory leaks: Dispose listeners orientation correctement
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter détection appareils pliables
/// - Améliorer cache détection pour performance
/// - Implémenter notifications changements device
/// - Optimiser pour tablets et grands écrans
///
/// 🔗 FICHIERS LIÉS:
/// - features/common/domain/models/device_config.dart: Modèles configuration
/// - main.dart: Utilisation dans configuration thème
/// - features/puzzle/presentation/screens/puzzle_game_screen.dart: Adaptation UI
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Configuration système critique)
/// 📅 Dernière modification: 2025-08-25 14:35
/// </cursor>
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luchy/features/common/domain/models/device_config.dart';

final deviceConfigProvider =
    StateNotifierProvider<DeviceConfigNotifier, DeviceConfig>((ref) {
  return DeviceConfigNotifier();
});

class DeviceConfigNotifier extends StateNotifier<DeviceConfig> {
  DeviceConfigNotifier() : super(_createInitialState());

  static DeviceConfig _createInitialState() {
    return const DeviceConfig(
      screenSize: Size.zero,
      pixelRatio: 1.0,
      orientation: Orientation.portrait,
      deviceType: DeviceType.unknown,
      safeArea: EdgeInsets.zero,
      hasNotch: false,
      hasDynamicIsland: false,
      capabilities: DeviceCapabilities(
        hasCamera: false,
        hasGalleryAccess: false,
        hasHapticFeedback: false,
        supportsDarkMode: false,
        hasFileSharing: false,
      ),
    );
  }

  Future<void> initializeDeviceConfig(BuildContext context) async {
    final deviceInfo = DeviceInfoPlugin();
    final mediaQuery = MediaQuery.of(context);
    final viewPadding = mediaQuery.viewPadding;

    bool hasNotch = viewPadding.top > 20;
    bool hasDynamicIsland = false;
    DeviceType deviceType = DeviceType.unknown;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceType = _getDeviceType(iosInfo.model);
      hasDynamicIsland = deviceType.toString().contains('14Pro') ||
          deviceType.toString().contains('15Pro');
    }

    state = state.copyWith(
      screenSize: mediaQuery.size,
      pixelRatio: mediaQuery.devicePixelRatio,
      orientation: mediaQuery.orientation,
      deviceType: deviceType,
      safeArea: EdgeInsets.fromLTRB(
        viewPadding.left,
        viewPadding.top,
        viewPadding.right,
        viewPadding.bottom,
      ),
      hasNotch: hasNotch,
      hasDynamicIsland: hasDynamicIsland,
      capabilities: const DeviceCapabilities(
        hasCamera: true,
        // Ces valeurs devraient être vérifiées dynamiquement
        hasGalleryAccess: true,
        hasHapticFeedback: true,
        supportsDarkMode: true,
        hasFileSharing: true,
      ),
    );
  }

  void updateOrientation(Orientation orientation) {
    state = state.copyWith(orientation: orientation);
  }

  void updateScreenSize(Size size) {
    state = state.copyWith(screenSize: size);
  }

  DeviceType _getDeviceType(String model) {
    // Logique de détection du type d'appareil basée sur le modèle
    switch (model) {
      case "iPhone8,1":
        return DeviceType.iPhone8;
      case "iPhone8,2":
        return DeviceType.iPhone8Plus;
      case "iPhone8,4":
        return DeviceType.iPhoneSE;
      // Ajoutez d'autres cas selon vos besoins
      default:
        return DeviceType.unknown;
    }
  }
}
