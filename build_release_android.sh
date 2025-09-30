#!/bin/bash

echo "🤖 BUILD RELEASE ANDROID POUR GOOGLE PLAY"
echo "=========================================="
echo ""

# Vérifier que key.properties existe
if [ ! -f "android/key.properties" ]; then
    echo "❌ Fichier key.properties manquant"
    echo "   Exécutez d'abord: ./generate_keystore.sh"
    exit 1
fi

echo "✅ Configuration de signature trouvée"
echo ""

# Nettoyer le build précédent
echo "🧹 Nettoyage du build précédent..."
flutter clean

# Récupérer les dépendances
echo "📦 Récupération des dépendances..."
flutter pub get

# Build AAB pour Google Play
echo "🔨 Build AAB (Android App Bundle)..."
flutter build appbundle --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build AAB réussi !"
    echo "📁 Fichier: build/app/outputs/bundle/release/app-release.aab"
    echo ""
    echo "🚀 Prêt pour Google Play Console !"
    echo ""
    echo "📋 Étapes suivantes:"
    echo "   1. Ouvrir Google Play Console"
    echo "   2. Créer une nouvelle application"
    echo "   3. Uploader app-release.aab"
    echo "   4. Remplir les informations de l'app"
    echo "   5. Publier !"
else
    echo "❌ Erreur lors du build AAB"
    exit 1
fi

