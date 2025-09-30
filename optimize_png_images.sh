#!/bin/bash

echo "🖼️  Optimisation des images PNG Mathieu..."
echo "📊 Taille avant optimisation:"
ls -lh assets/mathieu_*.png

echo ""
echo "🔧 Optimisation en cours..."

# Créer un dossier de sauvegarde
mkdir -p assets/backup
cp assets/mathieu_*.png assets/backup/

# Optimiser les images PNG avec sips
for file in assets/mathieu_*.png; do
    if [ -f "$file" ]; then
        echo "Optimisation: $file"
        # Redimensionner à 1024px max + compression
        sips -Z 1024 -s formatOptions 80 "$file" > /dev/null 2>&1
    fi
done

echo ""
echo "✅ Optimisation terminée!"
echo "📊 Taille après optimisation:"
ls -lh assets/mathieu_*.png

echo ""
echo "💾 Sauvegarde dans assets/backup/"
echo "📈 Réduction de taille estimée: 60-80%"
