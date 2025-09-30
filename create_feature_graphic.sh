#!/bin/bash

echo "🎨 CRÉATION IMAGE DE PRÉSENTATION GOOGLE PLAY"
echo "============================================="
echo ""

# Vérifier si ImageMagick est installé
if ! command -v magick &> /dev/null; then
    echo "❌ ImageMagick n'est pas installé"
    echo "   Installez avec: brew install imagemagick"
    exit 1
fi

echo "✅ ImageMagick trouvé"
echo ""

# Créer l'image de présentation 1024x500
echo "🔧 Création de l'image de présentation 1024x500..."

# Créer un fond dégradé bleu-vert
magick -size 1024x500 gradient:blue-green luchy_feature_bg.png

# Ajouter du texte avec le nom de l'app
magick luchy_feature_bg.png \
  -font Arial-Bold \
  -pointsize 72 \
  -fill white \
  -stroke black \
  -strokewidth 2 \
  -gravity center \
  -annotate +0-50 "LUCHY" \
  -pointsize 32 \
  -fill white \
  -stroke black \
  -strokewidth 1 \
  -annotate +0+30 "Puzzle Éducatif & Évaluations" \
  luchy_feature_graphic.png

if [ $? -eq 0 ]; then
    echo "✅ Image de présentation créée: luchy_feature_graphic.png"
    echo ""
    
    # Afficher les informations
    echo "📊 Informations de l'image:"
    magick identify luchy_feature_graphic.png
    
    echo ""
    echo "🎯 Image prête pour Google Play !"
    echo "   Fichier: luchy_feature_graphic.png"
    echo "   Taille: 1024x500 pixels"
    echo "   Format: PNG"
    echo ""
    echo "📱 Prochaines étapes:"
    echo "   1. Uploader luchy_feature_graphic.png dans Google Play Console"
    echo "   2. L'image devrait être acceptée maintenant"
    echo ""
else
    echo "❌ Erreur lors de la création de l'image"
    exit 1
fi

