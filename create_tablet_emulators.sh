#!/bin/bash

echo "📱 CRÉATION SIMULATEURS TABLETTES ANDROID"
echo "=========================================="
echo ""

# Vérifier si Android SDK est installé
if ! command -v avdmanager &> /dev/null; then
    echo "❌ Android SDK/avdmanager non trouvé"
    echo "   Installez Android Studio et configurez le SDK"
    exit 1
fi

echo "✅ Android SDK trouvé"
echo ""

# Créer simulateur tablette 7 pouces
echo "🔧 Création simulateur tablette 7 pouces..."
avdmanager create avd -n "Tablet_7inch" -k "system-images;android-34;google_apis;x86_64" -d "pixel_c"

if [ $? -eq 0 ]; then
    echo "✅ Simulateur tablette 7 pouces créé: Tablet_7inch"
else
    echo "❌ Erreur création simulateur 7 pouces"
fi

echo ""

# Créer simulateur tablette 10 pouces
echo "🔧 Création simulateur tablette 10 pouces..."
avdmanager create avd -n "Tablet_10inch" -k "system-images;android-34;google_apis;x86_64" -d "pixel_c"

if [ $? -eq 0 ]; then
    echo "✅ Simulateur tablette 10 pouces créé: Tablet_10inch"
else
    echo "❌ Erreur création simulateur 10 pouces"
fi

echo ""
echo "📱 Simulateurs créés !"
echo ""
echo "🚀 Pour lancer les simulateurs:"
echo "   flutter emulators --launch Tablet_7inch"
echo "   flutter emulators --launch Tablet_10inch"
echo ""
echo "📸 Pour prendre des screenshots:"
echo "   1. Lancer le simulateur"
echo "   2. Lancer l'app: flutter run"
echo "   3. Prendre des captures d'écran"

