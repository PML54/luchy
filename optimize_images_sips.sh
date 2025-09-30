#!/bin/bash

echo "🖼️  Optimisation des images épicerie avec sips..."
echo "📊 Taille avant optimisation:"
ls -lh assets/epicerie-*.jpg | awk '{print $5, $9}' | head -5

echo ""
echo "🔧 Optimisation en cours..."

# Créer un dossier de sauvegarde
mkdir -p assets/backup
cp assets/epicerie-*.jpg assets/backup/

# Optimiser toutes les images épicerie avec sips
for file in assets/epicerie-*.jpg; do
    if [ -f "$file" ]; then
        echo "Optimisation: $file"
        # Redimensionner à 1024px max + compression
        sips -Z 1024 -s formatOptions 80 "$file" > /dev/null 2>&1
    fi
done

echo ""
echo "✅ Optimisation terminée!"
echo "📊 Taille après optimisation:"
ls -lh assets/epicerie-*.jpg | awk '{print $5, $9}' | head -5

echo ""
echo "💾 Sauvegarde dans assets/backup/"
echo "📈 Réduction de taille estimée: 60-70%"
