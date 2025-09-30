#!/bin/bash

echo "🎨 CRÉATION ICÔNE ANDROID À PARTIR D'iOS"
echo "========================================"
echo ""

# Vérifier si ImageMagick est installé
if ! command -v magick &> /dev/null; then
    echo "❌ ImageMagick n'est pas installé"
    echo "   Installez avec: brew install imagemagick"
    exit 1
fi

echo "✅ ImageMagick trouvé"
echo ""

# Vérifier que l'icône iOS existe
if [ ! -f "luchy_icon_ios.png" ]; then
    echo "❌ Icône iOS non trouvée"
    exit 1
fi

echo "📱 Icône iOS trouvée: luchy_icon_ios.png"
echo ""

# Créer l'icône Android 512x512
echo "🔧 Création de l'icône Android 512x512..."

# Redimensionner à 512x512 avec fond blanc
magick luchy_icon_ios.png -resize 512x512 -background white -flatten luchy_icon_android_512.png

if [ $? -eq 0 ]; then
    echo "✅ Icône Android créée: luchy_icon_android_512.png"
    echo ""
    
    # Afficher les informations
    echo "📊 Informations de l'icône:"
    magick identify luchy_icon_android_512.png
    
    echo ""
    echo "🎯 Icône prête pour Google Play !"
    echo "   Fichier: luchy_icon_android_512.png"
    echo "   Taille: 512x512 pixels"
    echo "   Format: PNG avec fond blanc"
    echo ""
    echo "📱 Prochaines étapes:"
    echo "   1. Uploader luchy_icon_android_512.png dans Google Play Console"
    echo "   2. L'icône devrait être acceptée maintenant"
    echo ""
else
    echo "❌ Erreur lors de la création de l'icône"
    exit 1
fi

