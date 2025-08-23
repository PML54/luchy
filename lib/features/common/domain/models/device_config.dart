/// <cursor>
/// LUCHY - Configuration et capacités des appareils
///
/// Modèles de données pour gérer la configuration spécifique
/// aux appareils avec détection des capacités hardware/software.
///
/// COMPOSANTS PRINCIPAUX:
/// - DeviceConfig: Configuration principale device avec capabilities
/// - DeviceCapabilities: Gestion capacités (Dynamic Island, notch, haptics)
/// - DeviceType: Énumération complète appareils iOS (iPhone, iPad)
/// - Screen metrics: Dimensions, orientation, safe areas
/// - Feature detection: Dark mode, haptics, camera, etc.
///
/// ÉTAT ACTUEL:
/// - Support: iPhone SE à iPhone 15 Pro Max, tous iPads
/// - Détection: Dynamic Island, notch, bouton home
/// - Capacités: Haptics, dark mode, caméra, galerie
/// - Métriques: Taille écran, orientation, safe areas temps réel
///
/// HISTORIQUE RÉCENT:
/// - Ajout support iPhone 15 series avec Dynamic Island
/// - Amélioration détection capacités par model string
/// - Optimisation gestion changements orientation
/// - Documentation mise à jour format <cursor>
///
/// 🔧 POINTS D'ATTENTION:
/// - Device detection: Basé sur model strings (fragile si Apple change)
/// - Enum maintenance: Ajouter nouveaux devices lors releases Apple
/// - Capability accuracy: Tester détection sur vrais devices
/// - Performance: Cache résultats détection pour éviter recalculs
///
/// 🚀 PROCHAINES ÉTAPES:
/// - Ajouter support appareils pliables/futurs form factors
/// - Implémenter détection automatique nouvelles capacités
/// - Optimiser pour tablets et grands écrans
/// - Intégrer avec système adaptation UI automatique
///
/// 🔗 FICHIERS LIÉS:
/// - features/common/domain/providers/device_config_provider.dart: Gestion état
/// - device_config.freezed.dart: Code généré Freezed
/// - main.dart: Utilisation pour configuration thème
///
/// CRITICALITÉ: ⭐⭐⭐⭐ (Adaptation UI fondamentale)
/// </cursor>
/// - Immutable state using freezed
/// - Copyable configurations
/// - Type-safe device enumeration
///
/// HISTORY:
/// v1.0 (2024-01-30):
/// - Initial documentation
/// - Documented main classes and enums
/// - Added structure and state management sections
///
/// </claude>
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_config.freezed.dart';

/// Primary configuration class for device-specific settings.
///
/// Manages the complete device configuration for the application, ensuring
/// proper adaptation across different iOS devices and screen sizes.
/// This configuration is used throughout the app to make device-specific
/// adjustments and optimizations.
///
/// Key features:
/// * Screen dimensions and resolution management
/// * Device orientation handling
/// * Hardware feature detection
/// * UI safety zones adaptation
/// * System capabilities tracking
///
/// Usage:
/// ```dart
/// final config = DeviceConfig(
///   screenSize: Size(390, 844),
///   pixelRatio: 2.0,
///   orientation: Orientation.portrait,
///   deviceType: DeviceType.iPhone13,
///   ...
/// );
/// ```
@freezed
class DeviceConfig with _$DeviceConfig {
  const factory DeviceConfig({
    /// Current screen dimensions
    required Size screenSize,

    /// Device pixel ratio for scaling calculations
    required double pixelRatio,

    /// Current device orientation
    required Orientation orientation,

    /// Specific device model identification
    required DeviceType deviceType,

    /// Safe area insets for UI adaptation
    required EdgeInsets safeArea,

    /// Indicates presence of a display notch
    required bool hasNotch,

    /// Indicates presence of Dynamic Island (iPhone 14 Pro and later)
    required bool hasDynamicIsland,

    /// Device hardware and software capabilities
    required DeviceCapabilities capabilities,
  }) = _DeviceConfig;
}

/// Comprehensive tracking of device hardware and software capabilities.
///
/// This class provides a centralized way to track and query various
/// device capabilities that affect app functionality. It helps in making
/// feature availability decisions and UI adaptations.
///
/// Usage:
/// ```dart
/// final capabilities = DeviceCapabilities(
///   hasCamera: true,
///   hasGalleryAccess: true,
///   supportsDarkMode: true,
///   ...
/// );
/// ```
@freezed
class DeviceCapabilities with _$DeviceCapabilities {
  const factory DeviceCapabilities({
    /// Indicates if device has a camera
    required bool hasCamera,

    /// Indicates if app has gallery access permissions
    required bool hasGalleryAccess,

    /// Indicates if device supports haptic feedback
    required bool hasHapticFeedback,

    /// Indicates if device supports dark mode
    required bool supportsDarkMode,

    /// Indicates if device supports file sharing
    required bool hasFileSharing,
  }) = _DeviceCapabilities;
}

/// Comprehensive enumeration of supported iOS devices.
///
/// This enum provides a complete list of supported iOS devices,
/// used for device-specific optimizations and feature availability checks.
/// Each device type may have specific handling in various parts of the app.
///
/// Usage:
/// ```dart
/// if (deviceType == DeviceType.iPhone14Pro) {
///   // Handle Dynamic Island
/// }
/// ```
enum DeviceType {
  /// iPhone SE (1st and 2nd generation)
  iPhoneSE,

  /// iPhone 8 4.7" display
  iPhone8,

  /// iPhone 8 Plus 5.5" display
  iPhone8Plus,

  /// Original iPhone X with notch
  iPhoneX,

  /// iPhone XS 5.8" OLED display
  iPhoneXS,

  /// iPhone XS Max 6.5" OLED display
  iPhoneXSMax,

  /// iPhone XR 6.1" LCD display
  iPhoneXR,

  /// iPhone 11 6.1" LCD display
  iPhone11,

  /// iPhone 11 Pro 5.8" OLED display
  iPhone11Pro,

  /// iPhone 11 Pro Max 6.5" OLED display
  iPhone11ProMax,

  /// iPhone 12 mini 5.4" OLED display
  iPhone12Mini,

  /// iPhone 12 6.1" OLED display
  iPhone12,

  /// iPhone 12 Pro 6.1" OLED display
  iPhone12Pro,

  /// iPhone 12 Pro Max 6.7" OLED display
  iPhone12ProMax,

  /// iPhone 13 mini 5.4" OLED display
  iPhone13Mini,

  /// iPhone 13 6.1" OLED display
  iPhone13,

  /// iPhone 13 Pro 6.1" OLED display
  iPhone13Pro,

  /// iPhone 13 Pro Max 6.7" OLED display
  iPhone13ProMax,

  /// iPhone 14 6.1" OLED display
  iPhone14,

  /// iPhone 14 Plus 6.7" OLED display
  iPhone14Plus,

  /// iPhone 14 Pro with Dynamic Island
  iPhone14Pro,

  /// iPhone 14 Pro Max with Dynamic Island
  iPhone14ProMax,

  /// iPhone 15 6.1" OLED display
  iPhone15,

  /// iPhone 15 Plus 6.7" OLED display
  iPhone15Plus,

  /// iPhone 15 Pro with Dynamic Island
  iPhone15Pro,

  /// iPhone 15 Pro Max with Dynamic Island
  iPhone15ProMax,

  /// iPad Mini (all supported generations)
  iPadMini,

  /// iPad 9th generation
  iPad9,

  /// iPad 10th generation
  iPad10,

  /// iPad Air (latest supported models)
  iPadAir,

  /// iPad Pro 11" models
  iPadPro11,

  /// iPad Pro 12.9" models
  iPadPro12_9,

  /// Unknown or unsupported device
  unknown
}
