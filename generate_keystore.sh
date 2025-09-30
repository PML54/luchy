#!/bin/bash

echo "🔐 GÉNÉRATION KEYSTORE POUR GOOGLE PLAY"
echo "======================================="
echo ""
echo "📱 Ce script va créer un keystore pour signer votre APK/AAB"
echo ""

# Vérifier si Java est installé
if ! command -v keytool &> /dev/null; then
    echo "❌ Java keytool n'est pas installé"
    echo "   Installez Java JDK pour continuer"
    exit 1
fi

echo "✅ Java keytool trouvé"
echo ""

# Demander les informations
read -p "📝 Nom du keystore (ex: luchy-release-key.jks): " KEYSTORE_NAME
read -p "📝 Alias de la clé (ex: luchy-key): " KEY_ALIAS
read -p "📝 Mot de passe du keystore: " -s STORE_PASSWORD
echo ""
read -p "📝 Mot de passe de la clé: " -s KEY_PASSWORD
echo ""
read -p "📝 Nom complet (ex: PML): " FULL_NAME
read -p "📝 Organisation (ex: PML Studio): " ORGANIZATION
read -p "📝 Ville (ex: Paris): " CITY
read -p "📝 État/Région (ex: IDF): " STATE
read -p "📝 Code pays (ex: FR): " COUNTRY

echo ""
echo "🔐 Génération du keystore..."

# Générer le keystore
keytool -genkey -v -keystore "$KEYSTORE_NAME" -alias "$KEY_ALIAS" -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass "$STORE_PASSWORD" -keypass "$KEY_PASSWORD" \
    -dname "CN=$FULL_NAME, OU=$ORGANIZATION, O=$ORGANIZATION, L=$CITY, S=$STATE, C=$COUNTRY"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Keystore généré avec succès !"
    echo "📁 Fichier: $KEYSTORE_NAME"
    echo ""
    
    # Mettre à jour key.properties
    echo "🔧 Mise à jour de key.properties..."
    cat > android/key.properties << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=../$KEYSTORE_NAME
EOF
    
    echo "✅ key.properties mis à jour"
    echo ""
    echo "🚀 Prêt pour le build release !"
    echo "   Commande: flutter build appbundle --release"
    echo ""
    echo "⚠️  IMPORTANT:"
    echo "   - Sauvegardez votre keystore en lieu sûr"
    echo "   - Ne perdez jamais ce fichier !"
    echo "   - Google Play en a besoin pour les mises à jour"
else
    echo "❌ Erreur lors de la génération du keystore"
    exit 1
fi

