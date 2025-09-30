#!/bin/bash

# Script d'optimisation finale des images sous 500KB
# Utilise la commande magick (ImageMagick v7) pour macOS

echo "🖼️  Optimisation finale des images sous 500KB..."

# Fonction pour optimiser une image avec magick
optimize_image() {
    local file="$1"
    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    
    if [ "$size" -gt 512000 ]; then  # 500KB = 512000 bytes
        echo "📉 Optimisation de $file ($(($size/1024))KB)"
        
        # Créer une copie temporaire
        cp "$file" "$file.backup"
        
        # Essayer différentes stratégies d'optimisation
        local success=false
        
        # Stratégie 1: Réduction de qualité pour JPG
        if [[ "$file" == *.jpg ]] || [[ "$file" == *.jpeg ]]; then
            for quality in 60 50 40 35 30; do
                magick "$file" -quality $quality -strip "$file.tmp" 2>/dev/null
                if [ $? -eq 0 ]; then
                    local new_size=$(stat -f%z "$file.tmp" 2>/dev/null || stat -c%s "$file.tmp" 2>/dev/null)
                    if [ "$new_size" -lt 512000 ]; then
                        mv "$file.tmp" "$file"
                        echo "✅ $file optimisé (JPG): $(($size/1024))KB → $(($new_size/1024))KB (qualité: $quality)"
                        success=true
                        break
                    fi
                fi
            done
        fi
        
        # Stratégie 2: Conversion PNG vers JPG pour les PNG volumineux
        if [ "$success" = false ] && [[ "$file" == *.png ]]; then
            local jpg_file="${file%.png}.jpg"
            magick "$file" -quality 70 -strip "$jpg_file" 2>/dev/null
            if [ $? -eq 0 ]; then
                local new_size=$(stat -f%z "$jpg_file" 2>/dev/null || stat -c%s "$jpg_file" 2>/dev/null)
                if [ "$new_size" -lt 512000 ]; then
                    mv "$jpg_file" "$file"
                    echo "✅ $file converti PNG→JPG: $(($size/1024))KB → $(($new_size/1024))KB"
                    success=true
                else
                    rm -f "$jpg_file"
                fi
            fi
        fi
        
        # Stratégie 3: Réduction des dimensions
        if [ "$success" = false ]; then
            for scale in 80 70 60 50; do
                magick "$file" -resize ${scale}% -quality 60 -strip "$file.tmp" 2>/dev/null
                if [ $? -eq 0 ]; then
                    local new_size=$(stat -f%z "$file.tmp" 2>/dev/null || stat -c%s "$file.tmp" 2>/dev/null)
                    if [ "$new_size" -lt 512000 ]; then
                        mv "$file.tmp" "$file"
                        echo "✅ $file redimensionné: $(($size/1024))KB → $(($new_size/1024))KB (${scale}%)"
                        success=true
                        break
                    fi
                fi
            done
        fi
        
        # Si toujours trop gros, restaurer la sauvegarde
        if [ "$success" = false ]; then
            mv "$file.backup" "$file"
            echo "⚠️  $file: impossible d'optimiser sous 500KB"
        else
            rm -f "$file.backup"
        fi
        
        rm -f "$file.tmp"
    else
        echo "✅ $file déjà optimisé ($(($size/1024))KB)"
    fi
}

# Optimiser toutes les images problématiques
problematic_files=(
    "assets/Picasso-Revefemme.png"
    "assets/HISTOIRE-CE1 - 3.jpeg"
    "assets/Picasso-FemmeTenantUnLivre.png"
    "assets/Picasso-FemmeAssiseAuBraceletMontre.png"
    "assets/mathieu_chanceux.png"
    "assets/mathieu_sailor_man.png"
    "assets/VVG-10.png"
    "assets/VVG-13.png"
    "assets/VVG-3.png"
)

for file in "${problematic_files[@]}"; do
    if [ -f "$file" ]; then
        optimize_image "$file"
    fi
done

echo ""
echo "📊 Vérification finale:"
echo "======================"
ls -la assets/*.jpg assets/*.png assets/*.jpeg 2>/dev/null | awk '{if($5 > 512000) print "❌ " $5, $9; else print "✅ " $5, $9}' | sort -nr

echo ""
echo "🎉 Optimisation terminée!"



