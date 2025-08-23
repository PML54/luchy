# 🚀 Guide de Déploiement - Luchy

Instructions pour déployer l'application Luchy sur les différentes plateformes et stores.

## 📱 Déploiement iOS

### App Store Connect (Distribution publique)

#### 1. Préparation
```bash
# Version release avec optimisations
flutter build ios --release

# Ouvrir le projet Xcode
open ios/Runner.xcworkspace
```

#### 2. Configuration Xcode
- **Bundle Identifier** : `com.pml.luchy`
- **Version** : `1.1.0`
- **Build Number** : `2`
- **Team** : 7UET4XCU34

#### 3. Archive et Upload
1. Dans Xcode : Product → Archive
2. Organizer → Distribute App
3. App Store Connect → Upload

#### 4. App Store Connect
- Créer une nouvelle version d'app
- Ajouter descriptions et captures d'écran
- Configurer les métadonnées
- Soumettre pour review

### TestFlight (Distribution test)
```bash
# Même process qu'App Store mais sélectionner TestFlight
# Inviter les testeurs par email
```

### Distribution Ad Hoc (Installation directe)
```bash
# Build avec profil Ad Hoc
flutter install --device-id=DEVICE_ID
```

## 🤖 Déploiement Android

### Google Play Store (Distribution publique)

#### 1. Préparation de l'AAB
```bash
# Build Android App Bundle (recommandé)
flutter build appbundle --release

# L'AAB sera dans : build/app/outputs/bundle/release/app-release.aab
```

#### 2. Signature de l'app
```bash
# Créer un keystore (première fois)
keytool -genkey -v -keystore luchy-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias luchy

# Configurer android/key.properties
```

#### 3. Google Play Console
1. Créer une nouvelle app
2. Upload de l'AAB
3. Configurer store listing
4. Définir le contenu rating
5. Publier en production/test

### Distribution APK directe
```bash
# Générer APK signé
flutter build apk --release

# Partager le fichier APK
# Utilisateurs doivent activer "Sources inconnues"
```

### Distribution via Firebase App Distribution
```bash
# Installer Firebase CLI
npm install -g firebase-tools

# Upload vers Firebase
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app APP_ID \
  --groups testers
```

## 🌐 Déploiement Web (optionnel)

### Build Web
```bash
flutter build web --release

# Les fichiers seront dans : build/web/
```

### Hébergement
- **Firebase Hosting**
- **GitHub Pages** 
- **Netlify**
- **Serveur web classique**

## 🔐 Signature et Sécurité

### Configuration iOS
- **Automatique** : Xcode gère la signature
- **Team ID** : 7UET4XCU34
- **Profils** : Gérés automatiquement

### Configuration Android
```properties
# android/key.properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=luchy
storeFile=../luchy-keystore.jks
```

## 📊 Métadonnées des stores

### Descriptions

**Français :**
> Luchy - Une application de puzzle moderne qui apporte chance et amusement ! Créez des puzzles personnalisés à partir de vos photos ou jouez avec notre collection d'œuvres d'art classiques. Interface bilingue, niveaux de difficulté variables, parfait pour toute la famille !

**Anglais :**
> Luchy - A modern puzzle game that brings luck and fun to your day! Create custom puzzles from your photos or play with our collection of classic artworks. Bilingual interface, variable difficulty levels, perfect for the whole family!

### Mots-clés
- puzzle, jeu, photo, art, famille
- puzzle, game, photo, art, family

### Captures d'écran requises
- **iOS** : iPhone 6.7", iPhone 6.5", iPhone 5.5", iPad Pro
- **Android** : Phone, 7" Tablet, 10" Tablet

## 🎯 Stratégie de version

### Numbering
- **Version** : X.Y.Z (Semantic Versioning)
- **Build** : Incrémental pour chaque build

### Releases
1. **Alpha** : Tests internes
2. **Beta** : TestFlight/Internal Testing
3. **Release Candidate** : Tests finaux
4. **Production** : Store public

## 📈 Suivi et Analytics

### iOS
- **App Store Connect** : Téléchargements, revenus
- **Firebase Analytics** : Utilisation in-app

### Android  
- **Google Play Console** : Statistiques détaillées
- **Firebase Analytics** : Comportement utilisateur

## ⚠️ Checklist avant déploiement

- [ ] Tests sur appareils réels
- [ ] Vérification des icônes
- [ ] Test de localisation FR/EN
- [ ] Message de félicitations accessible
- [ ] Performances optimisées
- [ ] Aucune donnée de debug
- [ ] Version incrémentée
- [ ] Changelog mis à jour

---

**Note :** Luchy v1.1.0+2 contient un message spécial pour le mariage de Mathieu & Noëllie 💐
