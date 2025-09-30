#!/bin/bash

echo "🍎 OPTIMISATION SCREENSHOTS iOS POUR APP STORE"
echo "=============================================="
echo ""

# Vérifier si ImageMagick est installé
if ! command -v magick &> /dev/null; then
    echo "❌ ImageMagick n'est pas installé"
    echo "   Installez avec: brew install imagemagick"
    exit 1
fi

echo "✅ ImageMagick trouvé"
echo ""

# Créer le dossier de sortie
mkdir -p assets/screenshots/app_store

echo "🔧 Optimisation des screenshots iOS..."

# Fonction pour optimiser un screenshot iOS
optimize_ios_screenshot() {
    local input="$1"
    local name="$2"
    
    if [ -f "$input" ]; then
        echo "📱 Optimisation: $name"
        
        # Version iPhone 6.7" (1290x2796) - iPhone 14 Pro Max, 15 Pro Max
        magick "$input" -resize 1290x2796 -background white -gravity center -extent 1290x2796 "assets/screenshots/app_store/${name}_iphone_67inch.png"
        
        # Version iPhone 6.5" (1242x2688) - iPhone 11 Pro Max, 12 Pro Max, 13 Pro Max
        magick "$input" -resize 1242x2688 -background white -gravity center -extent 1242x2688 "assets/screenshots/app_store/${name}_iphone_65inch.png"
        
        # Version iPhone 5.5" (1242x2208) - iPhone 6 Plus, 7 Plus, 8 Plus
        magick "$input" -resize 1242x2208 -background white -gravity center -extent 1242x2208 "assets/screenshots/app_store/${name}_iphone_55inch.png"
        
        # Version iPad Pro 12.9" (2048x2732)
        magick "$input" -resize 2048x2732 -background white -gravity center -extent 2048x2732 "assets/screenshots/app_store/${name}_ipad_129inch.png"
        
        # Version iPad Pro 11" (1668x2388)
        magick "$input" -resize 1668x2388 -background white -gravity center -extent 1668x2388 "assets/screenshots/app_store/${name}_ipad_11inch.png"
        
        echo "✅ $name optimisé"
    else
        echo "❌ Fichier non trouvé: $input"
    fi
}

# Optimiser chaque screenshot iOS
optimize_ios_screenshot "assets/screenshots/IOS-MAIN.jpeg" "01_ecran_principal"
optimize_ios_screenshot "assets/screenshots/IOS-PUZZLE.jpeg" "02_puzzle"
optimize_ios_screenshot "assets/screenshots/IOS-EVAL-MATHS.jpeg" "03_evaluation_maths"
optimize_ios_screenshot "assets/screenshots/IOS-LIST-EVAL.jpeg" "04_liste_evaluations"
optimize_ios_screenshot "assets/screenshots/IOS-BULLETIN.jpeg" "05_bulletin_notes"

echo ""
echo "✅ Optimisation terminée !"
echo ""
echo "📁 Fichiers créés dans: assets/screenshots/app_store/"
echo ""
echo "📱 Formats disponibles:"
echo "   - _iphone_67inch.png (1290x2796) - iPhone 14/15 Pro Max"
echo "   - _iphone_65inch.png (1242x2688) - iPhone 11/12/13 Pro Max"
echo "   - _iphone_55inch.png (1242x2208) - iPhone 6/7/8 Plus"
echo "   - _ipad_129inch.png (2048x2732) - iPad Pro 12.9\""
echo "   - _ipad_11inch.png (1668x2388) - iPad Pro 11\""
echo ""
echo "🍎 Prêt pour App Store Connect !"

