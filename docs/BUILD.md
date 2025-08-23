# 🔨 Instructions de Build - Luchy

Guide complet pour construire et déployer l'application Luchy sur différentes plateformes.

## 📋 Prérequis

### Environnement de développement
- **Flutter** 3.35.1 ou supérieur
- **Dart** 3.5 ou supérieur
- **Xcode** 16.4+ (pour iOS)
- **Android Studio** ou Android SDK (pour Android)

### Vérification de l'environnement
```bash
flutter doctor
```

## 🍎 Build iOS

### Prérequis iOS
- macOS avec Xcode installé
- Compte développeur Apple configuré
- Certificats de signature valides

### Construction
```bash
# Nettoyer le projet
flutter clean

# Récupérer les dépendances
flutter pub get

# Construire pour iOS (release)
flutter build ios --release

# Installation sur appareil connecté
flutter install --device-id=YOUR_DEVICE_ID
```

### Génération des icônes iOS
```bash
# Générer toutes les tailles d'icônes
dart run flutter_launcher_icons
```

## 🤖 Build Android

### Prérequis Android
- Android SDK installé
- Java/Kotlin configuré
- Variables d'environnement Android

### Construction APK
```bash
# Créer la configuration Android (si première fois)
flutter create --platforms android .

# Générer les icônes Android
dart run flutter_launcher_icons

# Construire l'APK (release)
flutter build apk --release

# L'APK sera dans : build/app/outputs/flutter-apk/app-release.apk
```

### Installation sur appareil
```bash
# Via ADB (si débogage USB activé)
flutter install --device-id=YOUR_ANDROID_DEVICE

# Ou copier manuellement l'APK sur l'appareil
cp build/app/outputs/flutter-apk/app-release.apk ~/Desktop/Luchy-Android.apk
```

## 🎨 Gestion des icônes

### Configuration dans pubspec.yaml
```yaml
flutter_launcher_icons:
  ios: true
  android: true
  image_path: "assets/icon/luchy_village_sign.png"
  image_path_ios: "assets/icon/luchy_village_sign.png"
  image_path_android: "assets/icon/luchy_village_sign.png"
  remove_alpha_ios: true
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/luchy_village_sign.png"
```

### Régénération des icônes
```bash
# Après modification de l'icône source
dart run flutter_launcher_icons
```

## 🌐 Localisation

### Mise à jour des traductions
```bash
# Générer les fichiers de localisation
flutter gen-l10n
```

### Fichiers de langue
- `lib/l10n/app_fr.arb` - Français
- `lib/l10n/app_en.arb` - Anglais

## 🔄 Workflow de développement

### 1. Modifications du code
```bash
# Mode développement avec hot reload
flutter run --debug
```

### 2. Tests
```bash
# Exécuter les tests
flutter test
```

### 3. Release
```bash
# Nettoyer
flutter clean

# Build pour toutes les plateformes
flutter build ios --release
flutter build apk --release
```

## 🚨 Dépannage

### Problèmes courants

**iOS ne compile pas :**
```bash
# Nettoyer les pods
cd ios && rm -rf Pods Podfile.lock && cd ..
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

**Android ne compile pas :**
```bash
# Nettoyer gradle
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get
```

**Icônes ne s'affichent pas :**
```bash
# Régénérer les icônes
dart run flutter_launcher_icons
flutter clean
flutter build
```

## 📊 Tailles des builds

- **iOS (iPhone)** : ~27.4 MB
- **Android (APK)** : ~60.2 MB

## 🔧 Variables d'environnement

Aucune variable d'environnement spéciale requise pour Luchy.

---

**Note :** Ces instructions sont spécifiques à Luchy v1.1.0+2
