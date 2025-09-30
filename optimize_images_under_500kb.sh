#!/bin/bash

# Script d'optimisation des images sous 500KB
# Utilise ImageMagick pour réduire la taille des images

echo "🖼️  Optimisation des images sous 500KB..."

# Créer un dossier de sauvegarde
mkdir -p assets_backup
cp assets/*.jpg assets/*.png assets/*.jpeg assets_backup/ 2>/dev/null

# Fonction pour optimiser une image
optimize_image() {
    local file="$1"
    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    
    if [ "$size" -gt 512000 ]; then  # 500KB = 512000 bytes
        echo "📉 Optimisation de $file ($(($size/1024))KB)"
        
        # Calculer la qualité nécessaire pour atteindre ~400KB
        local target_size=400000
        local quality=85
        
        # Essayer différentes qualités
        for q in 85 80 75 70 65 60 55 50; do
            convert "$file" -quality $q -strip "$file.tmp"
            local new_size=$(stat -f%z "$file.tmp" 2>/dev/null || stat -c%s "$file.tmp" 2>/dev/null)
            
            if [ "$new_size" -lt "$target_size" ]; then
                mv "$file.tmp" "$file"
                echo "✅ $file optimisé: $(($size/1024))KB → $(($new_size/1024))KB (qualité: $q)"
                break
            fi
        done
        
        # Si toujours trop gros, réduire les dimensions
        if [ "$new_size" -gt 512000 ]; then
            echo "📐 Réduction des dimensions de $file"
            convert "$file" -resize 80% -quality 70 -strip "$file.tmp"
            mv "$file.tmp" "$file"
            local final_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
            echo "✅ $file redimensionné: $(($final_size/1024))KB"
        fi
    else
        echo "✅ $file déjà optimisé ($(($size/1024))KB)"
    fi
}

# Optimiser toutes les images
for file in assets/*.jpg assets/*.png assets/*.jpeg; do
    if [ -f "$file" ]; then
        optimize_image "$file"
    fi
done

echo ""
echo "📊 Résumé des optimisations:"
echo "=========================="
ls -la assets/*.jpg assets/*.png assets/*.jpeg 2>/dev/null | awk '{print $5, $9}' | sort -nr | head -10

echo ""
echo "🎉 Optimisation terminée!"
echo "💾 Sauvegarde dans: assets_backup/"



