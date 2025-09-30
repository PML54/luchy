#!/bin/bash

echo "📸 OPTIMISATION SCREENSHOTS POUR GOOGLE PLAY"
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

# Créer le dossier de sortie
mkdir -p assets/screenshots/google_play

echo "🔧 Optimisation des screenshots..."

# Fonction pour optimiser un screenshot
optimize_screenshot() {
    local input="$1"
    local name="$2"
    
    if [ -f "$input" ]; then
        echo "📱 Optimisation: $name"
        
        # Version téléphone (1080x1920)
        magick "$input" -resize 1080x1920 -background white -gravity center -extent 1080x1920 "assets/screenshots/google_play/${name}_phone.png"
        
        # Version tablette 7" (1024x600)
        magick "$input" -resize 1024x600 -background white -gravity center -extent 1024x600 "assets/screenshots/google_play/${name}_tablet_7inch.png"
        
        # Version tablette 10" (1280x800)
        magick "$input" -resize 1280x800 -background white -gravity center -extent 1280x800 "assets/screenshots/google_play/${name}_tablet_10inch.png"
        
        echo "✅ $name optimisé"
    else
        echo "❌ Fichier non trouvé: $input"
    fi
}

# Optimiser chaque screenshot
optimize_screenshot "assets/screenshots/ecran principal.png" "01_ecran_principal"
optimize_screenshot "assets/screenshots/Puzzle.png" "02_puzzle"
optimize_screenshot "assets/screenshots/evaluation.png" "03_evaluation"
optimize_screenshot "assets/screenshots/Liste Eval .png" "04_liste_evaluations"
optimize_screenshot "assets/screenshots/Carnet Notes.png" "05_carnet_notes"

echo ""
echo "✅ Optimisation terminée !"
echo ""
echo "📁 Fichiers créés dans: assets/screenshots/google_play/"
echo ""
echo "📱 Formats disponibles:"
echo "   - _phone.png (1080x1920) - Téléphones"
echo "   - _tablet_7inch.png (1024x600) - Tablettes 7 pouces"
echo "   - _tablet_10inch.png (1280x800) - Tablettes 10 pouces"
echo ""
echo "🚀 Prêt pour Google Play Console !"

