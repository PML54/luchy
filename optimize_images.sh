#!/bin/bash

echo "🖼️  Optimisation des images épicerie..."
echo "📊 Taille avant optimisation:"
ls -lh assets/epicerie-*.jpg | awk '{print $5, $9}' | head -5

echo ""
echo "🔧 Optimisation en cours..."

# Créer un dossier de sauvegarde
mkdir -p assets/backup
cp assets/epicerie-*.jpg assets/backup/

# Optimiser toutes les images épicerie
for file in assets/epicerie-*.jpg; do
    if [ -f "$file" ]; then
        echo "Optimisation: $file"
        # Redimensionner à 1024px max (garde les proportions) + qualité 80%
        magick "$file" -resize 1024x1024> -quality 80 "$file"
    fi
done

echo ""
echo "✅ Optimisation terminée!"
echo "📊 Taille après optimisation:"
ls -lh assets/epicerie-*.jpg | awk '{print $5, $9}' | head -5

echo ""
echo "💾 Sauvegarde dans assets/backup/"
echo "📈 Réduction de taille estimée: 60-70%"
